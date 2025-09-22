import 'package:trust_cafe_mobile/features/branches/branches.dart';
import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' hide Text;

import '../text_editor_cubit.dart';
import '../text_editor_screen.dart';
import '../typedefs.dart';
import 'link_preview_editor.dart';

const hideContentAvailableValues = ['Content Warning', 'NSFW', 'Spider', 'Spoiler'];

class PreviewStage extends StatelessWidget {
  const PreviewStage({
    required this.destination,
    required this.isEditing,
    required this.canChangeIsCollaborative,
    super.key,
  });

  final TextEditorDestination destination;
  final bool isEditing;
  final bool canChangeIsCollaborative;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<TextEditorCubit>();
    return Container(
      margin: EdgeInsets.only(bottom: 56),
      color: colorScheme.surface,
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<TextEditorCubit, TextEditorState>(
                buildWhen: (p, c) =>
                p.processingImageUpload != c.processingImageUpload || p.characterAmount!=c.characterAmount,
                builder: (context, state) {
                  return state.processingImageUpload
                      ? const Column(
                          children: [
                            LinearProgressIndicator(),
                            SizedBox(height: 4,),
                            Text('Please do not close the app.'),
                          ],
                        )
                      : !isEditing && state.characterAmount>maxTextLength
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red,)
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.all(4),
                              child: Align(
                                alignment: Alignment.center,
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(color: colorScheme.onSurface),
                                        children: [
                                          const TextSpan(text: 'The text must not exceed '),
                                          const TextSpan(text: '$maxTextLength characters!\n',style: TextStyle(decoration: TextDecoration.underline)),
                                          const TextSpan(text: 'Current amount: '),
                                          TextSpan(text: '${state.characterAmount}', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline)),
                                        ])),
                              ),
                            )
                          : const SizedBox();
                },
              ),
              if (canChangeIsCollaborative && destination == TextEditorDestination.post)
                BlocBuilder<TextEditorCubit, TextEditorState>(
                    buildWhen: (p, c) =>
                    p.isCollaborative != c.isCollaborative ||
                        p.processingImageUpload != c.processingImageUpload,
                    builder: (context, state) {
                      return Row(
                        children: [
                          Checkbox(
                            value: state.isCollaborative,
                            onChanged: state.processingImageUpload
                                ? null
                                : (value) => context
                                .read<TextEditorCubit>()
                                .changeIsCollaborative(value ?? false),
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: state.processingImageUpload
                                      ? null
                                      : () => context
                                      .read<TextEditorCubit>()
                                      .changeIsCollaborative(),
                                  child: Text('Make this post collaborative')))
                        ],
                      );
                    }),
              if(!isEditing && destination == TextEditorDestination.post)
                BlocBuilder<TextEditorCubit, TextEditorState>(
                  buildWhen: (p, c) => p.postToProfile != c.postToProfile,
                  builder: (context, state) {
                    final postToProfile = state.postToProfile;
                    return Column(
                      children: [
                        if (cubit.profileSlug != null)
                          BlocBuilder<TextEditorCubit, TextEditorState>(
                              buildWhen: (p, c) => p.processingImageUpload != c.processingImageUpload,
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: postToProfile,
                                      onChanged: state.processingImageUpload
                                          ? null
                                          : cubit.changePostToProfile,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: state.processingImageUpload
                                                ? null
                                                : cubit.changePostToProfile,
                                            child: Text('Post to my branch')))
                                  ],
                                );
                              }),
                        if (postToProfile == false)
                          BlocBuilder<TextEditorCubit, TextEditorState>(
                            buildWhen: (p, c) => p.processingImageUpload != c.processingImageUpload,
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BranchesScreen(
                                  onSubwikiSelected: (subwiki) {
                                    context.read<TextEditorCubit>().setSelectedBranch(subwiki);
                                  },
                                  contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                  selectedSubwiki: state.selectedBranch,
                                  enabled: !state.processingImageUpload,
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
              ),
              const _AdvancedOptions(),
              BlocBuilder<TextEditorCubit, TextEditorState>(
                  buildWhen: (p, c) => p.textHtml != c.textHtml ||
                      p.processingTextHtml != c.processingTextHtml,
                  builder: (context, state) {
                    return state.processingTextHtml
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              const Divider(),
                              ExpandableHtmlWidget(
                                html: state.textHtml,
                                isExpanded: true,
                                imageSizeThreshold: null,
                              ),
                              const Divider(),
                              if (destination == TextEditorDestination.post)
                                BlocBuilder<TextEditorCubit, TextEditorState>(
                                  buildWhen: (p, c) => p.cardUrl != c.cardUrl,
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Link for preview'),
                                              const Spacer(),
                                              state.cardUrl.isNotEmpty
                                                ? Row(
                                                    children: [
                                                      TcmTextButton(
                                                        text: 'edit',
                                                        onTap: () {
                                                          _showEditDialog(context, onSaved: cubit.setCardUrl, initialText: state.cardUrl);
                                                        },
                                                      ),
                                                      TcmTextButton(onTap: cubit.setCardUrl, text: 'remove'),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      TcmTextButton(onTap: (){
                                                        final htmlContent = Document.html(state.textHtml);
                                                        cubit.setCardUrl(htmlContent.body!.innerHtml);
                                                      }, text: 'refresh'),
                                                      TcmTextButton(
                                                          text: 'add',
                                                          onTap: () {
                                                            _showEditDialog(context, onSaved: cubit.setCardUrl, initialText: state.cardUrl);
                                                          },
                                                        ),
                                                    ],
                                                  )
                                            ],
                                          ),
                                          Text(state.cardUrl,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: colorScheme.primary,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },)
                            ],
                        );
                  }),
            ],
          )),
    );
  }

  Future<bool?> _showEditDialog(BuildContext context, {
    required void Function(String) onSaved,
    String? initialText,
  })
  {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return LinkPreviewEditor(
          onSaved: onSaved,
          initialText: initialText,
        );
      },
    );
  }

}

