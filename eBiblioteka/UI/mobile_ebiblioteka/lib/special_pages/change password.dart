import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../pages/login_page.dart';
import '../providers/user_provider.dart';
import '../utils/util_widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late UserProvider _userProvider = UserProvider();
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Promjena lozinke',
      child: SingleChildScrollView(
        child:  FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child:  Padding(
                  padding: const EdgeInsets.fromLTRB(65, 80, 65, 50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormBuilderTextField(
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Morate unijeti vrijednost";
                            } else if (value.length < 8 ||
                                !value.contains(RegExp(r'[A-Z]')) ||
                                !value.contains(RegExp(r'[a-z]')) ||
                                !value.contains(RegExp(r'[0-9]'))) {
                              return "Lozinka mora sadržati najmanje 8 karatera, velika i mala slova";
                            } else {
                              return null;
                            }
                          }),
                          name: 'password',
                          decoration: InputDecoration(label: Text('Lozinka')),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormBuilderTextField(
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Morate unijeti vrijednost";
                            } else if (value.length < 8 ||
                                !value.contains(RegExp(r'[A-Z]')) ||
                                !value.contains(RegExp(r'[a-z]')) ||
                                !value.contains(RegExp(r'[0-9]'))) {
                              return "Lozinka mora sadržati najmanje 8 karatera, velika i mala slova";
                            } else {
                              return null;
                            }
                          }),
                          name: 'newPassword',
                          decoration:
                              InputDecoration(label: Text('Nova lozinka')),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormBuilderTextField(
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Morate unijeti vrijednost";
                            } else if (value !=
                                _formKey.currentState?.value['newPassword']) {
                              return "Nova lozinka i potvrda lozinke se ne podudaraju.";
                            } else {
                              return null;
                            }
                          }),
                          name: 'confirmPassword',
                          decoration: const InputDecoration(
                              label: Text('Potvrda nove lozinke')),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        ElevatedButton(
                            onPressed: (() async {
                              _formKey.currentState?.save();
                              try {
                                if (_formKey.currentState!.validate()) {
                                  var res = await _userProvider.changePassword({
                                    'id': Autentification.tokenDecoded?['Id'],
                                    'password': _formKey.currentState?.value['password'],
                                    'newPassword':_formKey.currentState?.value['newPassword'],
                                    'confirmNewPassword': _formKey.currentState?.value['confirmPassword']
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješna promjena lozinke')));
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
    );
  }
}
