import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/widgets/form_text_field.dart';
import 'package:geople/widgets/rounded_buttons.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/user_dao.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formControllers = <String, TextEditingController>{
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirm-password': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Todo: Validate
    final _registerForm = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormTextfield(
            label: AppLocalizations.of(context).translate('username_label'),
            isMandatory: true,
            controller: _formControllers['username'],
            icon: Icon(Icons.person),
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('email_label'),
            isMandatory: true,
            controller: _formControllers['email'],
            icon: Icon(Icons.email),
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('password_label'),
            isMandatory: true,
            controller: _formControllers['password'],
            icon: Icon(Icons.lock),
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('confirm_password_label'),
            isMandatory: true,
            controller: _formControllers['confirm-password'],
            icon: Icon(Icons.lock_outline),
          ),
        ],
      ),
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: <Widget>[
                  _registerForm,
                  RoundedButtonPrimary(
                    translatorKey: 'create_account_button_text',
                    onPressed: () {
                      //Hide Keyboard
                      FocusScope.of(context).requestFocus(FocusNode());
                      // Register
                      Auth _auth = Auth();
                      _auth.signUp(
                        // Todo: Validate!
                          _formControllers['email'].text,
                          _formControllers['password'].text,
                      ).then((uid) {
                        UserDAO _dao = UserDAO();
                        _dao.createUser(uid, _formControllers['username'].text);
                      }).catchError((e) => print(e.toString()));  // Todo: Fehlermeldungen
                    },
                  ),
                  RoundedButtonSecondary(
                    translatorKey: 'cancel_button_text',
                    // Todo: Cancel Registration
                    onPressed: () => print('cancel'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
