import 'dart:convert';
import 'dart:io';

import 'package:admin_ebiblioteka/models/role.dart';
import 'package:admin_ebiblioteka/providers/role_provider.dart';
import 'package:admin_ebiblioteka/providers/user_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../models/gender.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/country_provider.dart';
import '../providers/gender_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key, this.user, this.roleUser}) : super(key: key);
  final User? user;
  final String? roleUser;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GenderProvider _genderProvider = GenderProvider();
  late CountryProvider _countryProvider = CountryProvider();
  late RoleProvider _roleProvider = RoleProvider();
  late UserProvider _userProvider = UserProvider();

  SearchResult<Country>? countryResult;
  SearchResult<Gender>? genderResult;
  SearchResult<Role>? roleResult;
  String? photo;
  bool isLoading = true;
  bool? isActive;

  @override
  void initState() {
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

    if (widget.user != null) {
      isActive = widget.user!.isActive!;
    }
    if (widget.user != null && widget.user?.profilePhoto != null) {
      photo = widget.user?.profilePhoto?.data ?? '';
    }

    initForm();
  }

  Future<void> initForm() async {
    try {
      countryResult = await _countryProvider.getPaged();
      genderResult = await _genderProvider.getPaged();
      roleResult = await _roleProvider.getPaged();

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      alertBox(context, AppLocalizations.of(context).error, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.user != null
            ? "${widget.user!.roleId == 3 ? AppLocalizations.of(context).user : AppLocalizations.of(context).admin} id: ${(widget.user?.id.toString() ?? '')}"
            : "${AppLocalizations.of(context).new_lbl} ${widget.roleUser == "User" ? AppLocalizations.of(context).user_lower : AppLocalizations.of(context).admin_lower}",
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
            child: Column(
              children: [
                isLoading
                    ? const SpinKitRing(color: Colors.brown)
                    : _buildForm(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // widget.user == null
                      //     ? Container()
                      //     : TextButton(
                      //         onPressed: () async {
                      //           showDialog(
                      //               context: context,
                      //               builder: (BuildContext context) =>
                      //                   AlertDialog(
                      //                     title:
                      //                         const Text('Brisanje korisnika'),
                      //                     content: const Text(
                      //                         'Da li želite obrisati korisnika'),
                      //                     actions: [
                      //                       TextButton(
                      //                           onPressed: (() {
                      //                             Navigator.pop(context);
                      //                           }),
                      //                           child: const Text('Poništi')),
                      //                       TextButton(
                      //                           onPressed: () async {
                      //                             try {
                      //                               await _userProvider.remove(
                      //                                   widget.user?.id ?? 0);
                      //                               ScaffoldMessenger.of(
                      //                                       context)
                      //                                   .showSnackBar(
                      //                                       const SnackBar(
                      //                                           content: Text(
                      //                                               'Uspješno brisanje korisnika')));
                      //                               Navigator.pop(context);
                      //                               Navigator.pop(
                      //                                   context, 'reload');
                      //                             } catch (e) {
                      //                               alertBoxMoveBack(context,
                      //                                   'Greška', e.toString());
                      //                             }
                      //                           },
                      //                           child: const Text('Ok')),
                      //                     ],
                      //                   ));
                      //         },
                      //         child: const Text('Obriši korisnika')),
                      widget.user == null
                          ? Container()
                          : const SizedBox(
                              width: 7,
                            ),
                      ElevatedButton(
                          onPressed: () async {
                            // _formKey.currentState
                            // ?.saveAndValidate(); //moramo spasiti vrijednosti forme kako bi se pohranile u currentstate
                            _formKey.currentState?.save();
                            print(_formKey.currentState?.value);

                            try {
                              if (_formKey.currentState!.validate()) {
                                if (widget.user != null) {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['id'] = widget.user?.id;
                                  request['birthDate'] = DateEncode(_formKey
                                      .currentState?.value['birthDate']);
                                  // request['lastTimeSignIn'] = DateEncode(
                                  //     _formKey.currentState
                                  //         ?.value['lastTimeSignIn']);
                                  if (_base64Image != null) {
                                    request['profilePhoto'] = _base64Image;
                                  }

                                  request['isActive'] = isActive;
                                  var res = await _userProvider.update(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .user_mod_su)));

                                  Navigator.pop(context, 'reload');
                                } else {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['birthDate'] = DateEncode(_formKey
                                      .currentState?.value['birthDate']);
                                  // request['lastTimeSignIn'] = DateEncode(
                                  //     _formKey.currentState
                                  //         ?.value['lastTimeSignIn']);// ovo ne radi, samo polja koja se koriste u fieldovima
                                  if (request['passsword'] == '') {
                                    request['passsword'] = null;
                                  }
                                  if (_base64Image != null) {
                                    request['profilePhoto'] = _base64Image;
                                  }
                                  request['isActive'] = true;

                                  await _userProvider.insert(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .user_add_su)));

                                  Navigator.pop(context, 'reload');
                                }
                              }
                            } on Exception catch (e) {
                              alertBox(
                                  context,
                                  AppLocalizations.of(context).error,
                                  e.toString());
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).save,
                            style: const TextStyle(fontSize: 15),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          widget.user == null
              ? Container()
              : Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).activity,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Switch(
                      // This bool value toggles the switch.
                      value: isActive!,
                      activeColor: Colors.brown,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          isActive = value;
                        });
                      },
                    )
                  ],
                ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                  child: Column(
                    children: [
                      (photo == null)
                          ? Container()
                          : Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 350, maxWidth: 350),
                              child: imageFromBase64String(photo!)),
                      photo == null
                          ? Container()
                          : const SizedBox(
                              height: 28,
                            ),
                      ElevatedButton(
                          onPressed: getimage,
                          child: photo == null
                              ? Text(AppLocalizations.of(context).choose_image)
                              : Text(
                                  AppLocalizations.of(context).change_image)),
                    ],
                  ),
                )),
              )
            ],
          ),
          Row(
            children: [
              textField('firstName', AppLocalizations.of(context).name),
              const SizedBox(
                width: 80,
              ),
              textField('lastName', AppLocalizations.of(context).lname),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: FormBuilderDateTimePicker(
                name: 'birthDate',
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).birth_date)),
              )),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: FormBuilderDropdown<String>(
                name: 'roleId',
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).role,
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!
                          .fields['roleId'] //brisnje selekcije iz forme
                          ?.reset();
                    },
                  ),
                ),
                items: roleResult?.items
                        .map((g) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: g.id.toString(),
                              child: Text(g.value ?? ''),
                            ))
                        .toList() ??
                    [],
              )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderTextField(
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
                name: 'email',
                decoration: const InputDecoration(label: Text('Email')),
              )),
              const SizedBox(
                width: 80,
              ),
              textField('phoneNumber', AppLocalizations.of(context).telphone)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(children: [
            Expanded(
                child: FormBuilderDropdown<String>(
              name: 'genderId',
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).mfield;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).gender,
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState!
                        .fields['genderId'] //brisnje selekcije iz forme
                        ?.reset();
                  },
                ),
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
            const SizedBox(
              width: 80,
            ),
            Expanded(
                child: FormBuilderDropdown<String>(
              name: 'countryId',
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).mfield;
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).country,
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState!
                        .fields['countryId'] //brisnje selekcije iz forme
                        ?.reset();
                  },
                ),
              ),
              items: countryResult?.items
                      .map((g) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: g.id.toString(),
                            child: Text(g.name ?? ''),
                          ))
                      .toList() ??
                  [],
            )),
          ]),
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
                        decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context).password),
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
                maxLines: 3,
                decoration: InputDecoration(label: Text(AppLocalizations.of(context).biography)),
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
          return AppLocalizations.of(context).mfield;
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
