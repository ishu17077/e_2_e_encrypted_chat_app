// import 'package:secuchat/ui/pages/authentication_pages/reusable_widgets/my_form_field.dart';
// import 'package:secuchat/ui/pages/authentication_pages/sign_in_page.dart';
// import 'package:secuchat/ui/pages/chatPage/chat_page.dart';
// import 'package:chat/chat.dart' show User;
// import 'package:secuchat/server_functions/get_messages.dart';
// import 'package:secuchat/unit_components.dart';
// import 'package:secuchat/server_functions/add_new_user.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide User;

// import 'package:flutter/material.dart';

// import 'reusable_widgets/app_back_button.dart';

// int formFieldSelector = 69;

// // ignore: must_be_immutable
// class EmailAndPasswordAuthentication extends StatefulWidget {
//   const EmailAndPasswordAuthentication({super.key});

//   @override
//   State<EmailAndPasswordAuthentication> createState() =>
//       _EmailAndPasswordAuthenticationState();
// }

// class _EmailAndPasswordAuthenticationState
//     extends State<EmailAndPasswordAuthentication> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confPasswordController = TextEditingController();
//   bool _isPhoneValid = false;
//   bool _isNameValid = false;

// //? regex expressin for containing only numbers
//   bool _isPass1Valid = false;
//   FocusNode _focus = FocusNode();
//   bool _isConfPassValid = false;
//   bool _isEmailValid = false;
//   bool _isLoading = false;
//   late final GlobalKey<FormState> _formKey;
//   @override
//   void initState() {
//     // TODO: implement initState
//     _formKey = GlobalKey<FormState>();

//     FirebaseAuth.instance.signOut();
//     _focus.addListener(_onFocusChange);
//     lactivateListeners();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     disposeControllers();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   void _onFocusChange() {
//     _focus.canRequestFocus;
//   }

//   void lactivateListeners() {
//     _nameController.addListener(() {
//       _validateName(_nameController.text);
//     });
//     _phoneController.addListener(() {
//       _validatePhone(_phoneController.text);
//     });
//     _emailController.addListener(() {
//       _validateEmail(_emailController.text);
//     });
//     _passwordController.addListener(() {
//       _validatePassword1(_passwordController.text);
//     });

//     _confPasswordController.addListener(() {
//       _validateConfPassword(_confPasswordController.text);
//     });
//   }

