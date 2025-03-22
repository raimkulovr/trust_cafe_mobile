import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import 'package:user_repository/user_repository.dart';

part 'draft_manager_state.dart';

class DraftManagerCubit extends Cubit<DraftManagerState> {
  DraftManagerCubit({
    required this.typeIsPost,
    required UserRepository userRepository,
    required QuillController controller,
  }) : _userRepository = userRepository,
        _controller = controller,
        super(const DraftManagerState())
  {
    _loadQuickDraftFromMemory();
    _loadDraftsFromMemory();
  }

  final bool typeIsPost;
  final UserRepository _userRepository;
  final QuillController _controller;

  void _loadQuickDraftFromMemory() async {
    emit(state.copyWith(isLoadingQuickSaveSlot: true));
    final memoryQuickDraft = await _userRepository.getDraftQuickSave();
    if(memoryQuickDraft is String){
      emit(state.copyWith(
          isLoadingQuickSaveSlot: false,
          quickSaveSlot: Wrapped.value((jsonDecode(memoryQuickDraft) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList())));
    } else {
      emit(state.copyWith(isLoadingQuickSaveSlot: false));
    }
  }

  void _loadDraftsFromMemory() async {
    emit(state.copyWith(isLoadingDraftList: true));
    final memoryDraftList = (await _userRepository.getDraftList()).map((e) => Draft.fromMap(jsonDecode(e))).toList();
    memoryDraftList.sort((a, b) => b.timestamp.compareTo(a.timestamp),);
    if(memoryDraftList.isNotEmpty){
      emit(state.copyWith(
          isLoadingDraftList: false,
          draftList: Wrapped.value(memoryDraftList)));
    } else {
      emit(state.copyWith(isLoadingDraftList: false));
    }
  }

  void quickLoadDraft() async {
    if(state.quickSaveSlot==null) return;
    _controller.clear();
    _controller.replaceText(0, 1, Document.fromJson(state.quickSaveSlot!).toDelta(), null);
  }

  void quickSaveDraft() async {
    final quickSaveDraft = _controller.document.toDelta().toJson();
    emit(state.copyWith(quickSaveSlot: Wrapped.value(quickSaveDraft)));
    _userRepository.upsertDraftQuickSave(jsonEncode(quickSaveDraft));
  }

  void saveDraft(String title){
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newDraft = Draft(id: const Uuid().v4(), title: title, timestamp: timestamp, encodedDocument: jsonEncode(_controller.document.toDelta().toJson()));
    emit(state.copyWith(draftList: Wrapped.value([
      newDraft,
      ...?state.draftList,
    ])));
    _userRepository.upsertDraft(newDraft.id, jsonEncode(newDraft.toMap()));
  }

  void loadDraft(String id){
    if(state.draftList==null) return;
    _controller.clear();
    _controller.replaceText(0, 1, Document.fromJson(state.draftList!.firstWhere((e) => e.id==id,).document).toDelta(), null);
  }

  void deleteDraft(String id) async {
    if(state.draftList==null) return;
    emit(state.copyWith(draftList: Wrapped.value(state.draftList!.where((e) => e.id!=id,).toList())));
    await _userRepository.deleteDraft(id);
  }

}
