import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:stripe_app/bloc/payment/payment_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/services.dart';

class TotalPayButton extends StatelessWidget {
  const TotalPayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final payBloc = BlocProvider.of<PaymentBloc>(context).state;

    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                '${payBloc.amountPayable} ${payBloc.currency}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (BuildContext context, state) {
              return _BtnPay(paymentState: state);
            },
          ),
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final PaymentState paymentState;

  const _BtnPay({required this.paymentState});

  @override
  Widget build(BuildContext context) {
    return paymentState.isCardEnable
        ? buildBtnCard(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildBtnCard(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      onPressed: () async {
        showLoading(context);
        final state = BlocProvider.of<PaymentBloc>(context).state;
        final stripeService = StripeService();

        final card = state.card;
        final montYear = card.expiracyDate.split('/');

        final response = await stripeService.payWithCardExist(
            amount: state.mountPayString,
            currency: state.currency,
            card: CreditCard(
              number: card.cardNumber,
              expMonth: int.parse(montYear[0]),
              expYear: int.parse(montYear[1]),
            ));

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        if (response.ok) {
          // ignore: use_build_context_synchronously
          showAlert(context, 'New Card it is ok!!!', 'Everything is fine');
        } else {
          // ignore: use_build_context_synchronously
          showAlert(context, 'Payment failed',
              response.msg ?? 'Something went wrong');
        }
      },
      child: Row(
        children: const [
          Icon(FontAwesomeIcons.solidCreditCard, color: Colors.white),
          SizedBox(width: 10),
          Text('Pay', style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      onPressed: () async {
        final state = BlocProvider.of<PaymentBloc>(context).state;
        final stripeService = StripeService();

        final response = await stripeService.payApplePayGooglePay(
          amount: state.mountPayString,
          currency: state.currency,
        );
      },
      child: Row(
        children: [
          Icon(
              Platform.isAndroid
                  ? FontAwesomeIcons.google
                  : FontAwesomeIcons.apple,
              color: Colors.white),
          const SizedBox(width: 10),
          const Text('Pay',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
    );
  }
}
