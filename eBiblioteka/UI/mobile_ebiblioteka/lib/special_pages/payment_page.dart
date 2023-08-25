import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:mobile_ebiblioteka/providers/user_provider.dart';
import 'package:mobile_ebiblioteka/utils/util.dart';
import 'package:mobile_ebiblioteka/utils/util_widgets.dart';
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
                      primary: const Color.fromRGBO(0, 48, 135, 1)),
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => UsePaypal(
                                sandboxMode: true,
                                clientId: 'AZkL37Viqql10TlDRH-phzZyRO-5CzaQ_tX4gidYXEbRF-sJS2S0nZ60q-CtSPG3sgR4d7mYKyV99Oh4',
                                secretKey: 'EIDWu9u9z122pgdaN9JOsLelVZsdZb5k0knNWHVh_xt_6EFJRpuL6CnmFibS51s3-QcZ1PiEqaBkAqSW',
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
                                  if (mounted) {
                                    setState(() {
                                      isPayed = true;
                                    });
                                  }
                                  Autentification.token = null;
                                  Autentification.tokenDecoded = null;
                                },
                                onError: (error) {
                                  alertBox(
                                      context,
                                      AppLocalizations.of(context).error,
                                      AppLocalizations.of(context).error_pay);
                                },
                                onCancel: (params) {
                                  alertBox(
                                      context,
                                      AppLocalizations.of(context).error,
                                      AppLocalizations.of(context)
                                          .cancel_payment);
                                }),
                          ),
                        )
                      },
                  label: Text(
                    make,
                    style: const TextStyle(fontSize: 18),
                  )),
        ));
  }
}
