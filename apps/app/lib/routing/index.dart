import 'package:go_router/go_router.dart';
import 'package:news_blog/pages/home.dart';
import 'package:news_blog/pages/post.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      name: 'home',
      builder: (context, state) => const MyHomePage(title: 'News Blog Home'),
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
