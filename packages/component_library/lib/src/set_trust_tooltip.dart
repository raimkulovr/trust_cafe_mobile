import 'package:flutter/material.dart';

import '../component_library.dart';

class SetTrustTooltip extends StatelessWidget {
  const SetTrustTooltip(this.trustSetterCallback, {super.key});

  final Widget Function() trustSetterCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      height: 15,
      child: FittedBox(
        child: PopupMenuButton(
          tooltip: 'Set your trust boost for this user',
          padding: EdgeInsets.zero,
          icon: const UnknownTrustIcon(),
          itemBuilder: (context) => [PopupMenuWidget(height: MediaQuery.of(context).size.width*0.3, child: trustSetterCallback())],
        ),
      ),
    );
  }
}
