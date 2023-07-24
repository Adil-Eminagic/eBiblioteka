import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/country.dart';
import '../models/gender.dart';
import '../models/photo.dart';
import '../models/role.dart';
import '../models/search_result.dart';
import '../providers/photo_provider.dart';
import '../special_pages/cahange_email.dart';
import '../special_pages/change password.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';
import '../widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/country_provider.dart';
import '../providers/gender_provider.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GenderProvider _genderProvider = GenderProvider();
  late CountryProvider _countryProvider = CountryProvider();
  late RoleProvider _roleProvider = RoleProvider();
  late UserProvider _userProvider = UserProvider();
  late PhotoProvider _photoProvider = PhotoProvider();

  SearchResult<Country>? countryResult;
  SearchResult<Gender>? genderResult;
  SearchResult<Role>? roleResult;
  String? photo;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'firstName': widget.user?.firstName,
      'lastName': widget.user?.lastName,
      'biography': widget.user?.biography,
      'phoneNumber': widget.user?.phoneNumber,
      'email': widget.user?.email,
      'birthDate': widget.user?.birthDate,
      'lastTimeSignIn': widget.user?.lastTimeSignIn,
      'genderId': widget.user?.genderId.toString(),
      'countryId': widget.user?.countryId.toString(),
      'roleId': widget.user?.roleId.toString(),
    };

    _genderProvider = context.read<GenderProvider>();
    _countryProvider = context.read<CountryProvider>();
    _roleProvider = context.read<RoleProvider>();
    _userProvider = context.read<UserProvider>();
    _photoProvider = context.read<PhotoProvider>();
    initForm();
  }

  Future<void> initForm() async {
    countryResult = await _countryProvider.getPaged();
    genderResult = await _genderProvider.getPaged();
    roleResult = await _roleProvider.getPaged();
    if (widget.user != null &&  widget.user!.profilePhotoId != null &&  widget.user!.profilePhotoId! > 0) {
      Photo p = await _photoProvider.getById(widget.user!.profilePhotoId!);
      photo = p.data;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Postavke profila',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 0, 65, 50),
          child: Column(
            children: [
              isLoading ? const SpinKitRing(color: Colors.brown) : _buildForm(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (widget.user == null || isLoading)
                        ? Container()
                        : ElevatedButton(
                            onPressed: () async {
                              // _formKey.currentState
                              // ?.saveAndValidate(); //moramo spasiti vrijednosti forme kako bi se pohranile u currentstate
                              _formKey.currentState?.save();
                              print(_formKey.currentState?.value);

                              try {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['id'] = widget.user?.id;
                                  request['roleId'] = widget.user?.roleId;
                                  request['birthDate'] = DateEncode(_formKey
                                      .currentState?.value['birthDate']);

                                  if (_base64Image != null) {
                                    request['profilePhoto'] = _base64Image;
                                  }

                                  var res = await _userProvider.update(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješna modifikacija profila')));

                                  // Autentification.loggedUser =
                                  //     await _userProvider.getById(widget.user!.id!);

                                  Navigator.pop(context, 'getUser');
                                }
                              } on Exception catch (e) {
                                alertBox(context, 'Greška', e.toString());
                              }
                            },
                            child: const Text(
                              "Sačuvaj",
                              style: TextStyle(fontSize: 17),
                            )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Column(
                    children: [
                      (photo == null)
                          ? Container()
                          : InkWell(
                              onTap: getimage,
                              child: Container(
                                  constraints: const BoxConstraints(
                                      maxHeight: 350, maxWidth: 350),
                                  child: imageFromBase64String(photo!)),
                            ),
                      photo == null
                          ? ElevatedButton(
                              onPressed: getimage,
                              child: const Text('Odaberi sliku'))
                          : Container()
                    ],
                  ),
                )),
              )
            ],
          ),
          rowMethod(
            textField('firstName', 'Ime'),
          ),
          const SizedBox(
            height: 15,
          ),
          rowMethod(textField('lastName', 'Prezime')),
          const SizedBox(
            height: 15,
          ),
          rowMethod(Expanded(
              child: FormBuilderDateTimePicker(
            name: 'birthDate',
            validator: (value) {
              if (value == null) {
                return "Obavezno polje";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(label: Text("Datum rođenja")),
          ))),
          const SizedBox(
            height: 15,
          ),
          rowMethod(textField('phoneNumber', 'Telefon')),
          const SizedBox(
            height: 15,
          ),
          rowMethod(Expanded(
              child: FormBuilderTextField(
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
            name: 'email',
            readOnly: true,
            decoration: const InputDecoration(label: Text('Email (readonly)')),
          ))),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const ChangeEmailPage())));
                    }),
                    child: const Text(
                      'Novi email',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const ChangePasswordPage())));
                      }),
                      child: const Text('Nova lozinka',
                          style: TextStyle(fontSize: 17))),
                ],
              ))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          rowMethod(Expanded(
              child: FormBuilderDropdown<String>(
            name: 'genderId',
            validator: (value) {
              if (value == null) {
                return "Obavezno polje";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Spol',
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState!
                      .fields['genderId'] //brisnje selekcije iz forme
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
          ))),
          const SizedBox(
            height: 15,
          ),
          rowMethod(Expanded(
              child: FormBuilderDropdown<String>(
            name: 'countryId',
            validator: (value) {
              if (value == null) {
                return "Obavezno polje";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Država',
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState!
                      .fields['countryId'] //brisnje selekcije iz forme
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
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.user == null
                  ? Expanded(
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
                    )
                  : Container(),
              widget.user == null
                  ? const SizedBox(
                      width: 80,
                    )
                  : Container(),
              Expanded(
                  child: FormBuilderTextField(
                name: 'biography',
                maxLines: 5,
                decoration: const InputDecoration(label: Text('Biografija')),
              )),
            ],
          ),
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    );
  }

  

  Expanded textField(String name, String label) {
    return Expanded(
        child: FormBuilderTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Obavezno polje";
        } else {
          return null;
        }
      },
      name: name,
      decoration: InputDecoration(label: Text(label)),
    ));
  }

  File? _image; //dart.io
  String? _base64Image;

  Future getimage() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.image); //sam prepoznaj platformu u kjoj radi
    if (result != null && result.files.single.path != null) {
      _image = File(
          result.files.single.path!); //jer smo sa if provjerili pa je sigurn !
      _base64Image = base64Encode(_image!.readAsBytesSync());

      setState(() {
        photo = _base64Image; //opet !
      });
    }
  }
}
