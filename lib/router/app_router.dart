// part of 'app_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:su_thesis_book/app/app.dart';
import 'package:su_thesis_book/modules/auth/auth.dart';
import 'package:su_thesis_book/modules/home/home.dart';
import 'package:su_thesis_book/modules/profile/profile.dart';
import 'package:su_thesis_book/shared/repositories/repositories.dart';

// Exposes routing interface for view.
export 'package:go_router/go_router.dart' show GoRouterHelper;

final class AppRouter {
  //-- Register routes
  final config = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      // root,
      home,
      auth,
      profile,
    ],
  );

  //-- Define routes
  // Home
  static final home = GoRoute(
    name: 'home',
    path: '/',
    builder: (context, state) {
      return const HomePage();
    },
  );
  // Auth
  static final auth = GoRoute(
    name: 'auth',
    path: '/auth',
    redirect: (context, state) {
      final isAuthenticated =
          context.watch<AppCubit>().state.status == AppStatus.authenticated;
      return isAuthenticated ? '/' : null;
    },
    builder: (context, state) {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepo>(
            create: (context) => const AuthRepo(),
          ),
          RepositoryProvider<ImageRepo>(
            create: (context) => const ImageRepo(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SignUpBloc>(
              create: (context) => SignUpBloc(
                authRepo: context.read<AuthRepo>(),
                imageRepo: context.read<ImageRepo>(),
              ),
            ),
          ],
          child: const AuthPage(),
        ),
      );
    },
  );
  // Profile
  static final profile = GoRoute(
    name: 'profile',
    path: '/profile',
    builder: (context, state) {
      return const ProfilePage();
    },
  );
}
