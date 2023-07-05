import 'package:admin_ebiblioteka/providers/country_provider.dart';
import 'package:admin_ebiblioteka/providers/gender_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

  SearchResult<Country>? countryResult;
  SearchResult<Gender>? genderResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _genderProvider = context.read<GenderProvider>();
    _countryProvider = context.read<CountryProvider>();

    intiForm();
  }

  Future<void> intiForm() async {
    countryResult = await _countryProvider.getPaged();
    genderResult = await _genderProvider.getPaged();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
           flex: 2,
          child:  Container(
            color: Colors.brown,
            child:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'eBiblioteka',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40
                  ),
                  ),
                  Text(
                    'Registracija',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28
                  ),
                  )
                ],
              ),
            ),
          ),
         
        ),
        isLoading == true
            ? Container()
            : Expanded(
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             IconButton(onPressed: (() {
                               Navigator.pop(context);
                             }), icon: Icon(Icons.arrow_back), 
                             color: Colors.brown,
                             )
                            ],
                          ),
                          SizedBox(height: 60,),
                          Row(
                            children: [
                              _textField('firstName', 'Ime'),
                              const SizedBox(
                                width: 20,
                              ),
                              _textField('lastName', 'Prezime'),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              _textField('email', 'Email'),
                              const SizedBox(
                                width: 20,
                              ),
                              _textField('phoneNumber', 'Telefon'),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              _textField('password', 'Lozinka'),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: FormBuilderDropdown<String>(
                                name: 'genderId',
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
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: g.id.toString(),
                                              child: Text(g.value ?? ''),
                                            ))
                                        .toList() ??
                                    [],
                              )),
                            const  SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: FormBuilderDropdown<String>(
                                name: 'countryId',
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
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: g.id.toString(),
                                              child: Text(g.name ?? ''),
                                            ))
                                        .toList() ??
                                    [],
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _formKey.currentState?.saveAndValidate();
                                    print(_formKey.currentState?.value);
                                  },
                                  child: const Text("Registruj se"))
                            ],
                          )
                        ],
                      ),
                    )),
              )
      ],
    ));
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          label: Text(label),
        ),
      ),
    );
  }
}
