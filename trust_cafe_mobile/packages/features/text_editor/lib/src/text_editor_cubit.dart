import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:html/dom.dart';
import 'package:text_editor/src/typedefs.dart';
import 'package:image/image.dart' as img;

part 'text_editor_state.dart';

const _debugDisableUploadAndPublish = false;

final preHtmlExp = RegExp(r'(https?:\/\/[^\s<"]+)');
final postHtmlExp = RegExp(r'(https?:\/\/[^\s]+[^\s.);\]}<"])');

const supportedImageResizeFormats = [
  'jpg',
  'png',
  'gif',
  'bmp',
  'tiff',
  'tga',
  'pvr',
  'ico',
];

class TextEditorCubit extends Cubit<TextEditorState> {
  TextEditorCubit({
    required ContentRepository contentRepository,
    required this.destination,
    String? textHtml,
    bool? isCollaborative,
    String? cardUrl,
    String? blurLabel,
    this.profileSlug,
  }) :
        _contentRepository = contentRepository,
        super(TextEditorState(
          textHtml:textHtml ?? '',
          isCollaborative: isCollaborative ?? true,
          cardUrl: cardUrl ?? '',
          postToProfile: profileSlug != null,
          blurLabel: blurLabel,
      ));

  final String? profileSlug;
  final ContentRepository _contentRepository;
  final TextEditorDestination destination;
  final _imageUploadCache = <String,String>{};

  Future<void> publish() async {
    final htmlContent = Document.html(state.textHtml);
    final imageTags = htmlContent.getElementsByTagName('img');
    for (Element e in imageTags) {
      final imageTagAttributes = e.attributes;
      final src = imageTagAttributes['src']!;
      imageTagAttributes['class']='img-responsive';
      if(!src.startsWith('http')){
        emit(state.copyWith(processingImageUpload: true, imageUploadError: const Wrapped.value(null)));
        final basename = p.basename(src);
        final imageType = p.extension(src).replaceAll('.', '');
        if(_imageUploadCache[src]!=null){
          imageTagAttributes['src'] = _imageUploadCache[src]!;
          log('Got image url from cache: ${_imageUploadCache[src]}');
        } else {
          Uint8List? file;
          try{
            file = await File(src).readAsBytes();
          } catch(err) {
            e.replaceWith(Element.tag('p'));
            continue;
          }

          final initialLength = file.length;
          log('initialLength: $initialLength');
          try {
            if (state.compressImages && supportedImageResizeFormats.contains(imageType.toLowerCase())) {
              final img.Image? image = (await (img.Command()..decodeNamedImage(src, file)).executeThread()).outputImage;
              if (image == null) {
                log("Failed to decode image.");
              } else {
                final width = image.width;
                final height = image.height;
                log('width:$width;height:$height');
                final isSquare = width == height;
                final cmd = img.Command()..image(image);
                if ((isSquare && width>1280) || width > height && width > 1280 ||
                    height > width && height > 1280)
                {
                  log('resizing image command');
                  cmd.copyResize(
                    width: isSquare || width > height ? 1280 : null,
                    height: isSquare || height > width ? 1280 : null,
                    maintainAspect: true,);
                }

                late final Uint8List? encodedImage;
                if (imageType == 'jpg' || imageType == 'jpeg') {
                  log('encode jpg command');
                  cmd.encodeJpg(quality: 75);
                  await cmd.executeThread();
                  encodedImage = cmd.outputBytes;
                } else {
                  await cmd.executeThread();
                  log('encode no jpg');
                  encodedImage = cmd.outputImage!=null ? img.encodeNamedImage(src, cmd.outputImage!) : null;
                }
                log('output bytes: ${encodedImage?.length}');

                if (encodedImage != null && encodedImage.length<initialLength) {
                  file = encodedImage;
                }

              }
            }
          } catch(e){
            log(e.toString());
          }

          if(_debugDisableUploadAndPublish) continue;

          try{
            final url = await _contentRepository.uploadImage(
              file: file!,
              fileName: basename,
              contentType: 'image/$imageType',
            );
            log('Got image url: $url');
            imageTagAttributes['src'] = url;
            _imageUploadCache[src]=url;
          } catch (e) {
            log('ERROR while uploading image: $e');
            emit(state.copyWith(textHtml: htmlContent.body!.innerHtml, imageUploadError: Wrapped.value(e), processingImageUpload: false));
          }
        }
      }

      if(state.wrapImagesWithLinks){
        final parentIsNotLink = e.parent?.localName!='a';
        final copy = e.clone(true);
        final parent = parentIsNotLink ? Element.tag('a') : e.parent;
        if(copy.attributes['src']!=null){
          parent!.attributes['href']=copy.attributes['src']!;
        }
        parent!.attributes['target']='_blank';
        if(!state.hideImages) {
          parent.append(copy);
        } else {
          parent.text='[Open image]';
        }

        if(parentIsNotLink){
          e.replaceWith(parent);
        } else {
          e.parent!.replaceWith(parent);
        }
      }
    }

    emit(state.copyWith(processingImageUpload: false,));
    if(state.imageUploadError==null) {
      // print(htmlContent.body!.innerHtml);
      // emit(state.copyWith(textHtml: htmlContent.body!.innerHtml));
      if(_debugDisableUploadAndPublish) return;
      emit(state.copyWith(finalHtml: htmlContent.body!.innerHtml, textHtml: ''));
    }
  }

