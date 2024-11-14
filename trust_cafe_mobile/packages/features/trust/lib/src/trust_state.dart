part of 'trust_cubit.dart';

class TrustState extends Equatable {
  const TrustState({
    this.trustObject,
    this.isLoading = false,
    this.chosenTrustLevel = 0,
  });

  final TrustObject? trustObject;
  final bool isLoading;
  final double chosenTrustLevel;

  @override
  List<Object?> get props => [
    trustObject,
    isLoading,
    chosenTrustLevel,
  ];

  TrustState copyWith({
    TrustObject? trustObject,
    bool? isLoading,
    double? chosenTrustLevel,
  }) {
    return TrustState(
      trustObject: trustObject ?? this.trustObject,
      isLoading: isLoading ?? this.isLoading,
      chosenTrustLevel: chosenTrustLevel ?? this.chosenTrustLevel,
    );
  }
}
