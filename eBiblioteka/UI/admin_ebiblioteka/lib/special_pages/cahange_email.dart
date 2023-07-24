import '../providers/user_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../pages/login_page.dart';

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
        title: 'Promjena email-a',
        child: SingleChildScrollView(
          child: Center(
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
              child: Container(
                //constraints: const BoxConstraints(maxHeight: 600, maxWidth: 700),
                width: 700,
                height: 600,
                margin: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 30),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(120, 80, 120, 50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            name: 'currentEmail',
                            readOnly: true,
                            decoration: const InputDecoration(
                                label: Text('Trenutni email')),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          FormBuilderTextField(
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return "Morate unijeti vrijednost";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "Nevalidan email";
                              } else {
                                return null;
                              }
                            }),
                            name: 'newEmail',
                            decoration:
                                InputDecoration(label: Text('Novi email')),
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
                                        const SnackBar(
                                            content: Text(
                                                'Uspješna promjena emaila')));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                        (route) => false);
                                  }
                                } catch (e) {
                                  alertBox(context, 'Greška', e.toString());
                                }
                                // var res = _userProvider.changeEmail(
                                //     Autentification.tokenDecoded?['Id'],
                                //     Autentification.tokenDecoded?['Email']);
                                // print(res);
                              }),
                              child: const Text('Promijeni'))
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
