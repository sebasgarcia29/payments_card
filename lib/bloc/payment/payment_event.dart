part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class OnSelectedCard extends PaymentEvent {
  final CreditCardCustom card;

  OnSelectedCard(this.card);
}

class OnDeselectedCard extends PaymentEvent {}
