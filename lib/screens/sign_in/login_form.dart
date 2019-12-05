import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/repositories/firebase/user_repository.dart';
import 'package:geople/router.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/widgets/form_text_field.dart';
import 'package:geople/widgets/rounded_buttons.dart';

class LoginForm extends StatefulWidget {
  final Auth _auth = Auth();

  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formControllers = <String, TextEditingController>{
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Todo: Validate
    final _loginForm = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormTextfield(
            label: AppLocalizations.of(context).translate('email_label'),
            controller: _formControllers['email'],
            isMandatory: true,
            keyboardType: TextInputType.emailAddress,
            icon: Icon(Icons.email),
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('password_label'),
            controller: _formControllers['password'],
            isMandatory: true,
            icon: Icon(Icons.lock),
            hide: true,
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      /*decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),*/
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('login_label'),
            style: Theme.of(context).textTheme.title,
          ),
          _loginForm,
          Center(
            child: RoundedButtonPrimary(
              translatorKey: 'login_button_text',
              onPressed: () {
                //Hide Keyboard
                FocusScope.of(context).requestFocus(FocusNode());
                // Validation
                if (_formKey.currentState.validate()) {
                  //Sign in
                  widget._auth
                      .signIn(_formControllers['email'].text,
                          _formControllers['password'].text)
                      .then((uid) async {
                    if (uid != null) {
                      UserDTO _dto = UserDTO();
                      FirebaseMessaging _messager = FirebaseMessaging();
                      _dto.saveToken(uid, await _messager.getToken());
                      Navigator.of(context).popAndPushNamed(Routes.HOME);
                    }
                  }).catchError(
                          (e) => print(e.toString())); // Todo: Fehlermeldungen
                }
              },
            ),
          ),
          Center(
            child: RoundedButtonSecondary(
              translatorKey: 'create_account_button_text',
              onPressed: () => Navigator.of(context).pushNamed(Routes.SIGN_UP),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _formControllers.forEach((key, value) {
      _formControllers[key].dispose(); // Controller wieder leeren.
    });
    super.dispose();
  }
}
