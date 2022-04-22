import 'package:flutter/material.dart';
import '../../helpers/utils.dart';


  Row scoreInput(image, teamName, TextEditingController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Expanded(
        child: Row(
          children: [
            networkImage(
              image,
              20,
              20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              teamName,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
      SizedBox(
        width: 27,
        height: 30,
        child: TextField(
            controller: controller..text = '0',
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(3),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  )),
            )),
      )
    ],
  );
}
