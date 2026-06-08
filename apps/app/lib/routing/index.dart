import 'package:go_router/go_router.dart';
import 'package:news_blog/pages/home.dart';
import 'package:news_blog/pages/post.dart';
import 'package:news_blog/pages/settings.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: "/", name: 'home', builder: (context, state) => MyHomePage()),
    GoRoute(
      path: "/settings",
      name: 'settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: '/post/:id/:title',
      name: 'post',
      builder: (context, state) => PostPage(
        title: state.pathParameters['title'] ?? '',
        postId: state.pathParameters['id']!,
      ),
    ),
  ],
);
