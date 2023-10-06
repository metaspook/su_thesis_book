import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:su_thesis_book/modules/home/home.dart';
import 'package:su_thesis_book/theme/theme.dart';

// typedef HomeBlocSelector<T> = BlocSelector<HomeCubit, HomeState, T>;
// typedef ThesesBlocSelector<T> = BlocSelector<ThesesCubit, ThesesState, T>;
typedef ThesesBlocListener = BlocListener<ThesesCubit, ThesesState>;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewRecords = [
      (
        label: 'Home',
        icon: Icons.home_rounded,
        appBar: const HomeAppBar(),
        view: const HomeView(),
      ),
      (
        label: 'Theses',
        icon: Icons.folder_rounded,
        appBar: const ThesesAppBar(),
        view: const ThesesView(),
      ),
    ];
    final cubit = context.read<HomeCubit>();
    final viewIndex =
        context.select((HomeCubit cubit) => cubit.state.viewIndex);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) =>
            [viewRecords[viewIndex].appBar],
        body: viewRecords[viewIndex].view,
      ),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: AppThemes.topRadius,
        child: NavigationBar(
          height: kBottomNavigationBarHeight * 1.25,
          selectedIndex: viewIndex,
          onDestinationSelected: cubit.onDestinationSelected,
          destinations: [
            for (final viewRecord in viewRecords)
              NavigationDestination(
                icon: Icon(viewRecord.icon),
                label: viewRecord.label,
              ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton.extended(
      //   label: const Text('Add Thesis'),
      //   icon: const Icon(Icons.playlist_add_outlined),
      //   onPressed: () => ThesisEntryDialog.show(context),
      // ),
    );
  }
}
