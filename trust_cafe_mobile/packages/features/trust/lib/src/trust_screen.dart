import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trust/src/trust_cubit.dart';

class TrustScreen extends StatelessWidget {
  const TrustScreen({
    required this.contentRepository,
    required this.userSlug,
    required this.appUserTrustLevelInt,
    super.key,
  });


  final ContentRepository contentRepository;
  final String userSlug;
  final int appUserTrustLevelInt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrustCubit(contentRepository: contentRepository, userSlug: userSlug),
      child: TrustView(appUserTrustLevelInt),
    );
  }
}

class TrustView extends StatelessWidget {
  const TrustView(this.appUserTrustLevelInt, {super.key});
  final int appUserTrustLevelInt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      // padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Set your trust boost for this user', style: TextStyle(fontSize: 16,)), //TODO: l10n
          BlocBuilder<TrustCubit, TrustState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if(state.isLoading)
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    Slider(
                      value: state.chosenTrustLevel,
                      min: appUserTrustLevelInt>=3 ? -20 : 0,
                      max: 100,
                      divisions: appUserTrustLevelInt>=3 ? 6 : 5,
                      onChanged: (value) {
                        context.read<TrustCubit>().setChosenTrustLevel(value);
                      },
                    ),
                    Text('${state.chosenTrustLevel.toInt()}%'),
                  ],
                );
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text('Close')
                ),
                const SizedBox(width: 10,),
                TcmPrimaryButton(onPressed: () {
                    context.read<TrustCubit>().saveTrustSetting();
                    Navigator.of(context).pop();
                  }, text: 'Save',
                ),
            ],),
          )
        ],
      ),
    );
  }
}
