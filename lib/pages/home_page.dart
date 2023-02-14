import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:stripe_app/data/data_cards.dart';
import 'package:stripe_app/pages/pages.dart';
import 'package:stripe_app/widgets/widgets.dart';
import 'package:stripe_app/helpers/helpers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                // showAlert(context, 'New card', 'Add a new card');
                // await Future.delayed(const Duration(seconds: 2));
                // Navigator.pop(context);
                showAlert(context, 'New card', 'Add a new card');
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
