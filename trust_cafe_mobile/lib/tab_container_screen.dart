import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class TabContainerView extends StatelessWidget {
  const TabContainerView(this.appUser, {super.key});
  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    final tabState = CupertinoTabPage.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      controller: tabState.controller,
      tabBuilder: tabState.tabBuilder,
      tabBar: CupertinoTabBar(
        border: Border.all(color: Colors.transparent),
        items: [
          BottomNavigationBarItem(
            icon: const TrunkIcon(height: 24, color: CupertinoColors.inactiveGray,),
            activeIcon: TrunkIcon(height: 24, color: colorScheme.primary,),
          ),
          if(appUser.isNotGuest) BottomNavigationBarItem(
            icon: const Icon(Icons.groups),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
