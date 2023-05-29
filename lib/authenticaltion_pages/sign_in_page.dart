import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/reusable_widgets/app_back_button.dart';
import 'package:e_2_e_encrypted_chat_app/serverFunctions/existing_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  int formFieldSelector = 69;

  String _email = "";

  String _password = "";

  bool _emailValidate = false;

  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

//? regex expressin for containing only numbers
  bool _passCheck = false;

  late final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.016106397),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0069),
                child: const AppBackButton(),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030956266),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.030,
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 38,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030956266),
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
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030956266),
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
                },
                suffixIcon: _emailValidate
                    ? greenCheckMark
                    : _email.isEmpty
                        ? null
                        : redCross,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030956266),
              formField(context,
                  infoBox: 'PASSWORD',
                  keyBoardType: TextInputType.visiblePassword,
                  formField: 3,
                  obscureText: true,
                  icon: Icons.password_rounded,
                  onPressed: () => setState(() {
                        formFieldSelector = 3;
                      }),
                  suffixIcon: _passCheck
                      ? greenCheckMark
                      : _password.isEmpty
                          ? null
                          : redCross,
                  onChanged: (value) => _password = value,
                  validator: (value) {
                    if (_password.length <= 8) {
                      _passCheck = false;
                      print(MediaQuery.of(context).size.height);
                      return "Your password sucks :o";
                    } else if (_password.isEmpty) {
                      _passCheck = false;
                      return "Please enter a goddamn password!!";
                    } else {
                      _passCheck = true;
                    }
                  }),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030956266),
              Center(
                  child: sexyTealButton(context, onPressed: () {
                _formKey.currentState?.save();
                if (_formKey.currentState!.validate()) {
                  ExistingUser.signInExistingUserWithEmailandPassword(
                      _email, _password);
                }
              })),
            ],
          ),
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
        "SIGN IN",
        style: TextStyle(
          color: kBackgroundColor,
          fontSize: 15,
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
          color: isClicked
              ? const Color.fromRGBO(133, 130, 141, 0.45)
              : Colors.transparent,
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
}
