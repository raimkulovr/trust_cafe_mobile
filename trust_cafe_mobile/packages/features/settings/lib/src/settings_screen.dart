import 'dart:io';

import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:user_repository/user_repository.dart';
import 'settings_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.userRepository,
    super.key,
  });

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (_) => SettingsCubit(userRepository: userRepository),
        child: const SettingsView(),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  final items = const [
    _ApiChannelSelector(),
    _TranslationTargetSelector(),
    _AppThemeModeSelector(),
    _ImageSizeThresholdSetter(),
    _IgnoreListManager(),
    _FeedbackFormLauncher(),
    _ClearCacheButton(),
    Divider(),
    _SignOutButton(),
    _CurrentVersion(),
    SizedBox(height: 56,),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => const SizedBox(height: 10,),
        ),
      ),
    );
  }
}

class _FeedbackFormLauncher extends StatelessWidget {
  const _FeedbackFormLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          UrlLauncher.launchWebUrl(context,
              'https://forms.gle/MAGUrzggphoB1UYS8');
        },
        child: const Text('Send feedback'),
    );
  }
}


class _CurrentVersion extends StatelessWidget {
  const _CurrentVersion({super.key});

  static const _version = 'R3P9/Fix-2';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Center(child:
        Text('Version: $_version', style: TextStyle(color: Colors.grey),)),
    );
  }
}


class _SignOutButton extends StatelessWidget {
  const _SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return (state.authenticatedUser!=null && !state.authenticatedUser!.isGuest)
            ? ElevatedButton(
                onPressed: () async {
                  context.read<SettingsCubit>().signOut();
                },
                child: const Text('Log out'))
            : const SizedBox();
      },);
  }
}


class _EmptyImageCacheButton extends StatefulWidget {
  const _EmptyImageCacheButton({super.key});

  @override
  State<_EmptyImageCacheButton> createState() => _EmptyImageCacheButtonState();
}

class _EmptyImageCacheButtonState extends State<_EmptyImageCacheButton> {
  bool isDeletingCache = false;
  Future<void> _clearFileCache() async {
    final tempDir = Directory(p.join((await getTemporaryDirectory()).path, DefaultCacheManager.key));
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  }

  void _onCacheDeleted() async {
    setState(() {
      isDeletingCache = true;
    });
    AsyncImageViewer.existingImagesCache.clear();
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
    await _clearFileCache();
    setState(() {
      isDeletingCache = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDeletingCache
        ? const LinearProgressIndicator()
        : TextButton(
            onPressed: _onCacheDeleted,
            child: const Text('Clear image cache'));
  }
}

class _ApiChannelSelector extends StatelessWidget {
  const _ApiChannelSelector();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Select the API channel. This will log you out.'), //TODO: l10n
      BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) => previous.isApiChannelProduction!=current.isApiChannelProduction,
          builder: (context, state) {
            return DropdownMenu<bool>(
                initialSelection: state.isApiChannelProduction,
                onSelected: (value) async {
                  if (value != null) {
                    context.read<SettingsCubit>().setApiChannel(value);
                  }
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: false, label: 'Alpha'),
                  DropdownMenuEntry(value: true, label: 'Production')
                ]);
          }
      ),
    ],);
  }
}

class _TranslationTargetSelector extends StatelessWidget {
  const _TranslationTargetSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Translate to:'), //TODO: l10n
      BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) => previous.translationTargetCode!=current.translationTargetCode,
          builder: (context, state) {
            return DropdownMenu<String>(
                menuHeight: MediaQuery.of(context).size.height*0.6,
                initialSelection: state.translationTargetCode,
                onSelected: (value) async {
                  if (value != null) {
                    context.read<SettingsCubit>().setTranslationTarget(value);
                  }
                },
                dropdownMenuEntries: LanguageCodes.list.entries.map(
                        (e) => DropdownMenuEntry(value: e.key, label: e.value)).toList());
          }
      ),
    ],);
  }
}
class _AppThemeModeSelector extends StatelessWidget {
  const _AppThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('App Theme:'), //TODO: l10n
      BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) => previous.appThemeMode!=current.appThemeMode,
          builder: (context, state) {
            return DropdownMenu<String>(
                initialSelection: state.appThemeMode,
                onSelected: (value) async {
                  if (value != null) {
                    context.read<SettingsCubit>().setAppThemeMode(value);
                  }
                },
                dropdownMenuEntries: ['light', 'system', 'dark'].map(
                        (e) => DropdownMenuEntry(value: e, label: '${e[0].toUpperCase()}${e.substring(1)}')).toList());
          }
      ),
    ],);
  }
}

