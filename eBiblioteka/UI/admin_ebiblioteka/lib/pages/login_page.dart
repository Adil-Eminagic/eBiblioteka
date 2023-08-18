import 'package:admin_ebiblioteka/providers/language_provider.dart';

import '../pages/book_list.dart';
import '../providers/sign_provider.dart';
import '../utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SignProvider _signProvider = SignProvider();
  late LanguageProvider _languageProvider = LanguageProvider();
  //late UserProvider _userProvider = UserProvider();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _signProvider = context.read<SignProvider>();
    //_userProvider = context.read<UserProvider>();
    _languageProvider = context.read<LanguageProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).sign_in),
        centerTitle: true,
        actions: [
          TextButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          //title: Text('nesto'),

                          content:
                              // Image(image: 'assets/uk.png'),
                              Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: (() {
                                    _languageProvider.changeLanguage('en');
                                     Navigator.pop(context);
                                  }),
                                  child: Image.asset(
                                    'assets/uk.png',
                                    width: 100,
                                    height: 100,
                                  )),
                            const  SizedBox(
                                width: 100,
                              ),
                              InkWell(
                                onTap: () {
                                    _languageProvider.changeLanguage('bs');
                                     Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/bih.png',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ],
                          ),

                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:  Text(AppLocalizations.of(context).cancel)),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              label: Text(
                AppLocalizations.of(context).language_name,
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
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
                    decoration:  InputDecoration(
                        label: Text(AppLocalizations.of(context).password), icon: const Icon(Icons.password)),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  isLoading
                      ? Container(
                          width: 25,
                          height: 25,
                          child: const SpinKitRing(color: Colors.brown),
                        ) //const Text('Učitavanje', style:  TextStyle(fontWeight: ),)
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

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
                              // int number= int.parse(Autentification.tokenDecoded!['Id']);
                              // Autentification.loggedUser = await _userProvider
                              //     .getById(number);
                              print(Autentification.tokenDecoded);
                              // if (Autentification.tokenDecoded?['Role'] == 'User') {
                              //   alertBox(context, 'Greška',
                              //       'Korisnicima zabranjen pristup desktop aplikaciji');
                              // } else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const BooksPage();
                              }));
                              isLoading = false;
                              //}
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title:  Text(AppLocalizations.of(context).error),
                                        content: Text(
                                          e.toString(),
                                        ),
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
                          child: const Text('Log in')),
                  const SizedBox(
                    height: 15,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text(
                  //       'Nemate nalog',
                  //       // style: TextStyle(
                  //       //   decoration: TextDecoration.underline,
                  //       // ),
                  //     ),
                  //     TextButton(
                  //         onPressed: () {
                  //           Navigator.of(context).push(MaterialPageRoute(
                  //               builder: (context) => const SignupPage()));
                  //         },
                  //         child: Text(AppLocalizations.of(context).language)
                  //         //const Text('Registrujte se, ${}'),
                  //         ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
