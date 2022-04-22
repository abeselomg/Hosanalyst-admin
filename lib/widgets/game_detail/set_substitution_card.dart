import 'package:flutter/material.dart';
import 'build_shirts.dart';

Widget setSubstitution(
    BuildContext context,
    String boxtext,
    List substitutionlist,
    List subplayers,
    setState,
    onUpdateSubstitution,
    isLoadingLineup) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
        ),
      ),
      child: ExpansionTile(
          title: Text(boxtext,
              style: const TextStyle(
                fontSize: 20,
              )),
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              crossAxisCount: 5,
              childAspectRatio: (1 / 1.5),
              children: subplayers
                  .map(
                    (data) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (substitutionlist.any(
                                (element) => element["id"] == data["id"])) {
                              substitutionlist.removeWhere(
                                  (element) => element["id"] == data["id"]);
                            } else {
                              substitutionlist.add(data);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: buildShirts(
                              context, data['shirt_number'], substitutionlist),
                        )),
                  )
                  .toList(),
            ),
            substitutionlist.length > 6
                ? Align(
                    child: SizedBox(
                      width: 120,
                      child: isLoadingLineup
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(),
                            ))
                          : TextButton(
                              onPressed: () {
                                onUpdateSubstitution(substitutionlist);
                              },
                              // color: Colors.green,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green)),
                              child: const Text("Submit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                            ),
                    ),
                  )
                : Container(),
          ]),
    ),
  );
}
