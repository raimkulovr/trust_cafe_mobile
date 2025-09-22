part of 'spider_cubit.dart';

class SpiderState extends Equatable {
  const SpiderState({
    this.urlData,
    this.isLoading = false,
  });

  final SpiderUrlData? urlData;
  final bool isLoading;

  @override
  List<Object?> get props => [
    urlData,
    isLoading,
  ];

  SpiderState copyWith({
    SpiderUrlData? urlData,
    bool? isLoading,
  }) {
    return SpiderState(
      urlData: urlData ?? this.urlData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