class _IgnoreListManager extends StatefulWidget {
  const _IgnoreListManager({super.key});

  @override
  State<_IgnoreListManager> createState() => _IgnoreListManagerState();
}

class _IgnoreListManagerState extends State<_IgnoreListManager> with SingleTickerProviderStateMixin {

  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget listBuilder(List<String> list, void Function(String) onTap){
    return list.isEmpty
        ? const Center(child: Text('The list is empty!'))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (listViewContext, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(children: [
                Expanded(
                  child: Text(list[index],
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                GestureDetector(
                  onTap: ()=>onTap(list[index]),
                  child: Text('x'),
                )
              ],),
            ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = RepositoryProvider.of<UserRepository>(context);
    return TextButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text('The list of ignored'),
                content: SingleChildScrollView(
                  child: SizedBox(
                    height: 400,
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Is this the best way to deal with this?...'),
                        TabBar(
                          tabs: const [
                            Tab(text: 'Users',),
                            Tab(text: 'Branches',),
                          ],
                          controller: tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: userRepository.ignoredListStream,
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) return const CircularProgressIndicator();
                              final data = snapshot.data;
                              final users = data!.users.toList();
                              final branches = data.branches.toList();
                              return TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: tabController,
                                children: [
                                  listBuilder(users, (String slug)=>userRepository.modifyIgnoreList(slug, isUser: true, add: false)),
                                  listBuilder(branches, (String slug)=>userRepository.modifyIgnoreList(slug, isUser: false, add: false)),
                                ],
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },);
        },
        child: const Text('Manage the list of ignored'));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class _ImageSizeThresholdSetter extends StatelessWidget {
  const _ImageSizeThresholdSetter({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) =>
          p.imageSizeThreshold != c.imageSizeThreshold,
        builder: (context, state) {
          final val = state.imageSizeThreshold;
          return Row(
            children: [
              Checkbox(
                value: val!=null,
                onChanged: (newVal) => cubit.setImageSizeThreshold(val!=null ? null : '4')
              ),
              GestureDetector(
                  onTap: () => cubit.setImageSizeThreshold(val!=null ? null : '4'),
                  child: Text('Set the image size threshold (MB)')),
              const Spacer(),
              if(val!=null)
                _ImageSizeThresholdTextField(val.toString())
            ],
          );
        });
  }
}

class _ImageSizeThresholdTextField extends StatefulWidget {
  const _ImageSizeThresholdTextField(this.initialValue, {super.key});

  final String initialValue;

  @override
  State<_ImageSizeThresholdTextField> createState() => _ImageSizeThresholdTextFieldState();
}

class _ImageSizeThresholdTextFieldState extends State<_ImageSizeThresholdTextField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child:
      BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if(_textController.text!=state.imageSizeThreshold.toString()){
              _textController.text = state.imageSizeThreshold.toString();
            }
          },
          builder: (context, state) {
            return TextField(
              controller: _textController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              onEditingComplete: () => context.read<SettingsCubit>().setImageSizeThreshold(_textController.text),
              onSubmitted: (newVal) => context.read<SettingsCubit>().setImageSizeThreshold(newVal),
              onChanged: (newVal) => context.read<SettingsCubit>().setImageSizeThreshold(newVal),
              onTapOutside: (_) => context.read<SettingsCubit>().setImageSizeThreshold(_textController.text),
            );
          }
        ));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _ClearNonImageCacheButton extends StatelessWidget {
  const _ClearNonImageCacheButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: context.read<SettingsCubit>().clearNonImageCache,
        child: const Text('Clear data cache'));
  }
}

class _ClearCacheButton extends StatelessWidget {
  const _ClearCacheButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          showDialog(context: context, builder: (_) {
            return BlocProvider.value(
              value: context.read<SettingsCubit>(),
              child: const AlertDialog(
                title: Text('Clear cache options'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select the type of cache you want to clear. Removing cached data can free up storage and improve app performance. This action won\'t delete personal data or settings.'
                    ),
                  ],
                ),
                actions: [
                  _EmptyImageCacheButton(),
                  _ClearNonImageCacheButton(),
                ],
              ),
            );
          },);
        },
        child: const Text('Clear cache')
    );
  }
}


