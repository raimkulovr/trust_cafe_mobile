import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'spider_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SpiderScreen extends StatefulWidget {
  const SpiderScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.url,
    this.initialHide = false,
    super.key,
  });


  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final String url;
  final bool initialHide;

  @override
  State<SpiderScreen> createState() => _SpiderScreenState();
}

class _SpiderScreenState extends State<SpiderScreen> {
  late bool hide;
  @override
  void initState() {
    hide = widget.initialHide;
    super.initState();
  }

  void unhide() => setState(() {
    hide = false;
  });

  @override
  Widget build(BuildContext context) {
    return hide
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: TcmTextButton(text: 'Tap to show link preview', onTap: unhide, icon: Icons.remove_red_eye_rounded,)))
        : MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: widget.contentRepository),
              RepositoryProvider.value(value: widget.userRepository),
            ],
            child: BlocProvider(
              create: (_) => SpiderCubit(contentRepository: widget.contentRepository, url: widget.url),
              child: const SpiderView(),
            ));
  }
}

class SpiderView extends StatelessWidget {
  const SpiderView({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    return UrlLauncher.launchWebUrl(context, url);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final TextStyle linkTextStyle = TextStyle(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w500
    );
    Widget launchableLink(String url, {int? maxLines}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
          onTap: ()=>_launchUrl(context, url),
          child: Text(url, style: linkTextStyle, maxLines: maxLines, overflow: TextOverflow.ellipsis,)
      ),
    );
    final imageSizeThreshold = RepositoryProvider.of<UserRepository>(context).imageSizeThreshold;
    return Column(
      children: [
        BlocBuilder<SpiderCubit, SpiderState>(
          builder: (context, state) => state.isLoading
              ? const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: SizedBox(
                    height: 2,
                    child: LinearProgressIndicator()),
              )
               :const SizedBox(),
        ),
        BlocBuilder<SpiderCubit, SpiderState>(
          // buildWhen: (p, c) => p.urlData!=c.urlData,
          builder: (context, state) {
            final urlData = state.urlData;
            final size = MediaQuery.of(context).size;
            final maxWidth = size.width;
            if(urlData!=null){
              if(urlData.fetchData!=null){
                final fetchData = urlData.fetchData;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(fetchData!.title.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: ()=>_launchUrl(context, urlData.url),
                              child: Text(fetchData.title, style: linkTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),],
                      ),
                    SpiderCarouselSlider(
                        fetchData: fetchData,
                        isApiChannelProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction,
                        imageSizeThreshold: imageSizeThreshold),
                    launchableLink(urlData.url, maxLines: 1),
                  ],
                );
              } else if(urlData.oembedData!=null){
                final oembedData = urlData.oembedData;
                final imageData = oembedData!.thumbnailUrl!=null ? ImageData(src: oembedData.thumbnailUrl!) : null;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: ()=>_launchUrl(context, urlData.url),
                          child: Text(oembedData.title, style: linkTextStyle,
                          ),
                        ),
                      ),
                      if(imageData!=null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.2,
                              width: 200,
                              child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: AsyncImageViewer(imageData,
                                      type: ImageType.spider,
                                      imageSizeThreshold: imageSizeThreshold,
                                      imageProvider: CustomImageProvider(
                                        type: ImageType.spider,
                                        images: [imageData],)))),
                        ),
                      const SizedBox(height: 8),
                      launchableLink(urlData.url, maxLines: 1),
                    ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: retry button?
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 4),
                      child: Row(
                        children: [
                          const Text('Oops! Nothing to show.'),
                          const Spacer(),
                          TcmTextButton(text: 'retry?',
                            onTap: context.read<SpiderCubit>().refreshSpiderData,),
                        ],
                      ),
                    ),
                    launchableLink(urlData.url),
                  ],
                );
              }
            } else {
             return const SizedBox();
            }
          }
        ),

      ],
    );
  }
}

