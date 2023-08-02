import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_in_page.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/get_messages.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:flutter/material.dart';

import 'reusable_widgets/app_back_button.dart';

// ignore: must_be_immutable
class EmailAndPasswordAuthentication extends StatefulWidget {
  const EmailAndPasswordAuthentication({super.key});

  @override
  State<EmailAndPasswordAuthentication> createState() =>
      _EmailAndPasswordAuthenticationState();
}

class _EmailAndPasswordAuthenticationState
    extends State<EmailAndPasswordAuthentication> {
  int formFieldSelector = 69;
  String _name = "";
  int _phone = 69;
  String _email = "";
  String _password = "";
  String _confPassword = "";
  bool _shouldParse = false;
  bool _shouldName = false;
  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
//? regex expressin for containing only numbers
  bool _passCheck1 = false;
  bool _passCheck2 = false;
  bool _emailValidate = false;
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    // TODO: implement initState
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _email = '';
    _name = '';
    _phone = 0;
    _password = '';
    _formKey.currentState!.reset();
    _confPassword = '';
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(17.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.002568493),
                    child: const AppBackButton(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.030,
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 38,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.035,
                    ),
                    child: const Text(
                      "Please fill the inputs below here",
                      style: TextStyle(
                        color: kSubHeadingColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                  formField(
                    context,
                    keyBoardType: TextInputType.name,
                    infoBox: 'FULL NAME',
                    formField: 0,
                    validator: (value) {
                      if (value == null || value.length <= 3) {
                        _shouldName = false;
                        return "Enter your correct name";
                      } else {
                        _shouldName = true;
                      }
                      return null;
                    },
                    icon: Icons.person_2_outlined,
                    onPressed: () {
                      setState(() {
                        formFieldSelector = 0;
                      });
                    },
                    onChanged: (value) => _name = value,
                    suffixIcon: _shouldName
                        ? greenCheckMark
                        : _name.isEmpty
                            ? null
                            : redCross,
                  ),
                  formField(
                    context,
                    infoBox: 'PHONE',
                    keyBoardType: TextInputType.number,
                    formField: 1,
                    icon: Icons.phone_android_rounded,
                    onPressed: () => setState(() {
                      formFieldSelector = 1;
                    }),
                    onChanged: (value) => _shouldParse && value.isNotEmpty
                        ? _phone = int.tryParse(value) ?? 0
                        : _phone = 0,
                    validator: (value) {
                      if (numericRegex.hasMatch(value ?? '') &&
                          value != null &&
                          value.isNotEmpty &&
                          value.length == 10) {
                        print(value);
                        _shouldParse = true;
                      } else {
                        _shouldParse = false;
                        return "Enter your correct number";
                      }
                      return null;
                    },
                    suffixIcon: _shouldParse
                        ? greenCheckMark
                        : _phone == 69
                            ? null
                            : redCross,
                  ),

                  formField(
                    context,
                    infoBox: 'EMAIL',
                    keyBoardType: TextInputType.emailAddress,
                    formField: 2,
                    icon: Icons.mail_outline,
                    onPressed: () => setState(() {
                      formFieldSelector = 2;
                    }),
                    onChanged: (value) => _email = value,
                    validator: (value) {
                      if (value != null &&
                          value.contains('.') &&
                          value.contains('@')) {
                        _emailValidate = true;
                      } else {
                        _emailValidate = false;
                        return "Invalid E -mail";
                      }
                      return null;
                    },
                    suffixIcon: _emailValidate
                        ? greenCheckMark
                        : _email.isEmpty
                            ? null
                            : redCross,
                  ),
                  formField(context,
                      infoBox: 'PASSWORD',
                      keyBoardType: TextInputType.visiblePassword,
                      formField: 3,
                      obscureText: true,
                      icon: Icons.password_rounded,
                      onPressed: () => setState(() {
                            formFieldSelector = 3;
                          }),
                      suffixIcon: _passCheck1
                          ? greenCheckMark
                          : _password.isEmpty
                              ? null
                              : redCross,
                      onChanged: (value) => _password = value,
                      validator: (value) {
                        if (_password.length <= 8) {
                          _passCheck1 = false;
                          return "Your password sucks :o";
                        } else if (_password.isEmpty) {
                          _passCheck1 = false;
                          return "Please enter a goddamn password!!";
                        } else {
                          _passCheck1 = true;
                        }
                        return null;
                      }),
                  formField(context,
                      infoBox: 'CONFIRM PASSWORD',
                      formField: 4,
                      keyBoardType: TextInputType.visiblePassword,
                      obscureText: true,
                      icon: Icons.password_rounded,
                      suffixIcon: _passCheck2
                          ? greenCheckMark
                          : _confPassword == ""
                              ? null
                              : redCross,
                      onPressed: () {
                        setState(() {
                          formFieldSelector = 4;
                        });
                      },
                      onChanged: (value) => _confPassword = value,
                      validator: (value) {
                        if (value != null &&
                            _password == _confPassword &&
                            _confPassword.isNotEmpty) {
                          _passCheck2 = true;
                        } else {
                          _passCheck2 = false;
                          return "Passwords do not match";
                        }

                        return null;
                      }),

                  Center(
                    child: sexyTealButton(
                      context,
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          AddNewUser.createUserWithEmailandPassword(
                              _email, _password);
                          User user = User(
                            emailAddress: _email,
                            username: _name,
                            photoUrl: '',
                            lastseen: DateTime.now(),
                          );
                          GetMessages.addUser(user);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Ganda Aadmi galtiyan karta ha!!")));
                        }
                      },
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                              style: const ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                              ),
                              child: const Text(
                                "Sign in!",
                                style: TextStyle(color: Color(0xff0cf3e1)),
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInPage())))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(BuildContext context,
      {String? infoBox,
      TextInputType keyBoardType = TextInputType.text,
      Key? key,
      VoidCallback? onPressed,
      IconData? icon,
      Icon? suffixIcon,
      int? formField,
      bool obscureText = false,
      Function(String)? onChanged,
      TextEditingController? controller,
      String? Function(String?)? validator}) {
    bool isClicked = formFieldSelector == formField;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isClicked ? kTextFieldColor : Colors.transparent,
        ),
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 12),
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          key: key,
          autovalidateMode: AutovalidateMode.always,
          controller: controller,
          decoration: InputDecoration(
            labelText: infoBox,

            labelStyle: const TextStyle(
              color: Colors.white54,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white54,
            ),
            suffixIcon: suffixIcon,

            border: InputBorder.none,
            focusedBorder: const UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            // errorBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(25.0),
            //     borderSide: const BorderSide(
            //         strokeAlign: -100, color: Colors.redAccent, width: 0)),
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
          ),
          textInputAction:
              formField == 4 ? TextInputAction.done : TextInputAction.next,
          onTap: onPressed,
          keyboardType: keyBoardType,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }

  Widget sexyTealButton(context, {required VoidCallback? onPressed}) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kSexyTealColor),
        minimumSize: MaterialStateProperty.all(Size(
            MediaQuery.of(context).size.width * 0.55,
            MediaQuery.of(context).size.height * 0.075)),
        elevation: MaterialStateProperty.all(5.0),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
      ),
      onPressed: onPressed,
      child: const Text(
        "SIGN UP",
        style: TextStyle(
          color: kBackgroundColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
