import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:stripe_app/bloc/blocs.dart';
import 'package:stripe_app/data/data_cards.dart';
import 'package:stripe_app/pages/pages.dart';
import 'package:stripe_app/services/services.dart';
import 'package:stripe_app/widgets/widgets.dart';
import 'package:stripe_app/helpers/helpers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stripeService = StripeService();
    final size = MediaQuery.of(context).size;
    final paymentBloc = BlocProvider.of<PaymentBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                showLoading(context);
                final amount = paymentBloc.state.mountPayString;
                final currency = paymentBloc.state.currency;
                final response = await stripeService.payWithNewCard(
                    amount: amount, currency: currency);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                if (response.ok) {
                  // ignore: use_build_context_synchronously
                  showAlert(context, 'Card ok!!!', 'Everything is fine');
                } else {
                  // ignore: use_build_context_synchronously
                  showAlert(context, 'Payment failed',
                      response.msg ?? 'Something went wrong');
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: size.height / 4,
              child: PageView.builder(
                controller:
                    PageController(viewportFraction: 0.9, initialPage: 0),
                physics: const BouncingScrollPhysics(),
                itemCount: cardsTest.length,
                itemBuilder: (_, i) {
                  final card = cardsTest[i];
                  return GestureDetector(
                    onTap: () {
                      final paymentBloc = BlocProvider.of<PaymentBloc>(context);
                      paymentBloc.add(OnSelectedCard(card));
                      Navigator.push(
                          context, navigationFadeIn(context, const CardPage()));
                    },
                    child: Hero(
                      tag: card.cardNumber,
                      child: CreditCardWidget(
                        cardNumber: card.cardNumberHidden,
                        expiryDate: card.expiracyDate,
                        cardHolderName: card.cardHolderName,
                        cvvCode: card.cvv,
                        showBackView: false,
                        onCreditCardWidgetChange: (card) {},
                      ),
                    ),
                  );
                },
              ),
            ),
            const Positioned(
              bottom: 0,
              child: TotalPayButton(),
            )
          ],
        ));
  }
}
