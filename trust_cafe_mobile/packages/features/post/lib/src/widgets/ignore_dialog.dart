import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class IgnoreAlertDialog extends StatelessWidget {
  const IgnoreAlertDialog({super.key,
    required this.authorSlug,
    required this.branchSlug,
  });

  final String authorSlug;
  final String branchSlug;

  @override
  Widget build(BuildContext context) {
    void pop(){
      Navigator.of(context).pop();
    }
    return AlertDialog(
      title: const Text('Choose action'), //TODO: l10n
      content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Changes will take effect after scrolling and can be reverted in the settings'),
              const Divider(),
              const Text('Posts from this user will be hidden from you on this device. The user will not be notified.'),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    await RepositoryProvider.of<UserRepository>(context).modifyIgnoreList(authorSlug, isUser: true, add: true);
                    pop();
                  },
                  child: const Text('Ignore this user'),),
              ),
              const Text('Posts from this branch will be hidden from you on this device.'),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    await RepositoryProvider.of<UserRepository>(context).modifyIgnoreList(branchSlug, isUser: false, add: true);
                    pop();
                  },
                  child: const Text('Ignore this branch'),),
              ),
            ],
          )),
    );
  }
}
