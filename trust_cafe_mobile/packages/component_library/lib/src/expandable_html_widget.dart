import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:html/dom.dart' hide Text;
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../component_library.dart';

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
  late final Document htmlContent;
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

    final htmlContent = Document.html(widget.html);
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
        e.replaceWith(Element.tag(tagName));
        imageId++;
      }
      imageProvider = CustomImageProvider(
        images: images.values.toList(),
      );
    }

    this.images = images;
    this.htmlContent = images.isNotEmpty ? wrapNeighboringImages(htmlContent) : htmlContent;

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
    required BoxFit imageFit,
    required ImageType imageType,
  }){
    final imageTags = images.values.toList();
    final index = imageTags.indexOf(tag);
    return SelectionContainer.disabled(
      child: isHttpBasedUrl(tag.src)
        ? AsyncImageViewer(tag,
            index: index,
            imageFit: imageFit,
            type: imageType,
            imageProvider: imageProvider!,
            onImageRendered: withImageCallback ? updateWidgetHeight : null,
            imageSizeThreshold: widget.imageSizeThreshold,
          )
        : ImageViewer(tag,
            index: index,
            imageFit: imageFit,
            type: imageType,
            imageProvider: imageProvider!,
            onImageRendered: withImageCallback ? updateWidgetHeight : null,
            imageSizeThreshold: null,
          )
    );
  }

  Widget? widgetBuilder (Element e, {bool withImageCallback = false}) {
    //Handle image groups
    if(e.localName == 'images'){
      return HtmlWidgetCarousel(
        itemCount: e.children.length,
        tagGetter: (index) => images[e.children[index].localName],
        imageBuilder: (tag) => _buildImage(tag, withImageCallback: withImageCallback, imageFit: BoxFit.cover, imageType: ImageType.spider),
      );
    }

    //Handle single images
    final tag = images[e.localName];
    if(tag!=null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: _buildImage(tag, withImageCallback: withImageCallback, imageFit: BoxFit.cover, imageType: ImageType.post),
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

  Document wrapNeighboringImages(Document document) {
    document.body?.querySelectorAll('*').forEach((pElement) {
      List<Node> newChildren = [];
      List<Node> imageGroup = [];

      for (var node in List<Node>.from(pElement.nodes)) {
        if(node is Element) {
          if(node.isImage){
            imageGroup.add(node);
            continue;
          } else if (node.localName == 'a' && node.children.any((node) => node.isImage,)){
            imageGroup.addAll(node.children.where((node) => node.isImage,));
            continue;
          }
        }
        if (imageGroup.isNotEmpty) {
          if (imageGroup.length > 1) {
            // Group only if there are multiple images
            newChildren.add(createWrapper(imageGroup));
          } else {
            // Add single image as-is
            newChildren.add(imageGroup.first);
          }
          imageGroup = [];
        }
        newChildren.add(node);
      }

      // Finalize the last group if any images are left
      if (imageGroup.isNotEmpty) {
        if (imageGroup.length > 1) {
          newChildren.add(createWrapper(imageGroup));
        } else {
          newChildren.add(imageGroup.first);
        }
      }

      // Replace the original children with the modified ones
      pElement.nodes
        ..clear()
        ..addAll(newChildren);
    });

    return document;
  }

// Helper function to create a wrapper for a list of nodes
  Element createWrapper(List<Node> nodes) {
    var wrapper = Element.tag('images');
    wrapper.nodes.addAll(nodes);
    return wrapper;
  }

  @override
  void dispose() {
    height.dispose();
    super.dispose();
  }
}

class HtmlWidgetCarousel extends StatefulWidget {
  const HtmlWidgetCarousel({
    required this.tagGetter,
    required this.imageBuilder,
    required this.itemCount,
    super.key,
  });

  final ImageData? Function(int index) tagGetter;
  final Widget Function(ImageData tag) imageBuilder;
  final int itemCount;

  @override
  State<HtmlWidgetCarousel> createState() => _HtmlWidgetCarouselState();
}

class _HtmlWidgetCarouselState extends State<HtmlWidgetCarousel> {

  final ValueNotifier<int> page = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListenableBuilder(
          listenable: page,
          builder: (context, child) {
            return Text('${page.value+1}/${widget.itemCount}',
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey));
          },),
        SizedBox(
          width: maxSize.width,
          child: CarouselSlider.builder(
              itemCount: widget.itemCount,
              itemBuilder: (context, index, realIndex) {
                final tag = widget.tagGetter(index);
                return tag!=null
                    ? widget.imageBuilder(tag)
                    : const SizedBox();
              },
              options: CarouselOptions(
                height: maxSize.height*0.4,
                disableCenter: true,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) => page.value=index,
              )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }
}

extension ElementIsImage on Element{
  bool get isImage => localName?.startsWith('img') ?? false;
}
