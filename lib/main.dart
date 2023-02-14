import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stripe_app/bloc/blocs.dart';
import 'package:stripe_app/pages/pages.dart';
import 'package:stripe_app/services/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Inicializamos StripeService
    StripeService().init();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PaymentBloc()),
      ],
      child: MaterialApp(
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
          ),
        ),
      ),
    );
  }
}
