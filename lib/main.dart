import 'package:flutter/material.dart';
import 'package:markit_list/provider/article_provider.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:markit_list/screens/loading.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ListeProvider()),
      ChangeNotifierProvider(create: (_) => ArticleProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Product Sans'),
      home: const LoadingPage(),
    );
  }
}
