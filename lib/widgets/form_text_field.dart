import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';

class FormTextfield extends StatelessWidget {
  FormTextfield({
    this.label,
    this.controller,
    this.isMandatory,
    this.icon,
    this.additionalValidation,
    this.hide,
    this.keyboardType,
  });

  final TextInputType keyboardType;
  final bool isMandatory;
  final bool hide;
  final String label;
  final TextEditingController controller;
  final Icon icon;
  final Function additionalValidation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4, bottom: 4),
      child: TextFormField(
        obscureText: hide != null ? hide : false,
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
            prefixIcon: icon,
            labelText: label,
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                    color: Colors.black54, width: 3, style: BorderStyle.solid)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.8,
                    style: BorderStyle.solid)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.black54),
            )),
        // ignore: missing_return
        validator: (value) {
          if (value.isEmpty && isMandatory) {
            return AppLocalizations.of(context).translate('error_empty');
          } else if (additionalValidation != null) {
            String _errorMessage = this.additionalValidation(value);
            return _errorMessage;
          }
        },
      ),
    );
  }
}
