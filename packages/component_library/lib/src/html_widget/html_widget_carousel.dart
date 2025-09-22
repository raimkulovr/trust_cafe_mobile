import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../image_viewer.dart';

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

  final ValueNotifier<int?> page = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
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
                onScrolled: (value) {
                  if(value?.toInt() != value){
                    page.value = null;
                  } else {
                    page.value = value?.toInt();
                  }
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4,0,4,0),
          child: ListenableBuilder(
            listenable: page,
            builder: (context, child) {
              final pageInt = page.value;
              if (pageInt==null) return const SizedBox();

              return Text('${pageInt+1}/${widget.itemCount}',
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey));
            },),
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