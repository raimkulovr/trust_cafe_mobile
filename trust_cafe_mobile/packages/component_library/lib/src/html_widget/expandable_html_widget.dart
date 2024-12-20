import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart' hide Element;

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '../../component_library.dart';
import 'html_widget_carousel.dart';
import 'image_processing.dart';

class ExpandableHtmlWidget extends StatefulWidget {
  const ExpandableHtmlWidget({
    required this.html,
    this.maxHeight = 330.0,
    this.horizontalPadding = 8,
    this.isExpanded = false,
    this.interceptImages = true,
    this.allowSelection = true,
    this.gradientColor,
    required this.imageSizeThreshold,
    super.key,
  });
  final String html;

  final double horizontalPadding;

  final double maxHeight;
  final bool isExpanded;
  final bool interceptImages;
  final bool allowSelection;
  final Color? gradientColor;
  final double? imageSizeThreshold;

  @override
  State<ExpandableHtmlWidget> createState() => _ExpandableHtmlWidgetState();
}

class _ExpandableHtmlWidgetState extends State<ExpandableHtmlWidget> {
  late final dom.Document htmlContent;
  late final Map<String, ImageData> images;
  late final ValueNotifier<double> height;
  late final CustomImageProvider? imageProvider;
  bool isExpanded = false;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
    height = ValueNotifier<double>(0);

    final htmlContent = dom.Document.html(widget.html);
    final Map<String, ImageData> images = {};
    if(widget.interceptImages){
      final imageTags = htmlContent.getElementsByTagName('img');
      int imageId = 0;
      for (var e in imageTags) {
        final imageTagAttributes = e.attributes;
        final tagName = 'img-$imageId';
        images[tagName] = ImageData(
          src: imageTagAttributes['src'] ?? '',
          alt: imageTagAttributes['alt'],
          height: double.tryParse(imageTagAttributes['height'] ?? ''),
          width: double.tryParse(imageTagAttributes['width'] ?? ''),
        );
        e.replaceWith(dom.Element.tag(tagName));
        imageId++;
      }
      imageProvider = CustomImageProvider(
        images: images.values.toList(),
      );
    }

    this.images = images;
    this.htmlContent = images.length > 1 ? wrapNeighboringImages(htmlContent) : htmlContent;

    if(images.isNotEmpty) WidgetsBinding.instance.addPostFrameCallback((_) => updateWidgetHeight());
  }

  void updateWidgetHeight([Size? size]){
    if(isExpanded) return;
    if(mounted){
      height.value = (size ?? (context.findRenderObject() as RenderBox).size).height;
    }
  }

  FutureOr<bool> onTapUrl(String url) async {
    if (mounted) {
      UrlLauncher.launchWebUrl(context, url);
    }

    return true;
  }

  Widget _getBlockquoteText(String text){
    return Text(text,
      textAlign: TextAlign.left,
      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),);
  }

  Widget _buildImage(ImageData tag, {
    bool withImageCallback = false,
    required ImageType imageType,
  }){
    final imageTags = images.values.toList();
    final index = imageTags.indexOf(tag);
    return SelectionContainer.disabled(
      child: isHttpBasedUrl(tag.src)
        ? AsyncImageViewer(tag,
            index: index,
            type: imageType,
            imageProvider: imageProvider!,
            onImageRendered: withImageCallback ? updateWidgetHeight : null,
            imageSizeThreshold: widget.imageSizeThreshold,
          )
        : ImageViewer(tag,
            index: index,
            type: imageType,
            imageProvider: imageProvider!,
            onImageRendered: withImageCallback ? updateWidgetHeight : null,
            imageSizeThreshold: null,
          )
    );
  }

  Widget? widgetBuilder (dom.Element e, {bool withImageCallback = false}) {
    //Handle image groups
    if(e.localName == 'images'){
      return HtmlWidgetCarousel(
        itemCount: e.children.length,
        tagGetter: (index) => images[e.children[index].localName],
        imageBuilder: (tag) => _buildImage(tag, withImageCallback: withImageCallback, imageType: ImageType.spider),
      );
    }

    //Handle single images
    final tag = images[e.localName];
    if(tag!=null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: _buildImage(tag, withImageCallback: withImageCallback, imageType: ImageType.post),
      );
    } else if(e.localName == 'img'){
      final src = e.attributes['src'] ?? '';
      if(src.startsWith('/')){
        final imageTagAttributes = e.attributes;
        final height = double.tryParse(imageTagAttributes['height'] ?? '');
        final width = double.tryParse(imageTagAttributes['width'] ?? '');
        return Image.file(File(src),
          width: width,
          height: height,
        );
      }
    }

    //Handle blockquotes
    if(e.localName == 'blockquote' && (e.text.isNotEmpty || e.children.isNotEmpty)){
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey.shade300, width: 4))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(e.children.isNotEmpty)
                ...(e.children.map((e) => widgetBuilder(e) ?? _getBlockquoteText(e.text),).toList()),
              if(e.text.isNotEmpty)
                _getBlockquoteText(e.text)
            ],),
        ),
      );
    }

    //Use default builder
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final gradientColor = widget.gradientColor ?? colorScheme.surface;
    final htmlWidget = SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: images.isNotEmpty
          ? HtmlWidget(htmlContent.outerHtml,
              buildAsync: false,
              onTapUrl: onTapUrl,
              customWidgetBuilder: (e) => widgetBuilder(e, withImageCallback: true),
            )
          : MeasureSize(
              onChange: (size) => updateWidgetHeight(size),
              child: HtmlWidget(htmlContent.outerHtml,
                buildAsync: false,
                onTapUrl: onTapUrl,
                customWidgetBuilder: widgetBuilder,
              ),
            ),
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: 10
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isExpanded ? double.infinity : widget.maxHeight,
            ),
            child: widget.allowSelection ? SelectionArea(
              child: htmlWidget,
            ) : htmlWidget,
          ),
        ),

        ListenableBuilder(
          listenable: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        gradientColor.withOpacity(0),
                        gradientColor.withOpacity(0.8),
                        gradientColor.withOpacity(1),
                        gradientColor.withOpacity(1),
                      ],
                    )),
                height: 40,
              ),
              TcmPrimaryButton(
                onPressed: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                text: 'Continue reading',
              ),
            ],
          ),
          builder: (context, Widget? child)
          {
            if ( isExpanded == false && height.value > widget.maxHeight){
              return child!;
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    height.dispose();
    super.dispose();
  }
}