class _AdvancedOptions extends StatefulWidget {
  const _AdvancedOptions({super.key});

  @override
  State<_AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<_AdvancedOptions> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Material(
            child: Ink(
              child: InkWell(
                radius: 6,
                borderRadius: BorderRadius.circular(6),
                onTap: () => setState(() {isExpanded=!isExpanded;}),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      Text('Advanced options', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),),
                      Spacer(),
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(isExpanded)
            BlocBuilder<TextEditorCubit, TextEditorState>(
                buildWhen: (p, c) => p.blurLabel != c.blurLabel,
                builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: state.blurLabel!=null,
                            onChanged: state.processingImageUpload
                                ? null
                                : (value) => context
                                .read<TextEditorCubit>()
                                .switchBlurLabel(value==null ? hideContentAvailableValues.first : null),
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: state.processingImageUpload
                                      ? null
                                      : () => context
                                      .read<TextEditorCubit>()
                                      .switchBlurLabel(state.blurLabel==null ? hideContentAvailableValues.first : null),
                                  child: Text('Hide content')))
                        ],
                      ),
                      if(state.blurLabel!=null)
                        Column(
                            children: hideContentAvailableValues.map((e) =>
                                RadioListTile.adaptive(
                                    title: Text(e),
                                    value: e,
                                    groupValue: state.blurLabel,
                                    onChanged: context.read<TextEditorCubit>().switchBlurLabel
                                ),).toList()
                        )
                    ],
                  );
                }
            ),
          if(isExpanded) BlocBuilder<TextEditorCubit, TextEditorState>(
            buildWhen: (p, c) => p.wrapImagesWithLinks != c.wrapImagesWithLinks,
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: state.wrapImagesWithLinks,
                        onChanged: state.processingImageUpload
                            ? null
                            : (value) => context
                            .read<TextEditorCubit>()
                            .switchWrapImagesWithLinks(value ?? false),
                      ),
                      Expanded(
                          child: GestureDetector(
                              onTap: state.processingImageUpload
                                  ? null
                                  : () => context
                                  .read<TextEditorCubit>()
                                  .switchWrapImagesWithLinks(),
                              child: Text('Wrap images with links')))
                    ],
                  ),
                  if(state.wrapImagesWithLinks)
                    BlocBuilder<TextEditorCubit, TextEditorState>(
                        buildWhen: (p, c) => p.hideImages != c.hideImages,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Checkbox(
                                value: state.hideImages,
                                onChanged: state.processingImageUpload
                                    ? null
                                    : (value) => context
                                    .read<TextEditorCubit>()
                                    .switchHideImages(value ?? false),
                              ),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: state.processingImageUpload
                                          ? null
                                          : () => context
                                          .read<TextEditorCubit>()
                                          .switchHideImages(),
                                      child: Text('Replace images with links (all)')))
                            ],
                          );
                        }
                    )
                ],
              );
            },
          ),
          if(isExpanded)
            _CompressImagesSwitch(),
        ],
      ),
    );
  }
}

class _CompressImagesSwitch extends StatefulWidget {
  const _CompressImagesSwitch({super.key});

  @override
  State<_CompressImagesSwitch> createState() => _CompressImagesSwitchState();
}

class _CompressImagesSwitchState extends State<_CompressImagesSwitch> {
  late final TapGestureRecognizer _tapRecognizer;

  get colorScheme => Theme.of(context).colorScheme;

  @override
  void initState() {
    _tapRecognizer = TapGestureRecognizer();
    _tapRecognizer.onTap = (){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text('Image compression'),
          content: SingleChildScrollView(
            child: RichText(text: TextSpan(
              style: TextStyle(color: colorScheme.onSurface),
              children: [
                TextSpan(text: 'Important!\n', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                TextSpan(text: 'Compression will require a significant amount of RAM. The larger the image, the more RAM will be used, which could cause your operating system to terminate background applications.\n'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'The app will attempt to resize images to 1280 pixels on the longer side while maintaining the original proportions.\n\n'),
                TextSpan(text: 'If the image is in JPG or JPEG format, its quality will be reduced, which will contribute the most to the compression.\n\n'),
                TextSpan(text: 'Otherwise, if resizing does not significantly reduce the file size or if the image is smaller than 1280x1280 pixels, no transformation will be applied.\n\n'),
                TextSpan(text: 'Only local images will be compressed. For example, if you\'re editing a post that includes images, the compression won\'t affect them because they are already uploaded to the server. You might want to download the images first if you want to compress them.\n\n'),
              ]
            )),
          ),
        );
      },);
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextEditorCubit, TextEditorState>(
        buildWhen: (p, c) => p.compressImages != c.compressImages,
        builder: (context, state) {
          return Row(
            children: [
              Checkbox(
                value: state.compressImages,
                onChanged: state.processingImageUpload
                    ? null
                    : (value) => context
                    .read<TextEditorCubit>()
                    .switchCompressImages(value),
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: state.processingImageUpload
                          ? null
                          : () => context
                          .read<TextEditorCubit>()
                          .switchCompressImages(),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: colorScheme.onSurface),
                              children: [
                                TextSpan(text: 'Compress images ('),
                                TextSpan(
                                  text: 'experimental',
                                  style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: _tapRecognizer
                                ),
                                TextSpan(text: ')'),
                              ]
                          ))))
            ],
          );
        }
    );
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }
}
