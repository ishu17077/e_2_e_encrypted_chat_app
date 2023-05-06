import 'package:e_2_e_encrypted_chat_app/colors.dart';
import 'package:e_2_e_encrypted_chat_app/serverFunctions/add_new_user.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';

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
  int _phone = 6942069420;
  String _email = "lololol@exaple.com";
  String _password = "";
  String _confPassword = "";
  String _error = "";
  bool passCheck1 = false;
  bool passCheck2 = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.0069),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                  color: Colors.white38,
                ),
                onPressed: () => Navigator.pop(context),
              ),
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
                "Please fill the input below here",
                style: TextStyle(
                  color: Color.fromRGBO(133, 130, 141, 0.6),
                  fontSize: 15.0,
                ),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.0),
            formField(
              context,
              controller: _nameController,
              infoBox: 'FULL NAME',
              formField: 0,
              icon: Icons.person_2_outlined,
              onPressed: () {
                setState(() {
                  formFieldSelector = 0;
                });
              },
              onChanged: (value) => _name = value,
            ),
            formField(
              context,
              infoBox: 'PHONE',
              formField: 1,
              icon: Icons.phone_android_rounded,
              onPressed: () => setState(() {
                formFieldSelector = 1;
              }),
              onChanged: (value) => _phone = int.parse(value),
            ),

            formField(
              context,
              infoBox: 'EMAIL',
              formField: 2,
              icon: Icons.mail_outline,
              onPressed: () => setState(() {
                formFieldSelector = 2;
              }),
              onChanged: (value) => _email = value,
            ),
            formField(context,
                infoBox: 'PASSWORD',
                formField: 3,
                icon: Icons.password_rounded,
                onPressed: () => setState(() {
                      formFieldSelector = 3;
                    }),
                suffixIcon: passCheck1
                    ? _password == ""
                        ? null
                        : const Icon(
                            Icons.check_circle_outline_outlined,
                            color: Colors.greenAccent,
                          )
                    : const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      ),
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (_password.length <= 8) {
                    passCheck1 = false;
                    return "Password is smaller than 8 letters";
                  } else if (_password.isEmpty) {
                    passCheck1 = false;
                    return "Enter a password";
                  } else {
                    passCheck1 = true;
                  }
                }),
            formField(context,
                infoBox: 'CONFIRM PASSWORD',
                formField: 4,
                icon: Icons.password_rounded,
                suffixIcon: passCheck2
                    ? _password == ""
                        ? null
                        : const Icon(
                            Icons.check_circle_outline_outlined,
                            color: Colors.greenAccent,
                          )
                    : const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      ),
                onPressed: () {
                  setState(() {
                    formFieldSelector = 4;
                  });
                },
                onChanged: (value) => _confPassword = value,
                validator: (value) {
                  if (value != null && _password == _confPassword) {
                    passCheck2 = true;
                  } else {
                    passCheck2 = false;
                  }

                  return null;
                }),

            Center(
              child: signUpButton(
                context,
                onPressed: () {
                  // AddNewUser.userWithEmailandPassword(_email, _password);
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(
                      child: const Text(
                        "Sign in!",
                        style: TextStyle(color: Color(0xff0cf3e1)),
                      ),
                      onPressed: () {},
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget formField(BuildContext context,
      {String? infoBox,
      Key? key,
      VoidCallback? onPressed,
      IconData? icon,
      Icon? suffixIcon,
      int? formField,
      Function(String)? onChanged,
      TextEditingController? controller,
      String? Function(String?)? validator}) {
    bool isClicked = formFieldSelector == formField;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isClicked
              ? const Color.fromRGBO(133, 130, 141, 0.45)
              : kBackgroundColor,
        ),
        padding: const EdgeInsets.only(top: 5, bottom: 0, left: 12),
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          key: key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(
            labelText: "   $infoBox",
            labelStyle: const TextStyle(
              color: Colors.white54,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.white54,
            ),
            suffixIcon: suffixIcon,
            hintText: "",
            border: InputBorder.none,
            focusedBorder: const UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: onPressed,
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }

  Widget signUpButton(context, {required VoidCallback? onPressed}) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xff0cf3e1)),
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
