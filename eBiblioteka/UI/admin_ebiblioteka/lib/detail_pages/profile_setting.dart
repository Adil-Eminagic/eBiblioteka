import 'dart:convert';
import 'dart:io';

import '../models/photo.dart';
import '../providers/photo_provider.dart';
import '../special_pages/cahange_email.dart';
import '../special_pages/change%20password.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/country.dart';
import '../models/search_result.dart';
import '../widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/gender.dart';
import '../models/role.dart';
import '../models/user.dart';
import '../providers/country_provider.dart';
import '../providers/gender_provider.dart';
import '../providers/role_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
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
    if (widget.user != null &&
        widget.user!.profilePhotoId != null &&
        widget.user!.profilePhotoId! > 0) {
      Photo p = await _photoProvider.getById(widget.user!.profilePhotoId!);
      photo = p.data;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: AppLocalizations.of(context).profile_settings,
      child: isLoading == true
          ? const Center(child: SpinKitRing(color: Colors.brown))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
                child: Column(
                  children: [
                    _buildForm(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.user == null
                              ? Container()
                              : ElevatedButton(
                                  onPressed: () async {
                                    _formKey.currentState?.save();

                                    try {
                                      if (_formKey.currentState!.validate()) {
                                        Map<String, dynamic> request = Map.of(
                                            _formKey.currentState!.value);

                                        request['id'] = widget.user?.id;
                                        request['roleId'] = widget.user?.roleId;
                                        request['birthDate'] = DateEncode(
                                            _formKey.currentState
                                                ?.value['birthDate']);

                                        request['isActive'] =
                                            widget.user!.isActive;

                                        // request['biography'] =
                                        //     widget.user?.biography;

                                        if (_base64Image != null) {
                                          request['profilePhoto'] =
                                              _base64Image;
                                        }

                                        var res =
                                            await _userProvider.update(request);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    AppLocalizations.of(context)
                                                        .su_mod_profie)));

                                        Navigator.pop(context,
                                            'getUser'); //to refresh data
                                        Navigator.pop(context);
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
                                    style: TextStyle(fontSize: 15),
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
              textField('phoneNumber', AppLocalizations.of(context).telphone)
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
                readOnly: true,
                decoration:
                    const InputDecoration(label: Text('Email (readonly)')),
              )),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const ChangeEmailPage())));
                      }),
                      child: Text(AppLocalizations.of(context).change_email)),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const ChangePasswordPage())));
                      }),
                      child:
                          Text(AppLocalizations.of(context).change_password)),
                ],
              ))
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
                    _formKey.currentState!.fields['genderId']?.reset();
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
                        name: AppLocalizations.of(context).password,
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
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).biography)),
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

      if (mounted) {
        setState(() {
          photo = _base64Image; //opet !
        });
      }
    }
  }
}
