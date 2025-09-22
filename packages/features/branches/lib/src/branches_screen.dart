import 'package:branches/src/branches_cubit.dart';
import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BranchesViewType{
  dropdown,
  page,
}

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({
    required this.onSubwikiSelected,
    required this.contentRepository,
    this.viewType = BranchesViewType.dropdown,
    this.selectedSubwiki,
    this.enabled = true,
    super.key,
  });

  final Subwiki? selectedSubwiki;
  final BranchesViewType viewType;
  final ContentRepository contentRepository;
  final void Function(Subwiki? subwiki) onSubwikiSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BranchesCubit>(
        create: (context) => BranchesCubit(
          contentRepository: contentRepository,
          selectedSubwiki: selectedSubwiki,
        ),
        child: viewType==BranchesViewType.page
            ? BranchesView(onSubwikiSelected)
            : BranchesDropdown(onSubwikiSelected, enabled: enabled)
    );
  }
}

class BranchesDropdown extends StatelessWidget {
  const BranchesDropdown(this.onSubwikiSelected, {
    this.enabled = true,
    super.key,
  });
  final void Function(Subwiki? subwiki) onSubwikiSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchesCubit, BranchesState>(
      listener: (context, state) {
        if(state.error!=null){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'FAILED TO UPDATE THE LIST'
              ),
            ),
          );
        }
      },
      child: BlocBuilder<BranchesCubit, BranchesState>(
        builder: (context, state) {
          final branch = state.selectedItem;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DropdownSearch<Subwiki>(
                enabled: !state.isLoading && enabled,
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  menuProps: MenuProps(),
                  searchDelay: Duration(milliseconds: 500),
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search...'
                    )
                  )
                ),
                suffixProps: DropdownSuffixProps(
                  clearButtonProps: ClearButtonProps(
                    isVisible: true,
                    padding: const EdgeInsets.all(0),
                  ),
                ),
                compareFn: (item1, item2) => item1==item2,

                items: (filter, loadProps) => state.subwikiList,
                decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                    labelText: "Select branch",
                    helperText: branch?.description,
                    helperMaxLines: 3,
                    // hintText: "Empty = trunk",
                  ),
                ),
                onChanged: (value) {
                  onSubwikiSelected(value);
                  context.read<BranchesCubit>().setSelectedItem(value);
                },
                selectedItem: branch,
              ),
              const SizedBox(height: 6,),
              if(state.isLoading) const LinearProgressIndicator(),
              if(state.lastUpdated!=null && !state.isLoading)
                GestureDetector(
                    onTap: context.read<BranchesCubit>().refreshSubwikis,
                    child: Text('List updated: ${TimeAgo.timeAgo(state.lastUpdated!)}. Tap to refresh.', style: TextStyle(color: Colors.grey),)),
            ],
          );
        }
      ),
    );
  }
}


class BranchesView extends StatelessWidget {
  const BranchesView(this.onSubwikiSelected, {super.key});

  final void Function(Subwiki? subwiki) onSubwikiSelected;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
