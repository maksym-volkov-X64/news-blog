import 'package:go_router/go_router.dart';
import 'package:news_blog/pages/home.dart';
import 'package:news_blog/pages/post.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MyHomePage(title: 'News Blog Home'),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) => PostPage(
        title: 'page ${state.pathParameters['id']}',
        postId: state.pathParameters['id']!,
      ),
    ),
  ],
);
