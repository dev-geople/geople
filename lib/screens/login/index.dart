import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/widgets/form_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();

  Future<FirebaseUser> _handleSignIn(String email, String password) async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password)
    ).user;
    return user;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formControllers = <String, TextEditingController>{
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();

  Widget _buildButton(Widget child) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: child,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormTextfield(
            label: AppLocalizations.of(context).translate('email_label'),
            controller: _formControllers['email'],
            isMandatory: true,
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('password_label'),
            controller: _formControllers['password'],
            isMandatory: true,
          ),
        ],
      ),
    );

    var loginButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
      onPressed: () {
        widget._handleSignIn(
            _formControllers['email'].text,
            _formControllers['password'].text
        ).then((FirebaseUser user) => print(user))
            .catchError((e) => print(e.toString()));
      },
      child: Text(AppLocalizations.of(context).translate('login_button_text')),
    );

    var registerButton = OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
      onPressed: () {
        // Todo: Register
      },
      child: Text(
          AppLocalizations.of(context).translate('create_account_button_text')),
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  /*decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      loginForm,
                      Center(
                        child: _buildButton(loginButton),
                      ),
                      Center(
                        child: _buildButton(registerButton),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
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


