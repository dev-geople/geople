import 'package:flutter/material.dart';

class FormTextfield extends StatelessWidget{
  FormTextfield({this.label, this.controller, this.isMandatory });

  final bool isMandatory;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4, bottom: 4),
      child: TextFormField(
        textAlign: TextAlign.start,
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                borderSide: BorderSide(
                    color: Colors.black54,
                    width: 1.8,
                    style: BorderStyle.solid)),
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
        validator: (value) {
          if (value.isEmpty && isMandatory) {
            return 'Dieses Feld darf nicht leer sein!'; //Todo: Übersetzung
          }
        },
      ),
    );
  }

}
