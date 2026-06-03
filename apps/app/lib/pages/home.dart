import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:news_blog/env/env.dart';
import 'package:news_blog/models/payload.dart';

final dio = Dio();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [_pages()]),
    );
  }
}

FutureBuilder _pages() {
  return FutureBuilder(
    future: getPages(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load pages'));
        }

        final List<PageModel> pages = (snapshot.data!.data['docs'] as List)
            .map<PageModel>((page) => PageModel.fromJson(page))
            .toList();
        return ListView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) {
            final page = pages[index];
            return ListTile(title: Text(page.title), selected: true);
          },
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}

Future getPages() async {
  String apiKey = Env.payloadApiKey;
  String authHeader = 'users API-Key $apiKey';
  String apiUrl = Env.payloadApiUrl;

  return await dio.get(
    '$apiUrl/pages',
    options: Options(headers: {'Authorization': authHeader}),
  );
}
