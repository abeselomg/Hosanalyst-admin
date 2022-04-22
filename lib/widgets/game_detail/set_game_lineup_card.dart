import 'package:flutter/material.dart';
import './build_shirts.dart';

Padding setLineUp(BuildContext context, String boxtext, List lineuplist,
    List players, setState, onSetLineupPressed, isLoadingLineup) {
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
              children: players
                  .map(
                    (data) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (lineuplist.any(
                                (element) => element["id"] == data["id"])) {
                              lineuplist.removeWhere(
                                  (element) => element["id"] == data["id"]);
                            } else {
                              lineuplist.add(data);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: buildShirts(
                              context, data['shirt_number'], lineuplist),
                        )),
                  )
                  .toList(),
            ),
            lineuplist.length == 11
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
                                onSetLineupPressed(lineuplist);
                              },
                              // color: Colors.green,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green)),
                              child: const Text("Submit",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ),
                    ),
                  )
                : Container(),
          ]),
    ),
  );
}
