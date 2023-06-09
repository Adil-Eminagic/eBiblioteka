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
import 'package:provider/provider.dart';

class AuthorDetailPage extends StatefulWidget {
 const  AuthorDetailPage({super.key, this.author});
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
      'birthDate': widget.author?.birthDate,
      'mortalDate': widget.author?.mortalDate,
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.author != null
            ? "Autor Id: ${(widget.author?.id.toString() ?? '')}"
            : "Novi autor",
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(65, 20, 65, 100),
            child: Column(
              children: [
                isLoading ? Container() : _buildForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState?.save();

                            try {
                              if (_formKey.currentState!.validate()) {
                                if (widget.author != null) {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['id'] = widget.author?.id;
                                  request['birthDate'] = DateEncode(_formKey
                                      .currentState?.value['birthDate']);
                                  request['mortalDate'] = DateEncode(_formKey
                                      .currentState?.value['mortalDate']);
                                  if (_base64Image != null) {
                                    request['image'] = _base64Image;
                                  }

                                  var res =
                                      await _authorProvider.update(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješno mofikovanje autora')));

                                  Navigator.pop(context, 'reload');
                                } else {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['birthDate'] = DateEncode(_formKey
                                      .currentState?.value['birthDate']);
                                  request['mortalDate'] = DateEncode(_formKey
                                      .currentState?.value['mortalDate']);
                                  if (_base64Image != null) {
                                    request['photo'] = _base64Image;
                                  }
                                  await _authorProvider.insert(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Uspješno dodavanje korisnika')));

                                  Navigator.pop(context, 'reload');
                                }
                              }
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Error'),
                                        content: Text(
                                          e.toString(),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Ok'))
                                        ],
                                      ));
                            }
                          },
                          child: const Text(
                            "Sačuvaj",
                            style: TextStyle(fontSize: 15),
                          )),
                    ),
                  ],
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
                              ? const Text('Odaberi sliku')
                              : const Text('Promijeni sliku')),
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
                decoration: const InputDecoration(label: Text("Naziv")),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: 'biography',
                  maxLines: 3,
                  decoration: const InputDecoration(label: Text("Biografija")),
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
                  child: FormBuilderDateTimePicker(
                name: 'birthDate',
                validator: ((value) {
                   if (value == null) {
                    return "Obavezno polje";
                  } else {
                    return null;
                  }
                }),
                decoration: const InputDecoration(label: Text("Datum rođenja")),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: FormBuilderDateTimePicker(
                  name: 'mortalDate',
                  decoration: const InputDecoration(label: Text("Datum smrti")),
                ),
              ),
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
            )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
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

      setState(() {
        photo = _base64Image;
      });
    }
  }
}
