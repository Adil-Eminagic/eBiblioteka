
import '../special_pages/payment_page.dart';
import '../pages/home_page.dart';
import '../providers/language_provider.dart';

import '../providers/sign_provider.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';



import 'signup_page.dart';

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
  late UserProvider _userProvider = UserProvider();
  late LanguageProvider _languageProvider = LanguageProvider();
  bool isLoading = false;
  bool isPayed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signProvider = context.read<SignProvider>();
    _userProvider = context.read<UserProvider>();
    _languageProvider = context.read<LanguageProvider>();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(

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
                  'eBiblioteka ',
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 45,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: (() {
                                              _languageProvider
                                                  .changeLanguage('en');
                                              Navigator.pop(context);
                                            }),
                                            child: Image.asset(
                                              'assets/uk.png',
                                              width: 70,
                                              height: 70,
                                            )),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _languageProvider
                                                .changeLanguage('bs');
                                            Navigator.pop(context);
                                          },
                                          child: Image.asset(
                                            'assets/bih.png',
                                            width: 70,
                                            height: 70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .cancel)),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.language),
                        label: Text(
                          AppLocalizations.of(context).language_name,
                          style: const TextStyle(fontSize: 19),
                        )),
                  ],
                ),
               
                //     child: DropdownButton(
                //   items: const [
                //     DropdownMenuItem(value: "bs", child: Text("Bosanski")),
                //     DropdownMenuItem(value: "en", child: Text("English")),
                //   ],
                //   value: _dropdownValue,
                //   onChanged: ((value) async {
                //     if (value is String) {
                //        await _languageProvider.lang(value);
                //       setState(() {
                //         _dropdownValue = value;

                //       });
                //     }
                //   }),
                // )),
                const SizedBox(
                  height: 25,
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
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context).password),
                      icon: const Icon(Icons.password)),
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

                          _emailController.text = "user2@gmail.com";
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

                            // if (Autentification.tokenDecoded?['Role'] == 'User') {
                            //   alertBox(context, 'Greška',
                            //       'Korisnicima zabranjen pristup desktop aplikaciji');
                            // } else {
                            if (Autentification
                                    .tokenDecoded!['IsActiveMembership'] ==
                                "True") {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const HomePage(); // const AuthorsPage();
                              }));
                            } else {
                              _paymentMethod(context);
                             
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(builder: (context) {
                                //   return const PaymentPage();
                                // }));
                                // setState(() {
                                //   isLoading = false;
                                // });
                              }
                           

                            setState(() {
                              isLoading = false;
                            });
// i think it is for spinning kit
                          } catch (e) {
                            print(e.toString());
                            showDialog(
                              barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          AppLocalizations.of(context).error),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: const Text('Ok'))
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
                isLoading
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).no_profile,
                              style: const TextStyle(fontSize: 17)),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                            },
                            child: Text(
                              AppLocalizations.of(context).sign_up,
                              style: const TextStyle(fontSize: 17),
                            ),
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

  void _paymentMethod(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,//make it modal dialog
        builder: (BuildContext context) => AlertDialog(
              title:  Text(AppLocalizations.of(context).mebership),
              content:  Text(
                  AppLocalizations.of(context).inactive_meb),
              actions: [
                TextButton(
                    // style: ElevatedButton.styleFrom(
                    //   primary:theme.colorScheme.primary
                    // ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text(AppLocalizations.of(context).cancel)),
                ElevatedButton(
                    
                    onPressed: () {
                    
                        Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const PaymentPage();
                                }));
                    },
                    child:  Text(AppLocalizations.of(context).pay))
              ],
            ));
  }
}
