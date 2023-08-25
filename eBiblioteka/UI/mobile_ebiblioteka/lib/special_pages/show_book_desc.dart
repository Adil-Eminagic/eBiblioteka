import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BookShortDesription extends StatelessWidget {
 const  BookShortDesription({Key? key, this.decription}) : super(key: key);
  final String? decription;

 final TextStyle stil =const  TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).short_desc),
        centerTitle: true,
      ),
      body: (decription == null || decription!.isEmpty)
          ?  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(AppLocalizations.of(context).no_short_de, style: stil),
          )
          : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(decription ?? AppLocalizations.of(context).no_short_de,style: stil,),
          ),
    );
  }
}
