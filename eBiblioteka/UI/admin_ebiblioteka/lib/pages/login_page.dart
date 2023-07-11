import 'dart:ffi';

import 'package:admin_ebiblioteka/pages/authors_list.dart';
import 'package:admin_ebiblioteka/pages/signup_page.dart';
import 'package:admin_ebiblioteka/providers/sign_provider.dart';
import 'package:admin_ebiblioteka/utils/util.dart';
import 'package:admin_ebiblioteka/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../utils/util_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late SignProvider _signProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _signProvider = context.read<SignProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prijava"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'eBiblioteka',
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        label: Text("Email"), icon: Icon(Icons.mail)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        label: Text('Password'), icon: Icon(Icons.password)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _emailController.text = "site.admin@gmail.com";
                        _passwordController.text = "test";
                        var email = _emailController.text;
                        var password = _passwordController.text;

                        try {
                          var data =
                              await _signProvider.signIn(email, password);
                          var token = data['token'];
                          Autentification.token = token;
                          Autentification.tokenDecoded =
                              JwtDecoder.decode(token);
                          print(Autentification.tokenDecoded);
                          // if (Autentification.tokenDecoded?['Role'] == 'User') {
                          //   alertBox(context, 'Greška',
                          //       'Korisnicima zabranjen pristup desktop aplikaciji');
                          // } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return const AuthorsPage();
                          }));
                          //}
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'))
                                    ],
                                  ));
                        }
                      },
                      child: const Text('Log in')),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Nemate nalog',
                        // style: TextStyle(
                        //   decoration: TextDecoration.underline,
                        // ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupPage()));
                        },
                        child: Text('Registrujte se'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
