import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:markit_list/database/database.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:markit_list/screens/home.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3), () async {
          context
              .read<ListeProvider>()
              .setListe(await MyDatabase.instance.getListe());
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }),
        builder: (context, snapshot) {
          return const Center(
              child: SpinKitFadingFour(
            color: Colors.white,
          ));
        },
      ),
    );
  }
}
