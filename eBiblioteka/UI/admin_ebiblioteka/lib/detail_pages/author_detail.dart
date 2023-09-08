import 'dart:convert';
import 'dart:io';

import 'package:admin_ebiblioteka/models/author.dart';
import 'package:admin_ebiblioteka/models/country.dart';
import 'package:admin_ebiblioteka/models/gender.dart';
import 'package:admin_ebiblioteka/models/search_result.dart';
import 'package:admin_ebiblioteka/providers/author_provider.dart';
import 'package:admin_ebiblioteka/providers/country_provider.dart';
import 'package:admin_ebiblioteka/providers/gender_provider.dart';
import 'package:admin_ebiblioteka/utils/util.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/util_widgets.dart';

class AuthorDetailPage extends StatefulWidget {
  const AuthorDetailPage({super.key, this.author});
  final Author? author;
  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GenderProvider _genderProvider;
  late CountryProvider _countryProvider;
  late AuthorProvider _authorProvider;

  SearchResult<Country>? countryResult;
  SearchResult<Gender>? genderResult;
  String? photo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'id': widget.author?.id.toString(),
      'fullName': widget.author?.fullName,
      'biography': widget.author?.biography,
      'birthYear': widget.author?.birthYear.toString(),
      'mortalYear': widget.author?.mortalYear !=null ?  widget.author?.mortalYear.toString() : '',
      'genderId': widget.author?.genderId.toString(),
      'countryId': widget.author?.countryId.toString()
    };

    _genderProvider = context.read<GenderProvider>();
    _countryProvider = context.read<CountryProvider>();
    _authorProvider = context.read<AuthorProvider>();

    if (widget.author != null && widget.author?.photoId != null) {
      photo = widget.author?.photo?.data ?? '';
    }
    initForm();
  }

  Future<void> initForm() async {
    countryResult = await _countryProvider.getPaged();
    genderResult = await _genderProvider.getPaged();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.author != null
            ? "${AppLocalizations.of(context).author_id} ${(widget.author?.id.toString() ?? '')}"
            : AppLocalizations.of(context).new_author,
        child: isLoading == true
            ? const Center(child: SpinKitRing(color: Colors.brown))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(65, 40, 65, 100),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildForm(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    widget.author == null
                                        ? Container()
                                        : TextButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .del_author_title),
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .del_author_mes),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: (() {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .cancel)),
                                                          TextButton(
                                                              onPressed: () async {
                                                                try {
                                                                  await _authorProvider
                                                                      .remove(widget
                                                                              .author
                                                                              ?.id ??
                                                                          0);
                                                                  ScaffoldMessenger
                                                                          .of(
                                                                              context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                              content:
                                                                                  Text(AppLocalizations.of(context).su_del_author)));
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context,
                                                                      'reload');
                                                                } catch (e) {
                                                                  alertBoxMoveBack(
                                                                      context,
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .error,
                                                                      e.toString());
                                                                }
                                                              },
                                                              child:
                                                                  const Text('Ok')),
                                                        ],
                                                      ));
                                            },
                                            child: Text(AppLocalizations.of(context)
                                                .author_del_lbl)),
                                    widget.author == null
                                        ? Container()
                                        : const SizedBox(
                                            width: 7,
                                          ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          _formKey.currentState?.save();
                  
                                          try {
                                            if (_formKey.currentState!.validate()) {
                                              if (widget.author != null) {
                                                Map<String, dynamic> request =
                                                    Map.of(_formKey
                                                        .currentState!.value);
                  
                                                request['id'] = widget.author?.id;
                                                
                                                if (_base64Image != null) {
                                                  request['image'] = _base64Image;
                                                }
                  
                                                var birthYear = int.parse(_formKey
                                                    .currentState!
                                                    .value['birthYear']);
                  
                                                request['birthYear'] = birthYear;
                  
                                                var mortalYear = ( _formKey.currentState!.value['mortalYear']==null ||
                                                _formKey.currentState!.value['mortalYear']=='')
                                                 ? null: int.parse(_formKey
                                                    .currentState!
                                                    .value['mortalYear']) ;
                  
                                                request['mortalYear'] = mortalYear;
                  
                                                var res = await _authorProvider
                                                    .update(request);
                  
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .su_mod_author)));
                  
                                                Navigator.pop(context, 'reload');
                                              } else {
                                                Map<String, dynamic> request =
                                                    Map.of(_formKey
                                                        .currentState!.value);
                  
                                                var birthYear = int.parse(_formKey
                                                    .currentState!
                                                    .value['birthYear']);
                  
                                                request['birthYear'] = birthYear;
                  
                                               var mortalYear = ( _formKey.currentState!.value['mortalYear']==null ||
                                                _formKey.currentState!.value['mortalYear']=='')
                                                 ? null: int.parse(_formKey
                                                    .currentState!
                                                    .value['mortalYear']) ;
                                                    
                                                request['mortalYear'] = mortalYear;
                  
                                                if (_base64Image != null) {
                                                  request['image'] = _base64Image;
                                                }
                                                await _authorProvider
                                                    .insert(request);
                  
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .su_add_author)));
                  
                                                Navigator.pop(context, 'reload');
                                              }
                                            }
                                          } on Exception catch (e) {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .error),
                                                      content: Text(
                                                        e.toString(),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text('Ok'))
                                                      ],
                                                    ));
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(context).save,
                                          style: const TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
                              height: 20,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'fullName',
                validator: (value) {
                  if (value == null || value == '') {
                    return AppLocalizations.of(context).mfield;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).name)),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: 'biography',
                  maxLines: 3,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context).biography)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'birthYear',
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context).mfield;
                  } else if (int.tryParse(value) == null) {
                    return AppLocalizations.of(context).numeric_field;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).birth_year)),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: FormBuilderTextField(
                name: 'mortalYear',
                validator: (value) {
                  if (value!=null && value.isEmpty==false && int.tryParse(value) == null) {
                    return AppLocalizations.of(context).numeric_field;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).mortal_year)),
              )),
            ],
          ),
          const SizedBox(
            height: 30,
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
              width: 20,
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
            height: 50,
          ),
        ],
      ),
    );
  }

  File? _image; //dart.io
  String? _base64Image;

  Future getimage() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.image); //sam prepoznaj platformu u kjoj radi
    if (result != null && result.files.single.path != null) {
      _image = File(
          result.files.single.path!); //jer smo sa if provjerili pa je sigurn !
      _base64Image = base64Encode(_image!.readAsBytesSync()); //opet !

      if (mounted) {
        setState(() {
          photo = _base64Image;
        });
      }
    }
  }
}
