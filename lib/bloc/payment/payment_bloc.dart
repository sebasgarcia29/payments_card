import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/models/credit_car.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentState()) {
    on<OnSelectedCard>((event, emit) {
      emit(state.copyWith(
        isCardEnable: true,
        card: event.card,
      ));
    });

    on<OnDeselectedCard>(
        (event, emit) => emit(state.copyWith(isCardEnable: false)));
  }
}
