import 'dart:async';
import 'dart:developer';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:text_editor/src/typedefs.dart';
import 'package:text_editor/src/widgets/preview_stage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:html/dom.dart' as dom;

import 'draft_manager/draft_manager_screen.dart';
import 'text_editor_cubit.dart';

final widthHeightRegExp = RegExp(r'width:\s*([\d.]+)\s*;\s*height:\s*([\d.]+)\s*;?');
const maxTextLength = 2000;

class TextEditorScreen extends StatelessWidget {
  const TextEditorScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.destination,
    required this.isEditing,
    required this.canChangeIsCollaborative,
    this.initialText,
    this.collaborative,
    this.cardUrl,
    this.profileSlug,
    this.blurLabel,
    super.key,
  });

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final TextEditorDestination destination;
  final String? initialText;
  final bool? collaborative;
  final String? cardUrl;
  final String? profileSlug;
  final bool isEditing;
  final bool canChangeIsCollaborative;
  final String? blurLabel;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: contentRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: BlocProvider(
        create: (_) => TextEditorCubit(
          destination: destination,
          contentRepository: contentRepository,
          isCollaborative: collaborative,
          cardUrl: cardUrl,
          textHtml: initialText,
          profileSlug: profileSlug,
          blurLabel: blurLabel,
        ),
        child: TextEditorView(
          destination: destination,
          initialText: initialText,
          isEditing: isEditing,
          userRepository: userRepository,
          profileSlug: profileSlug,
          canChangeIsCollaborative: canChangeIsCollaborative,
        ),
      ),
    );
  }
}

class TextEditorView extends StatefulWidget {
  const TextEditorView({
    required this.destination,
    required this.userRepository,
    required this.isEditing,
    required this.canChangeIsCollaborative,
    this.initialText,
    this.profileSlug,
    super.key,
  });

  final String? initialText;
  final TextEditorDestination destination;
  final bool isEditing;
  final UserRepository userRepository;
  final String? profileSlug;
  final bool canChangeIsCollaborative;

  @override
  State<TextEditorView> createState() => _TextEditorViewState();
}

class _TextEditorViewState extends State<TextEditorView> {
  late final QuillController _controller;
  late final FocusNode _focusNode;
  bool isExitDialogActive = false;

  String transformHtml(String html){
    final htmlContent = dom.Document.html(html);
    final imageTags = htmlContent.getElementsByTagName('img');
    for (var e in imageTags) {
      final imageTagAttributes = e.attributes;
      final width = imageTagAttributes['width'];
      final height = imageTagAttributes['height'];
      if(width!=null && height!=null){
        imageTagAttributes['style'] = 'width:$width;height:$height;';
      }
    }
    return htmlContent.body!.innerHtml.replaceAll('</p><p>', '</p><br/><p>');
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    final converter = HtmlToDelta(replaceNormalNewLinesToBr: true, trimText: false);
    _controller = QuillController(
      document: widget.initialText!=null ? Document.fromDelta(converter.convert(transformHtml(widget.initialText!))) : Document(),
      editorFocusNode: _focusNode,
      selection: const TextSelection.collapsed(offset: 0)
    );

    super.initState();
  }

  Future<String> _getControllerHtml(Delta deltaData) async {
    final data = Delta.fromOperations(Delta.from(deltaData).operations.map((operation) {
      if(operation.isInsert && operation.value is Map<String, dynamic> && operation.value['image']!=null){
        final style = operation.attributes?['style'];
        if (style != null && style is String) {
          var match = widthHeightRegExp.firstMatch(style);
          if (match != null) {
            String? widthString = match.group(1);
            String? heightString = match.group(2);

            final width = double.tryParse(widthString ?? '');
            final height = double.tryParse(heightString ?? '');
            if(width!=null && height!=null){
              return Operation.insert(operation.data, {
                'style': operation.attributes?['style'],
                'width': width.toInt(),
                'height': height.toInt(),
              });
            }
          }
        }
      }
      return operation;
    },).toList());
    final converter = QuillDeltaToHtmlConverter(data.toJson(),
        ConverterOptions(multiLineParagraph: false,)
    );

    final convertedDelta = converter.convert();
    return convertedDelta;
  }

