import 'package:admin_ebiblioteka/providers/notification_provider.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../utils/util_widgets.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({Key? key, this.notif}) : super(key: key);
  final Notif? notif;

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late NotificationProvider _notificationProvider = NotificationProvider();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'content': widget.notif?.content,
      'title': widget.notif?.title
    };
    _notificationProvider = context.read<NotificationProvider>();

  }


  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title:  widget.notif != null
            ? "${AppLocalizations.of(context).notif_id} ${(widget.notif?.id.toString() ?? '')}"
            : '',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(65, 80, 65, 100),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildForm(),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.notif == null
                            ? Container()
                            : const SizedBox(
                                width: 7,
                              ),
                        TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                        title: Text(AppLocalizations.of(context)
                                            .notif_del_title),
                                        content: Text(AppLocalizations.of(context)
                                            .notif_del_mes),
                                        actions: [
                                          TextButton(
                                              onPressed: (() {
                                                Navigator.pop(context);
                                              }),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .cancel)),
                                          TextButton(
                                              onPressed: () async {
                                                try {
                                                  await _notificationProvider
                                                      .remove(
                                                          widget.notif?.id ?? 0);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .notif_del_su)));
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, 'reload');
                                                } catch (e) {
                                                  alertBoxMoveBack(
                                                      context,
                                                      AppLocalizations.of(context)
                                                          .error,
                                                      e.toString());
                                                }
                                              },
                                              child: const Text('Ok')),
                                        ],
                                      ));
                            },
                            child:
                                Text(AppLocalizations.of(context).notif_del_lbl)),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: FormBuilderTextField(
                readOnly: true,
                name: 'title',
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).title)),
              )),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                  child: FormBuilderTextField(
                readOnly: true,
                name: 'content',
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context).content)),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
