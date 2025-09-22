import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';

enum CarouselItemType{
  image,
  text,
}

class SpiderCarouselSlider extends StatefulWidget {
  const SpiderCarouselSlider({
    required this.fetchData,
    required this.isApiChannelProduction,
    required this.imageSizeThreshold,
    super.key,
  });

  final bool Function() isApiChannelProduction;
  final SpiderFetchData fetchData;
  final double? imageSizeThreshold;

  @override
  State<SpiderCarouselSlider> createState() => _SpiderCarouselSliderState();
}

class _SpiderCarouselSliderState extends State<SpiderCarouselSlider> {
  String imageSrc(url) =>
      'https://wts2-spider-${widget.isApiChannelProduction() ? 'prod' : 'dev'}-images.s3.amazonaws.com/$url';

  late final List<ImageData> imageTags;
  late final SpiderFetchData fetchData;
  @override
  void initState() {
    fetchData = widget.fetchData;
    imageTags = [
      if(fetchData.cachedImage!=null) fetchData.cachedImage!,
      fetchData.screenshot,
    ].where((e) => e.isNotEmpty,).map((e) => ImageData(src: imageSrc(e)),).toList();

    super.initState();
  }

  void _onImageError(String src){
    if(mounted) {
      setState(() {
        imageTags.removeWhere((e) => e.src == src);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width;
    return Column(
      children: [
        Row(
          children: [
            if(imageTags.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: fetchData.description!=null ? maxWidth*0.5 : maxWidth,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  primary: false,
                  child: CarouselSlider.builder(
                    itemCount: imageTags.length,
                    options: CarouselOptions(
                      padEnds: false,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      height: size.height*0.2,
                    ),
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      final e = imageTags[index];
                      return SizedBox(
                        height: size.height*0.2,
                        width: maxWidth,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          child: AsyncImageViewer(e,
                              type: ImageType.spider,
                              onErrorCallback: ()=>_onImageError(e.src),
                              index: index,
                              imageSizeThreshold: widget.imageSizeThreshold,
                              imageProvider: CustomImageProvider(
                                  type: ImageType.spider,
                                  images: imageTags,
                                  initialIndex: imageTags.indexOf(e),
                                  onErrorCallback: ()=>_onImageError(e.src)
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if(fetchData.description!=null) Expanded(
              child: GestureDetector(
                onTap: () {
                  final text = fetchData.description!;
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    showDragHandle: true,
                    builder: (context) {
                      return TcmBottomSheet(
                        maxHeight: 0.26,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                              child: SelectionArea(
                                  child: Text(text))),
                        ),
                      );
                    },);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0, left: imageTags.isNotEmpty? 0: 8),
                  child: Text(fetchData.description!, maxLines: 6, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