//   void disposeControllers() {
//     _formKey.currentState?.dispose();
//     _emailController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confPasswordController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: kBackgroundColor,
//       body: ScrollConfiguration(
//         behavior: const ScrollBehavior().copyWith(overscroll: false),
//         child: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           child: Container(
//             padding: const EdgeInsets.all(17.0),
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Form(
//               key: _formKey,
//               child: SafeArea(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     AppBackButton(onPressed: () => Navigator.pop(context)),

//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.width * 0.030,
//                       ),
//                       child: const Text(
//                         "Create Account",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           fontSize: 38,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.width * 0.035,
//                       ),
//                       child: const Text(
//                         "Please fill the inputs below here",
//                         style: TextStyle(
//                           color: kSubHeadingColor,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ),
//                     // SizedBox(height: MediaQuery.of(context).size.height * 0.0),
//                     MyFormField(
//                       keyBoardType: TextInputType.name,
//                       onFocusChanged: (value) {
//                         if (value) {
//                           setState(() {
//                             formFieldSelector = 0;
//                           });
//                         }
//                       },
//                       infoBox: 'FULL NAME',
//                       formField: 0,
//                       validator: (value) =>
//                           _isNameValid ? null : "Fuck you biyach",
//                       prefixIcon: Icons.person_2_outlined,
//                       onPressed: () {
//                         setState(() {
//                           formFieldSelector = 0;
//                         });
//                       },
//                       textEditingController: _nameController,
//                       suffixIcon: _isNameValid
//                           ? greenCheckMark
//                           : _nameController.text.isEmpty
//                               ? null
//                               : redCross,
//                     ),
//                     MyFormField(
//                       infoBox: 'PHONE',
//                       keyBoardType: TextInputType.number,
//                       onFocusChanged: (value) => value
//                           ? formFieldSelector = 1
//                           : print(value.toString()),
//                       formField: 1,
//                       prefixIcon: Icons.phone_android_rounded,
//                       onPressed: () => setState(() {
//                         formFieldSelector = 1;
//                       }),
//                       validator: (value) =>
//                           _isPhoneValid ? null : "Fuck you biyach",
//                       textEditingController: _phoneController,
//                       suffixIcon: _isPhoneValid
//                           ? greenCheckMark
//                           : int.tryParse(_phoneController.text.isEmpty
//                                       ? '0'
//                                       : _passwordController.text) ==
//                                   69
//                               ? null
//                               : redCross,
//                     ),

//                     MyFormField(
//                       infoBox: 'EMAIL',
//                       keyBoardType: TextInputType.emailAddress,
//                       onFocusChanged: (value) => value
//                           ? formFieldSelector = 2
//                           : debugPrint(value.toString()),
//                       formField: 2,
//                       prefixIcon: Icons.mail_outline,
//                       onPressed: () => setState(() {
//                         formFieldSelector = 2;
//                       }),
//                       validator: (value) =>
//                           _isEmailValid ? null : "Fuck you biyach",
//                       textEditingController: _emailController,
//                       suffixIcon: _isEmailValid
//                           ? greenCheckMark
//                           : _emailController.text.isEmpty
//                               ? null
//                               : redCross,
//                     ),
//                     MyFormField(
//                       infoBox: 'PASSWORD',
//                       keyBoardType: TextInputType.visiblePassword,
//                       onFocusChanged: (value) => value
//                           ? formFieldSelector = 3
//                           : print(value.toString()),
//                       formField: 3,
//                       obscureText: true,
//                       prefixIcon: Icons.password_rounded,
//                       onPressed: () => setState(() {
//                         formFieldSelector = 3;
//                       }),
//                       validator: (value) =>
//                           _isPass1Valid ? null : "Fuck you biyach",
//                       suffixIcon: _isPass1Valid
//                           ? greenCheckMark
//                           : _passwordController.text.isEmpty
//                               ? null
//                               : redCross,
//                       textEditingController: _passwordController,
//                     ),
//                     MyFormField(
//                       infoBox: 'CONFIRM PASSWORD',
//                       formField: 4,
//                       keyBoardType: TextInputType.visiblePassword,
//                       onFocusChanged: (value) => value
//                           ? formFieldSelector = 1
//                           : print(value.toString()),
//                       obscureText: true,
//                       prefixIcon: Icons.password_rounded,
//                       validator: (value) =>
//                           _isConfPassValid ? null : "Fuck you biyach",
//                       suffixIcon: _isConfPassValid
//                           ? greenCheckMark
//                           : _confPasswordController.text == ""
//                               ? null
//                               : redCross,
//                       onPressed: () {
//                         setState(() {
//                           formFieldSelector = 4;
//                         });
//                       },
//                       textEditingController: _confPasswordController,
//                     ),

//                     Center(
//                       child: sexyTealButton(
//                         context,
//                         onPressed: () async {
//                           _formKey.currentState?.save();
//                           if (_formKey.currentState!.validate()) {
//                             final User? user = await AddNewUser
//                                     .createUserWithEmailandPassword(
//                                         _nameController.text,
//                                         _emailController.text.toLowerCase(),
//                                         _passwordController.text)
//                                 .then((value) => Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ChatPage()),
//                                       (route) => false,
//                                     ))
//                                 .onError((error, stackTrace) => ScaffoldMessenger
//                                         .of(context)
//                                     .showSnackBar(const SnackBar(
//                                         content: Text(
//                                             "Dekho email kahin already registered toh nhi ya toh net off kiye ho!!"))));
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text(
//                                         "Ganda Aadmi galtiyan karta ha!!")));
//                           }
//                         },
//                       ),
//                     ),
//                     Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Already have an account?",
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                             TextButton(
//                                 style: const ButtonStyle(
//                                   overlayColor: MaterialStatePropertyAll(
//                                       Colors.transparent),
//                                 ),
//                                 child: const Text(
//                                   "Sign in!",
//                                   style: TextStyle(color: Color(0xff0cf3e1)),
//                                 ),
//                                 onPressed: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const SignInPage())))
//                           ],
//                         ))
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget sexyTealButton(context, {required VoidCallback? onPressed}) {
//     return ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(kSexyTealColor),
//         minimumSize: MaterialStateProperty.all(Size(
//             MediaQuery.of(context).size.width * 0.55,
//             MediaQuery.of(context).size.height * 0.075)),
//         elevation: MaterialStateProperty.all(5.0),
//         shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
//       ),
//       onPressed: _isLoading ? null : onPressed,
//       child: _isLoading
//           ? const CircularProgressIndicator()
//           : const Text(
//               "SIGN UP",
//               style: TextStyle(
//                 color: kBackgroundColor,
//                 fontSize: 15,
//               ),
//             ),
//     );
//   }

//   void _validateEmail(String? email) {
//     if ((email?.length ?? 0) != 0 && emailRegExp.hasMatch(email ?? '')) {
//       setState(() {
//         _isEmailValid = true;
//       });
//     } else {
//       setState(() {
//         _isEmailValid = false;
//       });
//     }
//   }

//   void _validateName(String? name) {
//     if ((name?.length ?? 0) > 3 && nameRegExp.hasMatch(name ?? '')) {
//       setState(() {
//         _isNameValid = true;
//       });
//     } else {
//       setState(() {
//         _isNameValid = false;
//       });
//     }
//   }

//   void _validatePhone(String? phone) {
//     if (phone?.length == 10 && phoneRegExp.hasMatch(phone ?? '69')) {
//       setState(() {
//         _isPhoneValid = true;
//       });
//     } else {
//       setState(() {
//         _isPhoneValid = false;
//       });
//     }
//   }

//   void _validatePassword1(String? password) {
//     if ((password?.length ?? 0) >= 6) {
//       setState(() {
//         _isPass1Valid = true;
//       });
//     } else {
//       setState(() {
//         _isPass1Valid = false;
//       });
//     }
//   }

//   void _validateConfPassword(String? password) {
//     if ((password?.length ?? 0) >= 6 && password == _passwordController.text) {
//       setState(() {
//         _isConfPassValid = true;
//       });
//     } else {
//       setState(() {
//         _isConfPassValid = false;
//       });
//     }
//   }
// }
