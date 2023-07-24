import 'package:flutter/material.dart';

class BookShortDesription extends StatelessWidget {
 const  BookShortDesription({Key? key, this.decription}) : super(key: key);
  final String? decription;

 final TextStyle stil =const  TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kratak sadržaj'),
        centerTitle: true,
      ),
      body: (decription == null || decription!.isEmpty)
          ?  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Nema kratkog sadržaja', style: stil),
          )
          : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(decription ?? 'Nema opisa',style: stil,),
          ),
    );
  }
}
