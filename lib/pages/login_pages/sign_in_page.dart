// import 'dart:developer';

// import 'package:dtc_manager/pages/home_page.dart';
// import 'package:dtc_manager/pages/login_pages/sign_up_page.dart';
// import 'package:dtc_manager/provider/authentication_provider.dart';
// import 'package:dtc_manager/provider/maria_db_provider.dart';
// import 'package:dtc_manager/widgets/main_logo.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';

// import 'package:encrypt/encrypt.dart' as en;

// class SignInPage extends StatefulWidget {
//   SignInPage({Key? key}) : super(key: key);

//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   late AuthenticationProvider _authenticationProvider;
//   late MariaDBProvider _mariaDBProvider;

//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;
//   late TextEditingController _resetController;

//   late FocusNode _emailFocusNode;
//   late FocusNode _passwordFocusNode;
//   late FocusNode _resetFocusNode;

//   String _loginStatus = '';
//   Color _loginStringColor = Colors.green;

//   bool _isLoggingIn = false;

//   _signInRequest() async {
//     final token = await FirebaseMessaging.instance.getToken();

//     if (_emailController.text.isNotEmpty &&
//         _passwordController.text.isNotEmpty) {
//       await _mariaDBProvider.checkAuthroized(_emailController.text, token!);

//       if (_mariaDBProvider.isAuthorized!) {
//         await _authenticationProvider
//             .signIn(
//                 email: _emailController.text,
//                 password: _passwordController.text)
//             .then((result) {
//           if (result.isEmpty) {
//             setState(() {
//               _isLoggingIn = false;
//               _loginStatus = '';
//               _loginStringColor = Colors.green;
//             });
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => HomePage(),
//               ),
//               (_) => false,
//             );
//           } else {
//             setState(() {
//               _isLoggingIn = false;
//               _loginStatus = result.tr();
//               _loginStringColor = Colors.red;
//             });
//           }
//         });
//       } else {
//         setState(() {
//           _isLoggingIn = false;
//           _loginStatus = 'loginStatus1-6'.tr();
//           _loginStringColor = Colors.red;
//         });
//       }
//     } else {
//       setState(() {
//         _isLoggingIn = false;
//         _loginStatus = 'loginStatus5'.tr();
//         _loginStringColor = Colors.red;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     _resetController = TextEditingController();
//     _emailFocusNode = FocusNode();
//     _passwordFocusNode = FocusNode();
//     _resetFocusNode = FocusNode();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _authenticationProvider =
//         Provider.of<AuthenticationProvider>(context, listen: false);
//     _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 30),
//                   child: const MainLogo(),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _emailController,
//                       focusNode: _emailFocusNode,
//                       keyboardType: TextInputType.emailAddress,
//                       autofillHints: [AutofillHints.email],
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                         labelText: 'Email',
//                         icon: Icon(
//                           Icons.email,
//                         ),
//                       ),
//                       onSubmitted: (value) {
//                         _emailFocusNode.unfocus();
//                         FocusScope.of(context).requestFocus(_passwordFocusNode);
//                       },
//                     ),
//                     const SizedBox(height: 16.0),
//                     TextField(
//                       controller: _passwordController,
//                       focusNode: _passwordFocusNode,
//                       obscureText: true,
//                       keyboardType: TextInputType.text,
//                       autofillHints: [AutofillHints.password],
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                         labelText: 'Password',
//                         icon: Icon(
//                           Icons.lock,
//                         ),
//                       ),
//                       onSubmitted: !_isLoggingIn
//                           ? (value) {
//                               setState(() {
//                                 _isLoggingIn = true;
//                                 _loginStatus = '';
//                                 _emailFocusNode.unfocus();
//                                 _passwordFocusNode.unfocus();
//                               });
//                               _signInRequest();
//                             }
//                           : null,
//                     ),
//                     const SizedBox(height: 16.0),
//                     _loginStatus.isNotEmpty
//                         ? Center(
//                             child: Text(
//                               _loginStatus,
//                               style: TextStyle(
//                                 color: _loginStringColor,
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                           )
//                         : Container(),
//                     const SizedBox(height: 16.0),
//                     if (!_isLoggingIn)
//                       MaterialButton(
//                         onPressed: () {
//                           setState(() {
//                             _isLoggingIn = true;
//                             _loginStatus = '';
//                             _emailFocusNode.unfocus();
//                             _passwordFocusNode.unfocus();
//                           });
//                           _signInRequest();
//                         },
//                         minWidth: double.infinity,
//                         height: 50.0,
//                         color: Theme.of(context).colorScheme.secondary,
//                         textColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0)),
//                         child: Text(
//                           'login1'.tr(),
//                           style: TextStyle(color: Colors.white, fontSize: 16.0),
//                         ),
//                       ),
//                     SizedBox(height: 16.0),
//                     if (!_isLoggingIn)
//                       MaterialButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                               MaterialPageRoute(builder: (_) => SignUpPage()));
//                         },
//                         minWidth: double.infinity,
//                         height: 50.0,
//                         color: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0)),
//                         child: Text(
//                           'login2'.tr(),
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ),
//                     if (_isLoggingIn)
//                       Center(child: CircularProgressIndicator()),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
