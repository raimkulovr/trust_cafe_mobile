import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart' hide Change;

import 'package:content_repository/content_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:userprofile/userprofile.dart';
import 'package:branch/branch.dart';

import 'changes_cubit.dart';

class ChangesScreen extends StatelessWidget {
  const ChangesScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.appUser,
    super.key,
  });

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return _CallbackProvider(
      getAppUser: ()=>appUser,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: contentRepository),
          RepositoryProvider.value(value: userRepository),
        ],
        child: BlocProvider(
            create: (context) => ChangesCubit(
              contentRepository:contentRepository,
              initialDate: DateTime.now(),
            ),
            child: ChangesView(),
        ),
      ),
    );
  }
}

class ChangesView extends StatelessWidget {
  const ChangesView({super.key});

  String _errorMessage(ChangesStateErrors error) => switch(error){
    ChangesStateErrors.load => 'Failed to load the list',
    ChangesStateErrors.refresh => 'Failed to refresh the list',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<ChangesCubit>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: BlocBuilder<ChangesCubit, ChangesState>(
          buildWhen: (p, c) => p.isLoadingList!=c.isLoadingList || p.date!=c.date,
          builder: (context, state) {
            return AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              title: Text('${state.date == cubit.initialDate ? 'Recent c' : 'C'}hanges'),
              actions: [
                BlocBuilder<ChangesCubit, ChangesState>(
                  buildWhen: (p, c) => p.date!=c.date,
                  builder: (context, state) {
                    final nextMonth = state.date.copyWith(month: state.date.month+1);
                    final previousMonth = state.date.copyWith(month: state.date.month-1);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: previousMonth.year<2022 || (previousMonth.year==2022 && previousMonth.month<8)
                                ? null
                                : () {
                              cubit.setDate(previousMonth);
                            },
                            icon: Transform.rotate(
                              alignment: Alignment.center,
                              angle: 90 * (3.1415926535897932 / 180),
                              child: const Icon(Icons.expand_more),
                            )),
                        GestureDetector(
                            onTap: (){cubit.setDate(cubit.initialDate);},
                            child: Text(state.date.toRecentChanges)),
                        IconButton(
                            onPressed: nextMonth.isAfter(cubit.initialDate)
                                ? null
                                : () {
                              cubit.setDate(nextMonth);
                            },
                            icon: Transform.rotate(
                              alignment: Alignment.center,
                              angle: -90 * (3.1415926535897932 / 180),
                              child: const Icon(Icons.expand_more),
                            ))
                      ],
                    );
                  },),
              ],
            );
          },
        ),
      ),
      body: BlocListener<ChangesCubit, ChangesState>(
        listener: (context, state) {
          if(state.error!=null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage(state.error!)),
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            cubit.refresh();
          },
          child: Column(
            children: [
              BlocBuilder<ChangesCubit, ChangesState>(
                buildWhen: (p, c) => p.isLoadingList!=c.isLoadingList,
                builder: (context, state) {
                  if(state.isLoadingList){
                    return const LinearProgressIndicator();
                  } else {
                    return const SizedBox();
                  }
                },),
              Expanded(
                child: BlocBuilder<ChangesCubit, ChangesState>(
                    buildWhen: (p, c) => p.changesList!=c.changesList,
                    builder: (context, state) {
                      final list = state.changesList;
                      if (list.isEmpty) {
                        //Wrapped in ListView so the empty list could be refreshed.
                        return ListView(
                          children: [
                            const SizedBox(height: 10,),
                            Center(
                              child: Text('The list is empty', style: TextStyle(color: colorScheme.primary),),
                            ),
                          ],
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final change = list[index];
                            return change.isUnknown
                                ? const SizedBox()
                                : ChangeEntry(change);
                          },
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
      );
  }
}

class ChangeEntry extends StatelessWidget {
  const ChangeEntry(this.change, {super.key});

  final Change change;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryTextStyle = TextStyle(color: colorScheme.primary);
    final isSubwiki = change.entity==ChangeEntity.subwiki;
    final changeEntityName = isSubwiki ? 'branch' : change.entity.name;
    final isNew = change.type==ChangeType.created;
    final changeText = change.entity==ChangeEntity.userprofile
        ? isNew
            ? 'created a new profile'
            : 'updated their profile'
        : '${change.type.name} a ${isNew?'new ':''}$changeEntityName${change.changeLabel!=null?'(${change.changeLabel})':''}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeAgo(DateTime.fromMillisecondsSinceEpoch(change.createdAt),
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          RichText(text: TextSpan(
            style: primaryTextStyle,
            children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: UserprofilePopupScreen(
                      contentRepository: RepositoryProvider.of<ContentRepository>(context),
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                      userSlug: change.author.slug,
                      isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
                      appUser: _CallbackProvider.of(context).getAppUser(),
                      child: Text(change.author.fullName,
                          style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold,)
                      )
                  )
              ),
              TextSpan(text: ' '),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: isSubwiki
                      ? BranchPopupScreen(
                          contentRepository: RepositoryProvider.of<ContentRepository>(context),
                          userRepository: RepositoryProvider.of<UserRepository>(context),
                          branchSlug: change.uri.split('/').last,
                          isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
                          appUser: _CallbackProvider.of(context).getAppUser(),
                          child: Text(changeText,
                              style: primaryTextStyle.copyWith(decoration: TextDecoration.underline)),
                        )
                      : GestureDetector(
                          onTap: change.entity==ChangeEntity.userprofile
                              ? null
                              : ()=>UrlLauncher.launchWebUrl(context, change.uri, preventOnFailedMatch: true),
                          child: Text(changeText,
                            style: change.entity==ChangeEntity.userprofile
                                ? primaryTextStyle
                                : primaryTextStyle.copyWith(decoration: TextDecoration.underline),
                          )
                        )
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _CallbackProvider extends InheritedWidget {
  final GetAppUserCallback getAppUser;

  const _CallbackProvider({super.key,
    required this.getAppUser,
    required super.child,
  });

  static _CallbackProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CallbackProvider>();
  }

  static _CallbackProvider of(BuildContext context) {
    final _CallbackProvider? result = maybeOf(context);
    assert(result != null, 'No PostCallbackProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_CallbackProvider oldWidget) {
    return false;
  }
}