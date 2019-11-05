import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/helper/validator.dart';
import 'package:geople/routes.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/user_dto.dart';
import 'package:geople/widgets/form_text_field.dart';
import 'package:geople/widgets/rounded_buttons.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formControllers = <String, TextEditingController>{
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirm-password': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Validator validator = new Validator();

    final _registerForm = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Todo: Validate!
          FormTextfield(
            label: AppLocalizations.of(context).translate('username_label'),
            isMandatory: true,
            controller: _formControllers['username'],
            icon: Icon(Icons.person),
            additionalValidation: (value) {
              if (validator.validateUsername(value)) {
                return 'Der Nutzername muss aus mindestens 5 Zeichen bestehen'; //Todo: translate
              }
            },
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('email_label'),
            isMandatory: true,
            controller: _formControllers['email'],
            icon: Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
            additionalValidation: (value) {
              if(!validator.validateEmail(value))
                return 'Invalide Emailadresse'; //Todo: translate
            },
          ),
          FormTextfield(
            label: AppLocalizations.of(context).translate('password_label'),
            isMandatory: true,
            controller: _formControllers['password'],
            icon: Icon(Icons.lock),
            hide: true,
            additionalValidation: (value) {
              if(!validator.validatePassword(value))
                return 'Passwort nicht sicher genug'; //Todo: translate
            },
          ),
          FormTextfield(
            label: AppLocalizations.of(context)
                .translate('confirm_password_label'),
            isMandatory: true,
            controller: _formControllers['confirm-password'],
            icon: Icon(Icons.lock_outline),
            hide: true,
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('register_label'),
            style: Theme.of(context).textTheme.title,
          ),
          _registerForm,
          RoundedButtonPrimary(
            translatorKey: 'create_account_button_text',
            onPressed: () {
              //Hide Keyboard
              FocusScope.of(context).requestFocus(FocusNode());
              // Register
              if (_formKey.currentState.validate()) {
                Auth _auth = Auth();
                //TODO: Validate
                _auth.signUp(
                  _formControllers['email'].text,
                  _formControllers['password'].text,
                ).then((uid) {
                  UserDTO _dao = UserDTO();
                  _dao.createUser(uid, _formControllers['username'].text).then(
                      (documentReference) =>
                          print(documentReference.toString()));
                  Navigator.of(context).pushReplacementNamed(Routes.HOME);
                }).catchError(
                        (e) => print(e.toString())); // Todo: Fehlermeldungen
              }
            },
          ),
          RoundedButtonSecondary(
            translatorKey: 'cancel_button_text',
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
