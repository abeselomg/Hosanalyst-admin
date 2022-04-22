import 'package:flutter/material.dart';
import './build_shirts.dart';

Future<dynamic> substitutionCard(context, teamLineup, playerOut, playerIn,
    teamSubstitutes, selectedPlayer, isLoadingSub, onSubstitutionSubmit) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Substitute Player",
              style: TextStyle(fontSize: 18),
            ),
            content: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.32,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: (1 / 1.5),
                    children: teamLineup
                        .map<Widget>(
                          (player) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  playerOut = player;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: buildShirts(context,
                                    player["shirt_number"], selectedPlayer,
                                    markedPlayer: playerOut),
                              )),
                        )
                        .toList(),
                  ),
                ),
                const Divider(),
                const Text(
                  "Substitutes",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.32,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: (1 / 1.5),
                    children: teamSubstitutes
                        .map<Widget>(
                          (player) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  playerIn = player;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: buildShirts(context,
                                    player["shirt_number"], selectedPlayer,
                                    markedPlayer: playerIn),
                              )),
                        )
                        .toList(),
                  ),
                ),
                isLoadingSub
                    ? CircularProgressIndicator()
                    : FlatButton(
                        onPressed: () {
                          setState(() {
                            isLoadingSub = true;
                          });
                          onSubstitutionSubmit(playerOut, playerIn);
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: Colors.green,
                      ),
              ],
            ),
          );
        });
      });
}
