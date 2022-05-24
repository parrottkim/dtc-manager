import 'package:dtc_manager/provider/authentication_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:encrypt/encrypt.dart' as en;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late MariaDBProvider _mariaDBProvider;

  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  late FocusNode _emailFocusNode;
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmFocusNode;

  bool _isEmailEditing = false;
  bool _isUsernameEditing = false;
  bool _isPasswordEditing = false;
  bool _isConfirmEditing = false;

  bool _isEmailExists = true;

  String _signUpStatus = '';
  Color _signUpStringColor = Colors.green;

  bool _isSigningUp = false;

  _checkEmailExists(String email) async {
    await _mariaDBProvider.getEmailDuplicated(email);
    return _isEmailExists = _mariaDBProvider.isEmailDuplicated!;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'login2-1'.tr();
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@kiageorgia\.com$")
        .hasMatch(value)) {
      return 'login2-2'.tr();
    } else if (_isEmailExists) {
      return 'login2-3'.tr();
    }
    return null;
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'login2-4'.tr();
    } else if (!RegExp(r"^[A-Za-z ]+(?<![0-9.!#$%&'*+-/=?^_`{|}~])$")
        .hasMatch(value)) {
      return 'login2-5'.tr();
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'login2-6'.tr();
    } else if (value.length < 6) {
      return 'login2-7'.tr();
    }
    return null;
  }

  String? _validateConfirm(String value) {
    if (value.isEmpty) {
      return 'login2-6'.tr();
    } else if (value != _passwordController.text) {
      return 'login2-8'.tr();
    }
    return null;
  }

  _signUpRequest() async {
    final secureKey = en.Key.fromUtf8(dotenv.env['secure_key']!);
    final iv = en.IV.fromUtf8(dotenv.env['iv']!);
    final encrypter = en.Encrypter(en.AES(secureKey, mode: en.AESMode.cbc));
    final encrypted =
        encrypter.encrypt(_passwordController.text, iv: iv).base64;

    final token = await FirebaseMessaging.instance.getToken();

    await _mariaDBProvider
        .registerUser(
      _emailController.text,
      _usernameController.text,
      encrypted,
      token!,
    )
        .then((_) async {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('login2-9'.tr()),
          content: Text('login2-10'.tr()),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok').tr(),
            ),
          ],
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('settings1-3-13').tr()));
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _emailFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('login2'.tr())),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Email',
                    icon: Icon(
                      Icons.email,
                    ),
                    errorText: _isEmailEditing
                        ? _validateEmail(_emailController.text)
                        : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                    suffixIcon: _validateEmail(_emailController.text) != null
                        ? Icon(Icons.clear, color: Colors.red[900])
                        : Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (value) async {
                    await _checkEmailExists(value);
                    setState(() {
                      _isEmailEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_usernameFocusNode);
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Username',
                    icon: Icon(
                      Icons.person,
                    ),
                    errorText: _isUsernameEditing
                        ? _validateUsername(_usernameController.text)
                        : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                    suffixIcon:
                        _validateUsername(_usernameController.text) != null
                            ? Icon(Icons.clear, color: Colors.red[900])
                            : Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (value) async {
                    setState(() {
                      _isUsernameEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    _usernameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.text,
                  autofillHints: [AutofillHints.password],
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Password',
                    icon: Icon(
                      Icons.lock,
                    ),
                    errorText: _isPasswordEditing
                        ? _validatePassword(_passwordController.text)
                        : null,
                    errorStyle: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isPasswordEditing = true;
                    });
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_confirmFocusNode);
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _confirmController,
                  focusNode: _confirmFocusNode,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Confirm Password',
                    icon: Icon(
                      Icons.lock,
                    ),
                    errorText: _isConfirmEditing
                        ? _validateConfirm(_confirmController.text)
                        : null,
                    errorStyle: TextStyle(fontSize: 12, color: Colors.red),
                    suffixIcon:
                        _validateConfirm(_confirmController.text) != null
                            ? Icon(Icons.clear, color: Colors.red[900])
                            : Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isConfirmEditing = true;
                    });
                  },
                  onSubmitted: (_validateEmail(_emailController.text) == null &&
                          _validateUsername(_usernameController.text) == null &&
                          _validatePassword(_passwordController.text) == null &&
                          _validateConfirm(_confirmController.text) == null &&
                          !_isSigningUp)
                      ? (value) {
                          setState(() {
                            _isSigningUp = true;
                            _signUpStatus = '';
                            _usernameFocusNode.unfocus();
                            _emailFocusNode.unfocus();
                            _passwordFocusNode.unfocus();
                            _confirmFocusNode.unfocus();
                          });
                          _signUpRequest();
                        }
                      : null,
                ),
                SizedBox(height: 16.0),
                MaterialButton(
                  onPressed: (_validateUsername(_usernameController.text) ==
                              null &&
                          _validateEmail(_emailController.text) == null &&
                          _validatePassword(_passwordController.text) == null &&
                          _validateConfirm(_confirmController.text) == null &&
                          !_isSigningUp)
                      ? () {
                          setState(() {
                            _isSigningUp = true;
                            _signUpStatus = '';
                            _usernameFocusNode.unfocus();
                            _emailFocusNode.unfocus();
                            _passwordFocusNode.unfocus();
                            _confirmFocusNode.unfocus();
                          });
                          _signUpRequest();
                        }
                      : null,
                  elevation: 0.0,
                  minWidth: double.maxFinite,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Theme.of(context).colorScheme.secondary,
                  disabledColor: !_isSigningUp ? Colors.grey[350] : null,
                  child: !_isSigningUp
                      ? Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        )
                      : Center(child: CircularProgressIndicator()),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
