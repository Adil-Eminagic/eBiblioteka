import 'package:mobile_ebiblioteka/pages/home_page.dart';

import '../providers/sign_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late SignProvider _signProvider = SignProvider();
  late UserProvider _userProvider = UserProvider();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _signProvider = context.read<SignProvider>();
    _userProvider = context.read<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Prijava"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'eBiblioteka',
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 45,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 70,
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
                isLoading
                    ? const SpinKitRing(color: Colors.brown)
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
          
                          _emailController.text = "nejra@gmail.com";
                          _passwordController.text = "Password8";
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
          
                            print(Autentification.tokenDecoded);
                            // if (Autentification.tokenDecoded?['Role'] == 'User') {
                            //   alertBox(context, 'Greška',
                            //       'Korisnicima zabranjen pristup desktop aplikaciji');
                            // } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const HomePage(); // const AuthorsPage();
                            }));
                            isLoading = false;
                          } catch (e) {
                            print(e.toString());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Error'),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: Text('Ok'))
                                      ],
                                    ));
                          }
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 18),
                        )),
                const SizedBox(
                  height: 15,
                ),
                isLoading ? Container() : Row(
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
                            builder: (context) => const SignupPage()
                            ));
                      },
                      child: const Text('Registrujte se'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
