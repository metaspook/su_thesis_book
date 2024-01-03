part of 'router.dart';

final class AppRouter {
  AppRouter({this.initialLocation, this.navigatorKey})
      : config = GoRouter(
          //-- Register routes
          routes: <RouteBase>[
            auth,
            bookmarks,
            comments,
            home,
            notifications,
            passwordReset,
            profile,
            publisher,
            publishers,
            research,
            researchEntry,
            thesis,
            thesisEntry,
          ],
          initialLocation: initialLocation,
          navigatorKey: navigatorKey,
        ) {
    config.routeInformationProvider.value.uri.doPrint('Current Route: ');
  }

  final GlobalKey<NavigatorState>? navigatorKey;
  final String? initialLocation;
  final GoRouter config;

  //-- Define routes
  // Auth
  static final auth = GoRoute(
    name: 'auth',
    path: '/auth',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              authRepo: context.read<AuthRepo>(),
              appUserRepo: context.read<AppUserRepo>(),
            ),
          ),
        ],
        child: const AuthPage(),
      );
    },
  );

  // Home
  static final home = GoRoute(
    name: 'home',
    path: '/',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ResearchesNavCubit>(
            create: (context) => ResearchesNavCubit(),
          ),
          BlocProvider<ThesesNavCubit>(
            create: (context) => ThesesNavCubit(),
          ),
        ],
        child: const HomePage(),
      );
    },
  );

  // Bookmarks
  static final bookmarks = GoRoute(
    name: 'bookmarks',
    path: '/bookmarks',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<BookmarksCubit>(
            create: (context) => BookmarksCubit(),
          ),
          BlocProvider<BookmarksResearchesCubit>(
            create: (context) => BookmarksResearchesCubit(
              bookmarkRepo: context.read<BookmarkRepo>(),
              researchRepo: context.read<ResearchRepo>(),
            ),
          ),
          BlocProvider<BookmarksThesesCubit>(
            create: (context) => BookmarksThesesCubit(
              bookmarkRepo: context.read<BookmarkRepo>(),
              thesisRepo: context.read<ThesisRepo>(),
            ),
          ),
        ],
        child: const BookmarksPage(),
      );
    },
  );

  // // Notifications
  static final notifications = GoRoute(
    name: 'notifications',
    path: '/notifications',
    builder: (context, state) {
      return const NotificationsPage();
    },
  );

  // Password Reset
  static final passwordReset = GoRoute(
    name: 'passwordReset',
    path: '/password_reset',
    builder: (context, state) {
      return BlocProvider<PasswordResetBloc>(
        create: (context) => PasswordResetBloc(
          authRepo: context.read<AuthRepo>(),
        ),
        child: const PasswordResetPage(),
      );
    },
  );

  // Profile
  static final profile = GoRoute(
    name: 'profile',
    path: '/profile',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              authRepo: context.read<AuthRepo>(),
            ),
          ),
          BlocProvider<ProfileUpdateBloc>(
            create: (context) => ProfileUpdateBloc(
              authRepo: context.read<AuthRepo>(),
              appUserRepo: context.read<AppUserRepo>(),
            ),
          ),
        ],
        child: const ProfilePage(),
      );
    },
  );

  // Publisher
  static final publisher = GoRoute(
    name: 'publisher',
    path: '/publisher',
    builder: (context, state) {
      final publisher = state.extra! as Publisher;
      return PublisherPage(publisher: publisher);
    },
  );

  // Publishers
  static final publishers = GoRoute(
    name: 'publishers',
    path: '/publishers',
    builder: (context, state) {
      return const PublishersPage();
    },
  );

  // Research
  static final research = GoRoute(
    name: 'research',
    path: '/research',
    builder: (context, state) {
      final researchId = state.extra! as String;
      return BlocProvider<ResearchCubit>(
        create: (context) => ResearchCubit(
          researchRepo: context.read<ResearchRepo>(),
          bookmarkRepo: context.read<BookmarkRepo>(),
          researchId: researchId,
        ),
        child: ResearchPage(),
      );
    },
  );

  // Research Entry
  static final researchEntry = GoRoute(
    name: 'researchEntry',
    path: '/research_entry',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ResearchEntryCubit>(
            create: (context) => ResearchEntryCubit(),
          ),
          BlocProvider<ResearchNewEntryCubit>(
            create: (context) => ResearchNewEntryCubit(
              researchRepo: context.read<ResearchRepo>(),
            ),
          ),
          BlocProvider<ResearchEntriesCubit>(
            create: (context) => ResearchEntriesCubit(
              researchRepo: context.read<ResearchRepo>(),
            ),
          ),
        ],
        child: const ResearchEntryPage(),
      );
    },
  );

  // Thesis
  static final thesis = GoRoute(
    name: 'thesis',
    path: '/thesis',
    builder: (context, state) {
      final thesisId = state.extra! as String;
      return BlocProvider<ThesisCubit>(
        create: (context) => ThesisCubit(
          thesisRepo: context.read<ThesisRepo>(),
          bookmarkRepo: context.read<BookmarkRepo>(),
          thesisId: thesisId,
        ),
        child: const ThesisPage(),
      );
    },
  );

  // Thesis Entry
  static final thesisEntry = GoRoute(
    name: 'thesisEntry',
    path: '/thesis_entry',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ThesisEntryCubit>(
            create: (context) => ThesisEntryCubit(),
          ),
          BlocProvider<ThesisNewEntryCubit>(
            create: (context) => ThesisNewEntryCubit(
              thesisRepo: context.read<ThesisRepo>(),
            ),
          ),
          BlocProvider<ThesisEntriesCubit>(
            create: (context) => ThesisEntriesCubit(
              thesisRepo: context.read<ThesisRepo>(),
            ),
          ),
        ],
        child: const ThesisEntryPage(),
      );
    },
  );

  // Comments
  static final comments = GoRoute(
    name: 'comments',
    path: '/comments',
    builder: (context, state) {
      final paper = state.extra! as Paper;
      return RepositoryProvider<CommentRepo>(
        create: (context) => CommentRepo(paper: paper),
        child: BlocProvider<CommentsCubit>(
          create: (context) => CommentsCubit(
            notificationRepo: context.read<NotificationRepo>(),
            commentRepo: context.read<CommentRepo>(),
          ),
          child: CommentsPage(paper: paper),
        ),
      );
    },
  );
}

// extension GoRouteExt on GoRoute {
//   String get pathUnderRoot => '/$path';
// }
