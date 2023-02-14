import 'package:dio/dio.dart';
import 'package:stripe_app/models/models.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  //Singleton
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static const String _secretKey =
      'sk_test_51MbRyXJuh7HlvU1PYeQUpIn0tGJ88oZ6r2WjhclPkwymhkQ8RioSYP7f7M2OeUBR9DG7GFbetWSD7Xrt4LGIiumX00t3gYR6BU';
  final String _apiKey =
      'pk_test_51MbRyXJuh7HlvU1PEkHfG6CGjZ6XxIE2WDyMB7gB5RDhWGQ425B3QTM3APs6adLQteAsX84SFImpCLVW8DdbKk0y00RCLcRZhE';

  final headerOptions = Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization': 'Bearer ${StripeService._secretKey}',
    },
  );

  void init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: _apiKey,
      androidPayMode: 'test',
      merchantId: 'test',
    ));
  }

  Future<StripeCustomResponse> payWithCardExist({
    required String amount,
    required String currency,
    required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card),
      );
      final responsePayment = await _makePaymentIntent(
        amount: amount,
        currency: currency,
        paymenMethod: paymentMethod,
      );

      return responsePayment;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> payWithNewCard({
    required String amount,
    required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      final responsePayment = await _makePaymentIntent(
        amount: amount,
        currency: currency,
        paymenMethod: paymentMethod,
      );

      return responsePayment;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> payApplePayGooglePay({
    required String amount,
    required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
            totalPrice: amount,
            currencyCode: currency,
          ),
          applePayOptions: ApplePayPaymentOptions(
            currencyCode: currency,
            countryCode: 'US',
            items: [
              ApplePayItem(
                label: 'Super product 1',
                amount: '$newAmount',
              ),
            ],
          ));

      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(
            token: token.tokenId,
          ),
        ),
      );
      final responsePayment = await _makePaymentIntent(
        amount: amount,
        currency: currency,
        paymenMethod: paymentMethod,
      );

      await StripePayment.completeNativePayRequest();

      return responsePayment;
    } catch (e) {
      print('Error when trying payApplePayGooglePay: ${e.toString()}');
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<PaymentIntentResponse> _createPaymetIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      final dio = Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };
      final response = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions,
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      print('Error when trying to create payment intent: ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _makePaymentIntent({
    required String amount,
    required String currency,
    required PaymentMethod paymenMethod,
  }) async {
    try {
      final paymentIntent =
          await _createPaymetIntent(amount: amount, currency: currency);

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymenMethod.id,
        ),
      );

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(ok: false, msg: 'Payment failed!');
      }
    } catch (e) {
      print('_makePaymentIntent>>> ${e.toString()}');
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }
}