  void setStageEditing(){
    emit(state.copyWith(stage: TextEditorStage.editing));
  }

  void setStagePreview(String html, double maxWidth, bool isEditing) async {
    emit(state.copyWith(stage: TextEditorStage.preview, processingTextHtml: true));
    final htmlContent = Document.html(html);

    late final String? newCardUrl;
    if(state.cardUrl=='' && destination == TextEditorDestination.post && !isEditing){
      //Card url is empty, calculating the new one
      newCardUrl = _extractUrl(htmlContent.body!.innerHtml)?.replaceAll('&amp;', '&');
    } else {
      //Card url is not empty, leaving as it is(e.g. user updates someone's post)
      newCardUrl=null;
    }

    final plainText = htmlContent.body?.text ?? '';
    final characterCount = plainText.replaceAll(' ', '').length;

    emit(state.copyWith(
        textHtml: htmlContent.body!.innerHtml,
        cardUrl: newCardUrl,
        processingTextHtml: false,
        characterAmount: characterCount,
    ));
  }

  void changeIsCollaborative([bool? newValue]){
    emit(state.copyWith(isCollaborative: newValue ?? !state.isCollaborative));
  }

  void setSelectedBranch(Subwiki? newBranch){
    emit(state.copyWith(selectedBranch: Wrapped.value(newBranch)));
  }

  void changePostToProfile([bool? newValue]){
    emit(state.copyWith(postToProfile: newValue ?? !state.postToProfile));
  }

  void setCardUrl([String? newUrl]){
    emit(state.copyWith(cardUrl: _extractUrl(newUrl)?.replaceAll('&amp;', '&') ?? ''));
  }

  void switchWrapImagesWithLinks([bool? newValue]){
    final value = newValue ?? !state.wrapImagesWithLinks;
    emit(state.copyWith(wrapImagesWithLinks: value, hideImages: !value ? false : null));
  }

  void switchHideImages([bool? newValue]){
    emit(state.copyWith(hideImages: newValue ?? !state.hideImages));
  }

  void switchBlurLabel(String? label){
    emit(state.copyWith(blurLabel: Wrapped.value(label)));
  }

  void switchCompressImages([bool? newValue]){
    emit(state.copyWith(compressImages: newValue ?? !state.compressImages));
  }

  String? _extractUrl(String? source){
    if(source==null) return null;
    final preHtmlMatch = preHtmlExp.firstMatch(source)?[0];
    final postHtmlMatch = postHtmlExp.firstMatch(preHtmlMatch ?? '');
    final cardUrl = postHtmlMatch?[0];
    return cardUrl;
  }

}
