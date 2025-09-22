import 'dart:developer' as developer;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:component_library/component_library.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;

Future<int> fileSizeInBytes(String url) async {
  try {
    http.Response response = await http.head(Uri.parse(url));
    String? fileSize = response.headers["content-length"];

    if (fileSize == null) {
      return 0;
    }

    int bytes = int.parse(fileSize);
    if (bytes <= 0) {
      return 0;
    }

    return bytes;
  } catch (e) {
    return 0;
  }
}

class ImageData{
  final String src;
  final String? alt;

  final double? height;
  final double? width;

  const ImageData({
    required this.src,
    this.alt,
    this.height,
    this.width,
  });

  @override
  String toString() {
    return 'ImageTag{src: $src, alt: $alt, height: $height, width: $width}';
  }
}

enum ImageType {
  profile,
  post,
  spider
}

class AsyncImageViewer extends StatelessWidget {
  const AsyncImageViewer(this.tag,{
    required this.imageProvider,
    this.onImageRendered,
    this.imageFit = BoxFit.contain,
    this.type = ImageType.post,
    this.onErrorCallback,
    this.index = 0,
    this.allowActions = true,
    required this.imageSizeThreshold,
    super.key
  });
  static final Map<String, int> imageSizeCache = {};
  static final Set<String> existingImagesCache = {};

  final ImageData tag;

  final BoxFit imageFit;

  final void Function()? onImageRendered;

  final CustomImageProvider imageProvider;

  final ImageType type;
  final VoidCallback? onErrorCallback;
  final int index;
  final bool allowActions;
  final double? imageSizeThreshold;

  Widget get buildCachedImageViewer => ImageViewer(tag,
    imageProvider: imageProvider,
    onImageRendered: onImageRendered,
    imageFit: imageFit,
    type: type,
    onErrorCallback: onErrorCallback,
    index: index,
    allowActions: allowActions,
    imageSizeThreshold: imageSizeThreshold,
  );

  Widget get progressIndicator => type==ImageType.post
      ? const LinearProgressIndicator()
      : const ComponentProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final cacheManager = DefaultCacheManager();
    final src = tag.src;
    return existingImagesCache.contains(src) ? buildCachedImageViewer : FutureBuilder(
      future: cacheManager.getFileFromCache(src),
      builder: (context, snapshot) {
        if(snapshot.hasError) return _ErrorWidget(type: type, onErrorCallback: onErrorCallback);

        if(snapshot.hasData){
          if(snapshot.data!=null){
            existingImagesCache.add(src);
            return buildCachedImageViewer;
          }
        } else {
          final cachedSize = imageSizeCache[src];
          if(cachedSize!=null){
            if(cachedSize<=100) return _ErrorWidget(type: type, onErrorCallback: onErrorCallback);
            return ImageViewer(tag,
              imageProvider: imageProvider,
              onImageRendered: onImageRendered,
              imageFit: imageFit,
              type: type,
              onErrorCallback: onErrorCallback,
              index: index,
              allowActions: allowActions,
              sizeInBytes: cachedSize,
              imageSizeThreshold: imageSizeThreshold,
            );
          }

          return FutureBuilder(
            future: fileSizeInBytes(src),
            builder: (context, snapshot) {
              if(snapshot.hasError) return _ErrorWidget(type: type, onErrorCallback: onErrorCallback);

              if(snapshot.connectionState==ConnectionState.done && snapshot.data!=null){
                imageSizeCache[src] = snapshot.data!;
                if(snapshot.data!<=100) return _ErrorWidget(type: type, onErrorCallback: onErrorCallback);
                return ImageViewer(tag,
                  imageProvider: imageProvider,
                  onImageRendered: onImageRendered,
                  imageFit: imageFit,
                  type: type,
                  onErrorCallback: onErrorCallback,
                  index: index,
                  allowActions: allowActions,
                  sizeInBytes: snapshot.data,
                  imageSizeThreshold: imageSizeThreshold,
                );
              }

              return progressIndicator;
            },
          );
        }
        return progressIndicator;
      },
    );
  }
}


class ImageViewer extends StatefulWidget {
  const ImageViewer(this.tag, {
    required this.imageProvider,
    this.onImageRendered,
    this.imageFit = BoxFit.contain,
    this.type = ImageType.post,
    this.onErrorCallback,
    this.index = 0,
    this.allowActions = true,
    this.sizeInBytes,
    required this.imageSizeThreshold,
    super.key});

  final ImageData tag;

  final BoxFit imageFit;

  final void Function()? onImageRendered;

  final CustomImageProvider imageProvider;

  final ImageType type;
  final VoidCallback? onErrorCallback;
  final int index;
  final bool allowActions;
  final int? sizeInBytes;
  final double? imageSizeThreshold;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late final double? sizeInMegabytes;
  late final double imageMaxSize;
  bool canSaveImage = true;
  bool ignoreEnforcedSize = false;
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  String get sizeInMegabytesString => '${sizeInMegabytes?.toStringAsFixed(2)} MB';

  @override
  void initState() {
    sizeInMegabytes = widget.sizeInBytes!=null ? widget.sizeInBytes! / (1024 * 1024) : null;
    imageMaxSize = widget.imageSizeThreshold ?? 20;
    super.initState();
  }

