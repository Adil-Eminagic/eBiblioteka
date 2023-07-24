import '../providers/country_provider.dart';
import '../providers/gender_provider.dart';
import '../providers/sign_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../models/gender.dart';
import '../models/search_result.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late GenderProvider _genderProvider = GenderProvider();
  late CountryProvider _countryProvider = CountryProvider();
  late SignProvider _signProvider = SignProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _initialValue = {};

  SearchResult<Country>? countryResult;
  SearchResult<Gender>? genderResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genderProvider = context.read<GenderProvider>();
    _countryProvider = context.read<CountryProvider>();
    _signProvider = context.read<SignProvider>();

    intiForm();
  }

  Future<void> intiForm() async {
    try {
      countryResult = await _countryProvider.getPaged();
      genderResult = await _genderProvider.getPaged();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      alertBoxMoveBack(context, 'Greška', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registracija'),
        centerTitle: true,
        ),
      body: isLoading
          ? const SpinKitRing(color: Colors.brown)
          : SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(65, 0, 65, 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      rowMethod(_textField('firstName', 'Ime')),
                      const SizedBox(
                        height: 15,
                      ),
                      rowMethod(_textField('lastName', 'Prezime')),
                      const SizedBox(
                        height: 15,
                      ),
                      rowMethod(
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'email',
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
                            decoration: const InputDecoration(
                              label: Text('Email'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      rowMethod(_textField('phoneNumber', 'Telefon')),
                      const SizedBox(
                        height: 15,
                      ),
                      rowMethod(
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'password',
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
                            decoration: const InputDecoration(
                              label: Text('Password'),
                            ),
                          ),
                        ),
                      ),
                       const SizedBox(
                        height: 15,
                      ),
                      rowMethod(
                        Expanded(
                            child: FormBuilderDateTimePicker(
                          name: 'birthDate',
                          validator: (value) {
                            if (value == null) {
                              return "Obavezno polje";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              label: Text("Datum rođenja")),
                        )),
                      ),
                       const SizedBox(
                        height: 15,
                      ),
                      rowMethod(
                        Expanded(
                            child: FormBuilderDropdown<String>(
                          name: 'genderId',
                          validator: (value) {
                            if (value == null) {
                              return "Splo je obavezan.";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Spol',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey
                                    .currentState!
                                    .fields[
                                        'genderId'] //brisnje selekcije iz forme
                                    ?.reset();
                              },
                            ),
                            hintText: 'Odaberi spol',
                          ),
                          items: genderResult?.items
                                  .map((g) => DropdownMenuItem(
                                        alignment: AlignmentDirectional.center,
                                        value: g.id.toString(),
                                        child: Text(g.value ?? ''),
                                      ))
                                  .toList() ??
                              [],
                        )),
                      ),
                       const SizedBox(
                        height: 15,
                      ),
                      rowMethod(Expanded(
                          child: FormBuilderDropdown<String>(
                        name: 'countryId',
                        validator: (value) {
                          if (value == null) {
                            return "Država je obavezna.";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Država',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey
                                  .currentState!
                                  .fields[
                                      'countryId'] //brisnje selekcije iz forme
                                  ?.reset();
                            },
                          ),
                          hintText: 'Odaberi državu',
                        ),
                        items: countryResult?.items
                                .map((g) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: g.id.toString(),
                                      child: Text(g.name ?? ''),
                                    ))
                                .toList() ??
                            [],
                      ))),
                      const SizedBox( height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  _formKey.currentState?.save();
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, dynamic> request =
                                        Map.of(_formKey.currentState!.value);

                                    request['birthDate'] = DateEncode(_formKey
                                        .currentState?.value['birthDate']);

                                    await _signProvider.signUp(request);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Uspješna registracija')));

                                    Navigator.pop(context);
                                  } else {}
                                } catch (e) {
                                  alertBox(context, 'Greška', e.toString());
                                }
                              },
                              child: const Text("Registruj se"))
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
            
    );
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "Morate unijeti vrijednost";
          } else {
            return null;
          }
        }),
        decoration: InputDecoration(
          label: Text(label),
        ),
      ),
    );
  }

}
