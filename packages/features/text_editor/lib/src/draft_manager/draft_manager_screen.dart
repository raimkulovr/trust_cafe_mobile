import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:text_editor/src/draft_manager/draft_manager_cubit.dart';
import 'package:user_repository/user_repository.dart';

class DraftManagerScreen extends StatelessWidget {
  const DraftManagerScreen({
    required this.typeIsPost,
    required this.userRepository,
    required this.controller,
  });

  final bool typeIsPost;
  final UserRepository userRepository;
  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DraftManagerCubit(
            typeIsPost: typeIsPost,
            userRepository: userRepository,
            controller: controller,
        ),
        child: const DraftManagerView());
  }

}


class DraftManagerView extends StatefulWidget {
  const DraftManagerView({super.key});

  @override
  State<DraftManagerView> createState() => _DraftManagerViewState();
}

class _DraftManagerViewState extends State<DraftManagerView> {

  final _textController = TextEditingController();
  DraftManagerCubit get cubit => context.read<DraftManagerCubit>();

  void saveDialog() async {
    _textController.text = 'New Draft';
    final draftName = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Save draft'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 1,
                    autofocus: true,
                    maxLength: 255,
                    decoration: InputDecoration(
                      hintText: 'Draft name'
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(onPressed: _textController.clear,
                          child: Text('Clear', style: TextStyle(color: Colors.red))),
                      TextButton(onPressed: (){
                        if(_textController.text.trim().isEmpty) return;
                        Navigator.pop(context, _textController.text.trim());
                      }, child: Text('Save')),
                    ],
                  )
                ],),
            ),
          );
        },);

    if(draftName is String){
      cubit.saveDraft(draftName);
    }
  }

  void loadDialog() async {
    final chosenDraft = await showDialog(
      context: context,
      builder: (alertcontext) {
        return AlertDialog(
          title: Text('Load draft'),
          content: BlocBuilder<DraftManagerCubit, DraftManagerState>(
            bloc: cubit,
            builder: (context, state) {
              return SingleChildScrollView(
                child: state.draftList!=null && state.draftList!.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cubit.state.draftList!.map((e) {
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  dense: true,
                                  onTap: () {
                                    Navigator.of(alertcontext).pop(e.id);
                                  },
                                  title: Text(e.title),
                                  subtitle: TimeAgo(DateTime.fromMillisecondsSinceEpoch(e.timestamp)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    cubit.deleteDraft(e.id);
                                  },
                                  icon: Icon(Icons.clear))
                            ],
                          );
                        },).toList(),)
                    : const Center(child: Text('The list is empty'),)
              );
            }
          ),
        );
      },);

    if(chosenDraft is String){
      cubit.loadDraft(chosenDraft);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero);
          final left = offset.dx;
          final top = offset.dy;
          final right = left + renderBox.size.width;
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(left, top, right, 0.0),
            items: [
              PopupMenuItem(
                child: Text('Quick save'),
                onTap: cubit.quickSaveDraft,
              ),
              PopupMenuWidget(
                height: 46,
                child: BlocBuilder<DraftManagerCubit, DraftManagerState>(
                  bloc: cubit,
                  buildWhen: (p, c) => p.isLoadingQuickSaveSlot!=c.isLoadingQuickSaveSlot,
                  builder: (context, state) {
                    return PopupMenuItem(
                      enabled: !state.isLoadingQuickSaveSlot,
                      child: Text('Quick load'),
                      onTap: cubit.quickLoadDraft,
                    );
                  },),
              ),
              PopupMenuItem(
                child: Text('Save…'),
                onTap: saveDialog,
              ),
              PopupMenuWidget(
                height: 46,
                child: BlocBuilder<DraftManagerCubit, DraftManagerState>(
                  bloc: cubit,
                  buildWhen: (p, c) => p.isLoadingDraftList!=c.isLoadingDraftList,
                  builder: (context, state) {
                    return PopupMenuItem(
                      enabled: !state.isLoadingDraftList,
                      child: Text('Load…'),
                      onTap: loadDialog,
                    );
                  },),
              ),
            ]);
        },
        child: Text('Drafts')
    );
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }
}