  void _showImageSavedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          //TODO: replace with l10n
            'Image saved'
        ),
      ),
    );
  }

  void _enlargeImage() {
    widget.imageProvider.initialIndex = widget.index;
    showImageViewerPager(context,
      widget.imageProvider,
      useSafeArea: true,
      swipeDismissible: true,
      doubleTapZoomable: true,
      immersive: false,
    );
  }

  void _downloadImage(){
    setState(() {
      ignoreEnforcedSize = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return sizeInMegabytes!=null && (!ignoreEnforcedSize && sizeInMegabytes!>imageMaxSize)
        ? switch(widget.type){
            ImageType.post => SizedBox(
                height: 20,
                child: TcmTextButton(
                    icon: Icons.image,
                    onTap: _downloadImage,
                    text: 'Tap to load image ($sizeInMegabytesString)')),
            ImageType.profile => Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return GestureDetector(
                    onTap: _downloadImage,
                    child: CircleAvatar(
                        backgroundColor: colorScheme.surface,
                        child: Icon(Icons.person_rounded, color: colorScheme.secondary,)));
              }
            ),
            ImageType.spider => InkWell(
              onTap: _downloadImage,
              child: Container(
                constraints: BoxConstraints(maxHeight: 56, maxWidth: 56),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download),
                    FittedBox(
                      child: Text(sizeInMegabytesString),
                    )
                  ],
                ),
              ),
              ),
          }
        : _buildImage();
  }

  Widget _buildImage(){
    final maxWidth = mediaQuery.size.width;  //392 for emulator
    final pixelRatioMaxWidth = (maxWidth*mediaQuery.devicePixelRatio).toInt();
    final imageProvider = getImageProviderByImageSource(widget.tag.src, maxSize: pixelRatioMaxWidth<1280? pixelRatioMaxWidth : 1280);
    final isFileImage = !isHttpBasedUrl(widget.tag.src);
    return GestureDetector(
      onTap: (canSaveImage && widget.allowActions) ? _enlargeImage : null,
      onLongPress: isFileImage ? null : (canSaveImage && widget.allowActions) ? () async {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        final left = offset.dx;
        final top = offset.dy;
        final right = left + renderBox.size.width;
        await showMenu<Future<void> Function()>(
            context: context,
            position: RelativeRect.fromLTRB(left, top, right, 0.0),
            items: [
              if(canSaveImage) PopupMenuItem(
                child: const Text('Save Image'),
                value: () async {
                  final cacheManager = DefaultCacheManager();
                  final fileInfo = await cacheManager.getFileFromCache(widget.tag.src);
                  if(fileInfo!=null){
                    final filePath = fileInfo.file.uri.path;
                    try {
                      await Gal.putImage(filePath, album: 'Trust Cafe');
                      _showImageSavedSnackBar();
                    } on GalException catch (e) {
                      developer.log('image saving error: $e');
                    }
                  }

                },
              ),
              PopupMenuItem(
                child: const Text('Copy image source'),
                value: () async {
                  await CopyManager.copy(widget.tag.src, type: CopyManagerType.text);
                },
              )
            ]
        ).then((newValue) async {
          if(newValue==null) return;
          await newValue();
        });
      } : _enlargeImage,
      /**********************************
       *   TODO: prevent 3-rd party images to be loaded without approval
       *   Note: Maybe after the first version is shared publicly, as the third-party images appear to be changing sources rather quickly after publication.
       *   Caution!
       *   This image is hosted outside of the TrustCafe servers.
       *   Tap to load it from {domain name}"example.com"
       **********************************/

      child: Image(
        width: widget.tag.width,
        height: widget.tag.height,
        image: imageProvider,
        alignment: Alignment.center,
        fit: widget.imageFit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            if(widget.onImageRendered!=null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onImageRendered!();
              });
            }
            canSaveImage = true;
            AsyncImageViewer.existingImagesCache.add(widget.tag.src);
            return child;
          } else {
            canSaveImage = false;
            return ImageProgressIndicator(progress: loadingProgress, showText: widget.type!=ImageType.profile);
          }
        },
        errorBuilder: (context, error, stackTrace)
        => _ErrorWidget(type: widget.type, onErrorCallback: widget.onErrorCallback,),
      ),
    );
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  int initialIndex;
  final List<ImageData> images;
  final ImageType type;
  final VoidCallback? onErrorCallback;

  CustomImageProvider({
    required this.images,
    this.initialIndex = 0,
    this.type = ImageType.post,
    this.onErrorCallback,
  }) : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return getImageProviderByImageSource(images[index].src);
  }

  @override
  Widget errorWidgetBuilder(BuildContext context, int index, Object error, StackTrace? stackTrace) {
    return _ErrorWidget(type: type, onErrorCallback: onErrorCallback,);
  }

  @override
  int get imageCount => images.length;
}

class _ErrorWidget extends StatefulWidget {
  const _ErrorWidget({
    required this.type,
    this.onErrorCallback,
  });
  final VoidCallback? onErrorCallback;
  final ImageType type;

  @override
  State<_ErrorWidget> createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<_ErrorWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onErrorCallback!=null) widget.onErrorCallback!();
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch(widget.type){
      ImageType.profile => Image.asset('assets/images/profile-picture.jpg'),
      ImageType.post => const Icon(Icons.error),
      ImageType.spider => const Icon(Icons.error),
    };
  }
}


ImageProvider getImageProviderByImageSource(String imageSource,
    {int? maxSize}) {

  if (isHttpBasedUrl(imageSource)) {
    return CachedNetworkImageProvider(imageSource, maxHeight: maxSize, maxWidth: maxSize);
  }

  return FileImage(File(imageSource));
}

bool isHttpBasedUrl(String url) {
  try {
    final uri = Uri.parse(url.trim());
    return uri.isScheme('HTTP') || uri.isScheme('HTTPS');
  } catch (_) {
    return false;
  }
}