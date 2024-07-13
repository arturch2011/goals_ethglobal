import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';
import 'package:http/http.dart' as http;

abstract class PaymentManager {
  static Future<void> makePayment(
      int amount, String currency, String address, BuildContext context) async {
    try {
      String clientSecret =
          await _getClientSecret((amount * 100).toString(), currency, address);
      print(clientSecret);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      hideLoadingDialog(context);
      showCheckDialog(context, 'Pagamento efetuado com sucesso');
    } catch (error) {
      print(error.toString());
      hideLoadingDialog(context);
      showErrorDialog(context, error.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    var gpay = const PaymentSheetGooglePay(
      merchantCountryCode: "BR",
      currencyCode: "brl",
      testEnv: true,
    );

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
        customFlow: false,
        googlePay: gpay,
      ),
    );
    print("Payment sheet initialized");
  }

  static Future<String> _getClientSecret(
      String amount, String currency, String address) async {
    String apiKey = dotenv.env['STRIPE_SECRET_LIVE_KEY']!;
    Dio dio = Dio();
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
        'metadata[address]': address,
      },
    );
    print(response.data);

    // Stripe.instance.createPaymentMethod(params:)
    return response.data["client_secret"];
  }

  static Future<void> makeWithdrawal(BigInt amount, String address,
      String email, DateTime date, String chavePix) async {
    print("Making withdrawal");
    try {
      // final container = ProviderContainer();
      // final ethUtils = container.read(ethUtilsProviders.notifier);
      // final envGoalsAddress = dotenv.env['GOALS_ADDRESS']!;

      var url = Uri.parse(
          'https://us-central1-goals-e4200.cloudfunctions.net/createPaybackIntent');

      // EthereumAddress goalsAddress = EthereumAddress.fromHex(envGoalsAddress);

      // await ethUtils.transfer(goalsAddress, amount);

      var config = {
        'amount': amount.toString(),
        'address': address,
        'email': email,
        'date': date.toIso8601String(),
        'chavePix': chavePix
      };
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      var response = await http.post(url, headers: headers, body: config);
      print(response);
    } catch (error) {
      print(error.toString());
    }
  }
}
