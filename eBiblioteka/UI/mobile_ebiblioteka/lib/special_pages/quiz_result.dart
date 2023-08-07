import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({Key? key, this.totalPoint, this.wonPoints})
      : super(key: key);
  final int? totalPoint;
  final int? wonPoints;

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    var result =  (widget.wonPoints! / widget.totalPoint! * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaš rezultat'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
             Navigator.pop(context);
              Navigator.pop(context);
              
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                  'Osvojili ste ${widget.wonPoints}/${widget.totalPoint} ,što je $result%',
                  style: const TextStyle(fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}
