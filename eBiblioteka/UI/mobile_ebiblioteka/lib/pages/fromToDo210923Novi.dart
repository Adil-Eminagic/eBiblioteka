import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_ebiblioteka/models/todo210923.dart';
import 'package:mobile_ebiblioteka/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/tod210923_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import '../utils/util_widgets.dart';

class FrmToDo210923Novi extends StatefulWidget {
  const FrmToDo210923Novi({Key? key}) : super(key: key);

  @override
  State<FrmToDo210923Novi> createState() => _FrmToDo210923NoviState();
}

class _FrmToDo210923NoviState extends State<FrmToDo210923Novi> {
  final _formKey = GlobalKey<FormBuilderState>();

  late UserProvider _userProvider = UserProvider();
  late ToDo210923Provider _toDo210923Provider = ToDo210923Provider();

  SearchResult<User>? resultUsers;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _toDo210923Provider = context.read<ToDo210923Provider>();

    initData();
  }

  Future<void> initData() async {
    try {
      var userData =
          await _userProvider.getPaged(filter: {'pageSize': 1000000000});

      if (mounted) {
        setState(() {
          isLoading = false;
          resultUsers = userData;
        });
      }
    } catch (e) {
      alertBox(context, "Errror", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Nova to do",
        child: isLoading == true
            ? SpinKitRing(color: Colors.brown)
            : SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(children: [
                    rowMethod(Expanded(
                        child: FormBuilderDropdown<String>(
                      name: 'userId',
                      validator: (value) {
                        if (value == null) {
                          return "M FIELD";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Korisnik",
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!
                                .fields['userId'] //brisnje selekcije iz forme
                                ?.reset();
                          },
                        ),
                      ),
                      items: resultUsers?.items
                              .map((g) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: g.id.toString(),
                                    child: Text("${g.firstName} ${g.lastName}"),
                                  ))
                              .toList() ??
                          [],
                    ))),
                    rowMethod(_textField('activityName', "Naziv")),
                    rowMethod(_textField('activityDescription', "Opis")),
                    rowMethod(
                      Expanded(
                          child: FormBuilderDateTimePicker(
                        name: 'finshingDate',
                        validator: (value) {
                          if (value == null) {
                            return "Must field";
                          } else {
                            return null;
                          }
                        },
                        decoration:
                            const InputDecoration(label: Text("DATUM ISTEKA")),
                      )),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: (() async {
                              _formKey.currentState?.save();
                              try {
                                if (_formKey.currentState!.validate()) {
                                  Map<String, dynamic> request =
                                      Map.of(_formKey.currentState!.value);

                                  request['finshingDate'] = DateEncode(_formKey
                                      .currentState?.value['finshingDate']);

                                  request['statusCode'] = "U toku";

                                  await _toDo210923Provider.insert(request);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Dodana to do")));

                                  Navigator.pop(context, 'reload');
                                }
                              } on Exception catch (e) {
                                alertBox(context, "Error", e.toString());
                              }
                            }),
                            child: Text('Spasi'))
                      ],
                    )
                  ]),
                ),
              ));
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
