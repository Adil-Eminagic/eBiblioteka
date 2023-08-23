import 'package:provider/provider.dart';

import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../pages/login_page.dart';
import '../providers/user_provider.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).changign_password,
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 80, 65, 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).mvalue;
                      }
                      {
                        return null;
                      }
                    }),
                    name: 'password',
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).password)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormBuilderTextField(
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).mvalue;
                      } else if (value.length < 8 ||
                          !value.contains(RegExp(r'[A-Z]')) ||
                          !value.contains(RegExp(r'[a-z]')) ||
                          !value.contains(RegExp(r'[0-9]'))) {
                        return AppLocalizations.of(context).reg_password;
                      } else {
                        return null;
                      }
                    }),
                    name: 'newPassword',
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).new_password)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormBuilderTextField(
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).mvalue;
                      } else if (value !=
                          _formKey.currentState?.value['newPassword']) {
                        return AppLocalizations.of(context).pass_no_matc;
                      } else {
                        return null;
                      }
                    }),
                    name: 'confirmPassword',
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context).pass_confirm)),
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
                              'password':
                                  _formKey.currentState?.value['password'],
                              'newPassword':
                                  _formKey.currentState?.value['newPassword'],
                              'confirmNewPassword': _formKey
                                  .currentState?.value['confirmPassword']
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .su_mod_password)));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                (route) => false);
                          }
                        } catch (e) {
                          alertBox(context, AppLocalizations.of(context).error,
                              e.toString());
                        }
                       
                      }),
                      child: Text(AppLocalizations.of(context).save))
                ]),
          ),
        ),
      ),
    );
  }
}
