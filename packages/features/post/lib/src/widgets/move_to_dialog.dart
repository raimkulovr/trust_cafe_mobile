
import 'package:branches/branches.dart';
import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../post_cubit.dart';

class MoveToAlertDialog extends StatefulWidget {
  const MoveToAlertDialog({
    required this.canMoveToProfile,
    super.key,
  });

  final bool canMoveToProfile;
  @override
  State<MoveToAlertDialog> createState() => _MoveToAlertDialogState();
}

class _MoveToAlertDialogState extends State<MoveToAlertDialog> {

  bool movingToProfile = true;
  Subwiki? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Move this post?'), //TODO: l10n
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width*0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(widget.canMoveToProfile) RadioListTile(
                title: Text('Move to profile'),
                value: true,
                groupValue: movingToProfile,
                onChanged: (value) => setState(() {
                  if(value!=null) movingToProfile=value;
                }),),
              RadioListTile(
                title: Text('Move to branch'),
                value: false,
                groupValue: movingToProfile,
                onChanged: (value) => setState(() {
                  if(value!=null) movingToProfile=value;
                }),),
              if(!movingToProfile)
                BranchesScreen(
                  onSubwikiSelected: (subwiki) {selectedBranch = subwiki;},
                  contentRepository: RepositoryProvider.of<ContentRepository>(context),
                  selectedSubwiki: selectedBranch,
                )
            ],),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TcmPrimaryButton(
            onPressed: () {
              if(movingToProfile){
                context.read<PostCubit>().movePostToUserProfile();
              } else {
                final selectedBranch = this.selectedBranch;
                if (selectedBranch!=null) {
                  context.read<PostCubit>().updatePostBranch(slug: selectedBranch.slug, label: selectedBranch.label);
                } else return;
              }
              Navigator.of(context).pop();
            },
            text: 'Save'),
      ],
    );
  }
}

