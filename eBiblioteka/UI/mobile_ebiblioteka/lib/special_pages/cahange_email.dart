import '../providers/user_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../pages/login_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  late UserProvider _userProvider = UserProvider();
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'currentEmail': Autentification.tokenDecoded?['Email'],
    };
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: AppLocalizations.of(context).changing_email,
        child: SingleChildScrollView(
          
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
              child:Padding(
                    padding: const EdgeInsets.fromLTRB(65, 80, 65, 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            name: 'currentEmail',
                            readOnly: true,
                            decoration:  InputDecoration(
                                label: Text(AppLocalizations.of(context).cur_email)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).mvalue;
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return AppLocalizations.of(context).invalid_email;
                              } else {
                                return null;
                              }
                            }),
                            name: 'newEmail',
                            decoration:
                                InputDecoration(label: Text(AppLocalizations.of(context).new_email)),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          ElevatedButton(
                              onPressed: (() async {
                                _formKey.currentState?.save();
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    var res = await _userProvider.changeEmail(
                                        int.parse(Autentification
                                            .tokenDecoded?['Id']),
                                        _formKey
                                            .currentState?.value['newEmail']);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context).su_cha_email)));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                        (route) => false);
                                  }
                                } catch (e) {
                                  alertBox(context, AppLocalizations.of(context).error, e.toString());
                                }
                                // var res = _userProvider.changeEmail(
                                //     Autentification.tokenDecoded?['Id'],
                                //     Autentification.tokenDecoded?['Email']);
                                // print(res);
                              }),
                              child:  Text(AppLocalizations.of(context).save))
                        ]),
                  ),
              
            ),
         
        ));
  }
}
