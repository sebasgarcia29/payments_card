import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:stripe_app/bloc/blocs.dart';
import 'package:stripe_app/models/credit_car.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentBloc = BlocProvider.of<PaymentBloc>(context).state.card;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Card Page'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              final paymentBloc = BlocProvider.of<PaymentBloc>(context);
              paymentBloc.add(OnDeselectedCard());
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(),
            Hero(
              tag: paymentBloc.cardNumber,
              child: CreditCardWidget(
                cardNumber: paymentBloc.cardNumber,
                expiryDate: paymentBloc.expiracyDate,
                cardHolderName: paymentBloc.cardHolderName,
                cvvCode: paymentBloc.cvv,
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
