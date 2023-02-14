part of 'payment_bloc.dart';

@immutable
class PaymentState {
  final double amountPayable;
  final String currency; // CAD, USD, EUR, COP
  final bool isCardEnable;
  final CreditCardCustom card;

  String get mountPayString => '${(amountPayable * 100).floor()}';

  PaymentState({
    this.amountPayable = 375.55,
    this.currency = 'USD',
    this.isCardEnable = false,
    card,
  }) : card = card ??
            CreditCardCustom(
              brand: '',
              cardHolderName: '',
              cardNumber: '',
              cvv: '',
              cardNumberHidden: '',
              expiracyDate: '',
            );

  PaymentState copyWith({
    double? amountPayable,
    String? currency,
    bool? isCardEnable,
    CreditCardCustom? card,
  }) =>
      PaymentState(
        amountPayable: amountPayable ?? this.amountPayable,
        currency: currency ?? this.currency,
        isCardEnable: isCardEnable ?? this.isCardEnable,
        card: card ?? this.card,
      );
}
