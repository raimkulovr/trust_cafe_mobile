part of 'draft_manager_cubit.dart';

final class Draft {
  Draft({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.encodedDocument,
  });

  final String id;
  final String title;
  final int timestamp;
  final String encodedDocument;
  late final List<Map<String, dynamic>> document = (jsonDecode(encodedDocument) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp,
      'encodedDocument': encodedDocument,
    };
  }

  factory Draft.fromMap(Map<String, dynamic> map) {
    return Draft(
      id: map['id'] as String,
      title: map['title'] as String,
      timestamp: map['timestamp'] as int,
      encodedDocument: map['encodedDocument'] as String,
    );
  }

}

final class DraftManagerState extends Equatable {
  const DraftManagerState({
    this.quickSaveSlot,
    this.draftList,
    this.isLoadingQuickSaveSlot = false,
    this.isLoadingDraftList = false,
  });

  final List<Draft>? draftList;
  final List<Map<String, dynamic>>? quickSaveSlot;
  final bool isLoadingQuickSaveSlot;
  final bool isLoadingDraftList;

  @override
  List<Object?> get props => [
    draftList,
    quickSaveSlot,
    isLoadingQuickSaveSlot,
    isLoadingDraftList,
  ];

  DraftManagerState copyWith({
    Wrapped<List<Draft>?>? draftList,
    Wrapped<List<Map<String, dynamic>>?>? quickSaveSlot,
    bool? isLoadingQuickSaveSlot,
    bool? isLoadingDraftList,
  }) {
    return DraftManagerState(
      draftList: draftList!=null ? draftList.value : this.draftList,
      quickSaveSlot: quickSaveSlot!=null ? quickSaveSlot.value : this.quickSaveSlot,
      isLoadingQuickSaveSlot:
          isLoadingQuickSaveSlot ?? this.isLoadingQuickSaveSlot,
      isLoadingDraftList: isLoadingDraftList ?? this.isLoadingDraftList,
    );
  }

}

