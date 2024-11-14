import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';

class PagingListView<T> extends StatelessWidget{
  const PagingListView({
    required this.pagingController,
    required this.onFirstPageErrorRetry,
    required this.itemBuilder,
    this.scrollController,
    super.key,
  });

  final ScrollController? scrollController;
  final PagingController<String?, T> pagingController;
  final VoidCallback onFirstPageErrorRetry;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PagedListView.separated(
          pagingController: pagingController,
          scrollController: scrollController,
          addAutomaticKeepAlives: false,
          physics: const AlwaysScrollableScrollPhysics(),
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: itemBuilder,
            firstPageErrorIndicatorBuilder: (context) {
              return Center(
                child: Column(
                  children: [
                    Text('Something went wrong'),
                    ElevatedButton(
                      onPressed: onFirstPageErrorRetry,
                      child: Text('try again'),
                    ),
                  ],
                ),
              );
            },
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 0,)
      ),
    );
  }
}