  Future<bool?> _showBackDialog() async {
    if(isExitDialogActive) return false;
    isExitDialogActive = true;
    final result = showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to leave this page?'),
          content: const Text(
            'All unsaved changes will be lost.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Stay'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text('Leave', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    return result;
  }

  void _clearEditor() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to clear the editor?'),
          content: const Text(
            'All unsaved changes will be lost.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if(shouldClear??false){
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<TextEditorCubit>();
    final maxWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (cubit.state.processingImageUpload || didPop || isExitDialogActive) {
          return;
        }
        _focusNode.unfocus();

        if (cubit.state.stage == TextEditorStage.preview)
          return context.read<TextEditorCubit>().setStageEditing();


        final bool shouldPop = !_controller.hasUndo ||
            (await _showBackDialog() ?? false);
        isExitDialogActive = false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: BlocListener<TextEditorCubit, TextEditorState>(
        listener: (context, state) {
          if (state.imageUploadError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    //TODO: replace with l10n
                    'IMAGE UPLOAD ERROR'),
              ),
            );
          }

          if (state.finalHtml != null) {
            if (widget.destination == TextEditorDestination.comment)
              return Navigator.of(context).pop((commentText: state.finalHtml, blurLabel: state.blurLabel));
            if (widget.initialText == null) {
              final sk = (widget.profileSlug != null && state.postToProfile)
                  ? 'userprofile#${widget.profileSlug}'
                  : state.selectedBranch?.sk ?? 'maintrunk#maintrunk';
              final pk = (widget.profileSlug != null && state.postToProfile)
                  ? 'userprofile#${widget.profileSlug}'
                  : state.selectedBranch?.pk ?? 'maintrunk#maintrunk';
              return Navigator.of(context).pop((
                postText: state.finalHtml,
                collaborative: state.isCollaborative,
                cardUrl: state.cardUrl,
                parentSk: sk,
                parentPk: pk,
                blurLabel: state.blurLabel,
              ));
            } else {
              return Navigator.of(context).pop((
                postText: state.finalHtml,
                collaborative: state.isCollaborative,
                cardUrl: state.cardUrl,
                blurLabel: state.blurLabel,
              ));
            }
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<TextEditorCubit, TextEditorState>(
                    builder: (context, state) {
                      return AppBar(
                        automaticallyImplyLeading: false,
                        leading: state.processingImageUpload
                            ? null
                            : IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: state.stage == TextEditorStage.preview
                                    ? context.read<TextEditorCubit>().setStageEditing
                                    : () => Navigator.maybePop(context),
                              ),
                        title: Text(state.stage == TextEditorStage.preview
                            ? state.processingImageUpload
                            ? 'Uploading image(s)'
                            : 'Preview'
                            : '${widget.isEditing ? 'Editing' : 'New'} ${widget.destination == TextEditorDestination.post ? 'post' : 'comment'}'),
                        actions: [
                          if(state.stage == TextEditorStage.editing && !widget.isEditing)
                            TextButton(
                              onPressed: _clearEditor,
                              child: Text('Clear', style: TextStyle(color: Colors.red),),
                            ),
                          if(state.stage == TextEditorStage.editing && !widget.isEditing)
                            DraftManagerScreen(
                              controller: _controller,
                              userRepository: widget.userRepository,
                              typeIsPost: widget.destination==TextEditorDestination.post,
                            ),
                          state.processingImageUpload
                              ? const SizedBox()
                              : TextButton(
                                  onPressed: widget.initialText==null &&
                                      state.stage == TextEditorStage.preview &&
                                      state.characterAmount>maxTextLength
                                      ? null
                                      : () async {
                                    _focusNode.unfocus();
                                    if(state.stage == TextEditorStage.preview){
                                      cubit.publish();
                                    } else {
                                      final text = await _getControllerHtml(_controller.document.toDelta());
                                      if (text.isEmpty || text=='<p><br/></p>') return;
                                      cubit.setStagePreview(text, maxWidth, widget.isEditing);
                                    }
                                  },
                                  child: Text(state.stage == TextEditorStage.preview
                                      ? 'Publish'
                                      : 'Next'),
                                ),
                        ],
                      );
                    }),
                BlocBuilder<TextEditorCubit, TextEditorState>(
                  buildWhen: (p, c) => p.stage != c.stage,
                  builder: (context, state) => (state.stage == TextEditorStage.preview)
                  ? PreviewStage(
                      destination: widget.destination,
                      isEditing: widget.isEditing,
                      canChangeIsCollaborative: widget.canChangeIsCollaborative,
                    )
                  : Column(
                    children: [
                      QuillSimpleToolbar(
                        controller: _controller,
                        configurations: QuillSimpleToolbarConfigurations(
                            showUndo: false,
                            showRedo: false,
                            showFontFamily: false,
                            showFontSize: false,
                            showSubscript: false,
                            showSuperscript: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showListNumbers: false,
                            showListBullets: false,
                            showListCheck: false,
                            showCodeBlock: false,
                            showInlineCode: false,
                            showIndent: false,
                            showStrikeThrough: false,
                            showQuote: widget.destination==TextEditorDestination.post,
                            showHeaderStyle: widget.destination==TextEditorDestination.post,
                            headerStyleType: HeaderStyleType.original,
                            buttonOptions: const QuillSimpleToolbarButtonOptions(
                              selectHeaderStyleDropdownButton: QuillToolbarSelectHeaderStyleDropdownButtonOptions(
                                  attributes: [
                                    Attribute.h1,
                                    Attribute.h2,
                                    Attribute.h3,
                                    Attribute.h4,
                                    Attribute.h5,
                                    Attribute.h6,
                                    Attribute.header,
                                  ]
                              ),
                            ),
                            embedButtons: FlutterQuillEmbeds.toolbarButtons(
                              videoButtonOptions: null,
                              cameraButtonOptions: null,
                              tableButtonOptions: null,
                              imageButtonOptions: QuillToolbarImageButtonOptions(
                                linkRegExp: postHtmlExp,
                              ),
                            )
                        ),
                      ),
                      Divider(
                        color: colorScheme.onSurface,
                      ),
                      QuillEditor.basic(
                        controller: _controller,
                        configurations: QuillEditorConfigurations(
                          placeholder: 'What\'s on your mind?',
                          padding: const EdgeInsets.all(8),
                          keyboardAppearance: colorScheme.brightness,
                          magnifierConfiguration: TextMagnifierConfiguration.disabled,
                          embedBuilders: [
                            QuillEditorImageEmbedBuilder(
                              configurations: QuillEditorImageEmbedConfigurations(
                                imageProviderBuilder: (context, url)=>getImageProviderByImageSource(url),
                                imageErrorWidgetBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red, size: 56,);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
