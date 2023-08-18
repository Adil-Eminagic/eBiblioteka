import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:mobile_ebiblioteka/providers/user_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late UserProvider _userProvider = UserProvider();

  bool isPayed = false;
  String make = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    make = AppLocalizations.of(context).purchase;
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).payment),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        body: Center(
          child: isPayed == true
              ? Text(
                  AppLocalizations.of(context).su_payed,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                )
              : ElevatedButton.icon(
                  icon: const Icon(Icons.paypal),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0, 48, 135, 1)
                  ),
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => UsePaypal(
                                sandboxMode: true,
                                clientId: dotenv.env["CLIENT_ID"]!,
                                secretKey: dotenv.env["SECRET"]!,
                                returnURL: "https://samplesite.com/return",
                                cancelURL: "https://samplesite.com/cancel",
                                transactions: const [
                                  {
                                    "amount": {
                                      "total": '10.12',
                                      "currency": "USD",
                                      "details": {
                                        "subtotal": '10.12',
                                        "shipping": '0',
                                        "shipping_discount": 0
                                      }
                                    },
                                    "description":
                                        "The payment transaction description.",
                                    // "payment_options": {
                                    //   "allowed_payment_method":
                                    //       "INSTANT_FUNDING_SOURCE"
                                    // },
                                    "item_list": {
                                      "items": [
                                        {
                                          "name": "eLibary Membership",
                                          "quantity": 1,
                                          "price": '10.12',
                                          "currency": "USD"
                                        }
                                      ],
                                    }
                                  }
                                ],
                                note:
                                    "Contact us for any questions on your order.",
                                onSuccess: (Map params) async {
                                  _userProvider.payMembership(int.parse(
                                      Autentification.tokenDecoded!['Id']));
                                  setState(() {
                                    isPayed = true;
                                  });
                                  Autentification.token = null;
                                  Autentification.tokenDecoded = null;
                                  print("onSuccess: $params");
                                },
                                onError: (error) {
                                  print("onError: $error");
                                },
                                onCancel: (params) {
                                  print('cancelled: $params');
                                }),
                          ),
                        )
                      },
                  label: Text(
                    make,
                    style:const TextStyle(fontSize: 18),
                  )),
        ));
  }
}
