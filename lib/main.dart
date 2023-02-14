import 'package:flutter/material.dart';
import 'package:stripe_app/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home_page',
      routes: {
        'home_page': (context) => const HomePage(),
        'card_page': (context) => const CardPage(),
        'pay_completed': (context) => const PayCompletedPage(),
      },
      theme: ThemeData.light().copyWith(
          primaryColor: const Color(0xff284879),
          scaffoldBackgroundColor: const Color(0xff21232A),
          appBarTheme: const AppBarTheme(
            color: Color(0xff284879),
          )),
    );
  }
}
