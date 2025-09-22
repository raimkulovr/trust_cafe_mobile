part of 'text_editor_cubit.dart';

enum TextEditorStage {
  editing,
  preview,
}

class TextEditorState extends Equatable {
  const TextEditorState({
    this.stage = TextEditorStage.editing,
    this.textHtml = '',
    this.isCollaborative = true,
    this.cardUrl = '',
    this.finalHtml,
    this.processingImageUpload = false,
    this.imageUploadError,
    this.selectedBranch,
    this.postToProfile = false,
    this.processingTextHtml = false,
    this.characterAmount = 0,
    this.wrapImagesWithLinks = true,
    this.hideImages = false,
    this.blurLabel,
    this.compressImages = false,
  });

  final TextEditorStage stage;
  final String textHtml;
  final bool isCollaborative;
  final String cardUrl;
  final String? finalHtml;
  final bool processingImageUpload;
  final dynamic imageUploadError;
  final Subwiki? selectedBranch;
  final bool postToProfile;
  final bool processingTextHtml;
  final int characterAmount;
  final bool wrapImagesWithLinks;
  final bool hideImages;
  final String? blurLabel;
  final bool compressImages;

  @override
  List<Object?> get props => [
    stage,
    textHtml,
    isCollaborative,
    cardUrl,
    finalHtml,
    processingImageUpload,
    imageUploadError,
    selectedBranch,
    postToProfile,
    processingTextHtml,
    characterAmount,
    wrapImagesWithLinks,
    hideImages,
    blurLabel,
    compressImages,
  ];

  @override
  String toString() {
    return 'TextEditorState{stage: $stage, textHtml: ${textHtml.safeSubstring(end: 50)}, isCollaborative: $isCollaborative, cardUrl: $cardUrl, finalHtml: $finalHtml, processingImageUpload: $processingImageUpload, imageUploadError: $imageUploadError, selectedBranch: $selectedBranch, postToProfile: $postToProfile, processingTextHtml: $processingTextHtml, characterAmount: $characterAmount, wrapImagesWithLinks: $wrapImagesWithLinks, hideImages: $hideImages, blurLabel: $blurLabel, compressImages: $compressImages}';
  }

  TextEditorState copyWith({
    TextEditorStage? stage,
    String? textHtml,
    bool? isCollaborative,
    String? cardUrl,
    String? finalHtml,
    bool? processingImageUpload,
    Wrapped<dynamic>? imageUploadError,
    Wrapped<Subwiki?>? selectedBranch,
    bool? postToProfile,
    bool? processingTextHtml,
    int? characterAmount,
    bool? wrapImagesWithLinks,
    bool? hideImages,
    bool? compressImages,
    Wrapped<String?>? blurLabel,
  }) {
    return TextEditorState(
      stage: stage ?? this.stage,
      textHtml: textHtml ?? this.textHtml,
      isCollaborative: isCollaborative ?? this.isCollaborative,
      cardUrl: cardUrl ?? this.cardUrl,
      finalHtml: finalHtml ?? this.finalHtml,
      processingImageUpload: processingImageUpload ?? this.processingImageUpload,
      imageUploadError: imageUploadError!=null ? imageUploadError.value : this.imageUploadError,
      selectedBranch: selectedBranch!=null ? selectedBranch.value : this.selectedBranch,
      postToProfile: postToProfile ?? this.postToProfile,
      processingTextHtml: processingTextHtml ?? this.processingTextHtml,
      characterAmount: characterAmount ?? this.characterAmount,
      wrapImagesWithLinks: wrapImagesWithLinks ?? this.wrapImagesWithLinks,
      hideImages: hideImages ?? this.hideImages,
      compressImages: compressImages ?? this.compressImages,
      blurLabel: blurLabel!=null ? blurLabel.value : this.blurLabel,
    );
  }
}