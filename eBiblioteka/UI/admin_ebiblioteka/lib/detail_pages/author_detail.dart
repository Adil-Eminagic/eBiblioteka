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
  AuthorDetailPage({super.key, this.author});
  Author? author;
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
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
    initForm();
  }

  Future<void> initForm() async {
    countryResult = await _countryProvider.getPaged();
    print(countryResult?.isFirstPage);
    genderResult = await _genderProvider.getPaged();
    print(genderResult?.items[1].value);
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
                        _formKey.currentState
                            ?.saveAndValidate(); //moramo spasiti vrijednosti forme kako bi se pohranile u currentstate
                        // print(_formKey.currentState?.value);

                        try {
                          if (widget.author != null) {
                            Map<String, dynamic> request =
                                Map.of(_formKey.currentState!.value);

                            request['id'] = widget.author?.id;
                            request['birthDate'] = DateEncode(
                                _formKey.currentState?.value['birthDate']);
                            request['mortalDate'] = DateEncode(
                                _formKey.currentState?.value['mortalDate']);

                            var res = await _authorProvider.update(request);
                          } else {
                            Map<String, dynamic> request =
                                Map.of(_formKey.currentState!.value);

                            request['birthDate'] = DateEncode(
                                _formKey.currentState?.value['birthDate']);
                            request['mortalDate'] = DateEncode(
                                _formKey.currentState?.value['mortalDate']);
                            await _authorProvider.insert(request);
                          }
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
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
                        "Sacuvaj",
                        style: TextStyle(fontSize: 15),
                      )),
                ),
              ],
            )
          ],
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
                  decoration: const InputDecoration(label: Text("Biografija")),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderDateTimePicker(
                name: 'birthDate',
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
          Row(children: [
            Expanded(
                child: FormBuilderDropdown<String>(
              name: 'genderId',
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
          Row(
            children: [
              Expanded(
                child: FormBuilderField(
                  //ovo je za custom form componentu
                  name: 'imageId', //moze se koristiti i validator
                  builder: ((field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          label: const Text('Odaberite sliku'),
                          errorText: field.errorText),
                      child: ListTile(
                        leading: Icon(Icons.photo),
                        title: Text('Select image'),
                        trailing: Icon(Icons.file_upload),
                        onTap: getimage,
                      ),
                    );
                  }),
                ),
              )
            ],
          )
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
    }
  }
}
