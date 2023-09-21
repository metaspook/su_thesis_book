import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:su_thesis_book/shared/models/models.dart';
import 'package:su_thesis_book/shared/repositories/repositories.dart';
import 'package:su_thesis_book/utils/utils.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required AuthRepo authRepo, required AppUserRepo appUserRepo})
      : _authRepo = authRepo,
        _appUserRepo = appUserRepo,
        super(const AppState.unauthenticated()) {
    //-- Initialize Authentication.
    _userSubscription = _authRepo.userStream.listen((user) async {
      // Check authUser from stream.
      if (user != null) {
        // Get appUser by authUser's id.
        final appUserRecord = await _appUserRepo.read(user.uid);
        final errorMsg = appUserRecord.$1;
        final appUser = appUserRecord.object;
        if (appUser.isNotEmpty) {
          'user: $user'.doPrint();
          emit(AppState.authenticated(appUser));
        } else {
          emit(state.copyWith(statusMsg: errorMsg));
          // Sign out authUser because user data not found.
          // await _authRepo.signOut();
        }
      } else {
        emit(
          state.copyWith(
            status: AppStatus.unauthenticated,
            user: AppUser.empty,
          ),
        );
      }
    });
  }

  final AuthRepo _authRepo;
  final AppUserRepo _appUserRepo;
  late final StreamSubscription<User?> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}