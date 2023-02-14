import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:stripe_app/models/credit_car.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final card = CreditCardCustom(
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvv: '213',
      expiracyDate: '01/25',
      cardHolderName: 'Sebastian Garcia',
    );

    return Scaffold(
        appBar: AppBar(title: const Text('Card Page')),
        body: Stack(
          children: [
            Container(),
            Hero(
              tag: card.cardNumber,
              child: CreditCardWidget(
                cardNumber: card.cardNumber,
                expiryDate: card.expiracyDate,
                cardHolderName: card.cardHolderName,
                cvvCode: card.cvv,
                showBackView: false,
                onCreditCardWidgetChange: (card) {},
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
