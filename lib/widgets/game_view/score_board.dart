import 'package:flutter/material.dart';
import 'score_input.dart';

  Future<dynamic> setScoreBoard(
    context,
    TextEditingController hometxtcontroller, awaytxtcontroller, gameDetail, onUpdateScoreBoard) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Set half time score"),
            actions: [
              FlatButton(
                child: Text("Submit"),
                onPressed: () {
                  
                  onUpdateScoreBoard(hometxtcontroller,awaytxtcontroller);
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                children: [
                  scoreInput(
                      gameDetail["home_team"]["logo_link"],
                      gameDetail["home_team"]["name"],
                      hometxtcontroller),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  scoreInput(
                      gameDetail["away_team"]["logo_link"],
                      gameDetail["away_team"]["name"],
                      awaytxtcontroller),
                ],
              ),
            ),
          );
        });
      });
}
