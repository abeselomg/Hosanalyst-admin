import 'package:flutter/material.dart';

Widget minuteTextField(BuildContext context, String label, controller) {
  return SizedBox(
    // width: MediaQuery.of(context).size.width * 0.2,
    width: 40,
    height: 30,
    child: TextField(
        controller: controller,
        maxLength: 2,

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        
        decoration: InputDecoration(
          counterText: "",
          labelText: label,
          contentPadding: const EdgeInsets.all(3),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              )),
        )),
  );
}
