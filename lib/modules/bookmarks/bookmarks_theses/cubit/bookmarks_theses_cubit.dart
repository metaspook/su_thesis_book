import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:su_thesis_book/shared/models/models.dart';
import 'package:su_thesis_book/shared/repositories/repositories.dart';

part 'bookmarks_theses_state.dart';

class BookmarksThesesCubit extends Cubit<BookmarksThesesState> {
  BookmarksThesesCubit({
    required ThesisRepo thesisRepo,
    required BookmarkRepo bookmarkRepo,
  })  : _bookmarkRepo = bookmarkRepo,
        _thesisRepo = thesisRepo,
        super(const BookmarksThesesState()) {
    // Initialize Thesis Bookmark subscription.
    // _thesisIdsSubscription =
    //     _bookmarkRepo.ids(PaperType.thesis).listen((thesisIds) async {
    //   //-- Parse bookmarked theses.
    //   final bookmarkedThesis = await _thesisRepo.stream.first.then(
    //     (theses) => theses.where((e) => thesisIds.contains(e.id)).toList(),
    //   );
    //   emit(state.copyWith(theses: bookmarkedThesis));
    // });
    _thesisIdsSubscription = _bookmarkRepo
        .streamByType(PaperType.thesis)
        .listen((thesisBookmarks) async {
      //-- Parse bookmarked researches.
      final bookmarkedResearchIds =
          thesisBookmarks.map((bookmark) => bookmark.paperId);

      final bookmarkedTheses = <Thesis>[];
      for (final bookmarkedTHesisId in bookmarkedResearchIds) {
        final bookmarkedThesis =
            await _thesisRepo.thesisById(bookmarkedTHesisId);
        if (bookmarkedThesis != null) {
          bookmarkedTheses.add(bookmarkedThesis);
        }
      }
      emit(
        state.copyWith(
          theses: bookmarkedTheses,
          thesisBookmarks: thesisBookmarks,
        ),
      );
    });
  }

  final BookmarkRepo _bookmarkRepo;
  late final StreamSubscription<List<Bookmark>> _thesisIdsSubscription;
  final ThesisRepo _thesisRepo;

  void onSelectionToggled(Thesis thesis) {
    final selectedThesis = [...state.selectedTheses];
    // Add if not exist or Remove if exist.
    selectedThesis.contains(thesis)
        ? selectedThesis.remove(thesis)
        : selectedThesis.add(thesis);
    emit(
      state.copyWith(
        status: BookmarksThesesStatus.selecting,
        selectedTheses: selectedThesis,
      ),
    );
  }

  Future<void> onRemoved() async {
    emit(state.copyWith(status: BookmarksThesesStatus.loading));
    final selectedTheses = [...state.selectedTheses];
    for (final thesis in state.selectedTheses) {
      final paper = (type: PaperType.thesis, id: thesis.id);
      await _bookmarkRepo.removeBookmark(paper).then((value) {
        selectedTheses.remove(thesis);
      });
    }
    // checking length if removed any item.
    selectedTheses.length < state.selectedTheses.length
        ? emit(
            state.copyWith(
              status: BookmarksThesesStatus.success,
              selectedTheses: selectedTheses,
            ),
          )
        : emit(state.copyWith(status: BookmarksThesesStatus.failure));
  }

  void onAllSelected() {
    emit(
      state.copyWith(
        status: BookmarksThesesStatus.selecting,
        selectedTheses: state.theses,
      ),
    );
  }

  void onAllDeselected() {
    emit(
      state.copyWith(
        status: BookmarksThesesStatus.initial,
        selectedTheses: const [],
      ),
    );
  }

  @override
  Future<void> close() {
    _thesisIdsSubscription.cancel();
    return super.close();
  }
}