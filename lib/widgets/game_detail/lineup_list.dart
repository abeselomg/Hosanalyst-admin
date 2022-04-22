import 'package:flutter/material.dart';


Padding shirtNumandName(element) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(element["shirt_number"].toString(),
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ),
      const SizedBox(width: 5),
      Text(element["name"],
          textAlign: TextAlign.left, style: const TextStyle(fontSize: 12)),
    ]),
  );
}

Widget lineupList(gameData) {
  List<Widget> homeLineup = [];
  List<Widget> awayLineup = [];
  List<Widget> homeSub = [];
  List<Widget> awaySub = [];

  gameData["home_team_lineup"].forEach((element) {
    homeLineup.add(
      shirtNumandName(element),
    );
  });

  gameData["away_team_lineup"].forEach((element) {
    awayLineup.add(
      shirtNumandName(element),
    );
  });

  gameData["away_team_sub"].forEach((element) {
    awaySub.add(
      shirtNumandName(element),
    );
  });

  gameData["home_team_sub"].forEach((element) {
    homeSub.add(
      shirtNumandName(element),
    );
  });

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 2,
              color: Colors.green,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: homeLineup,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                  children: awayLineup,
                  crossAxisAlignment: CrossAxisAlignment.end,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text("Substitutes", style: TextStyle(fontSize: 16)),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 2,
              color: Colors.green,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: homeSub,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                  children: awaySub,
                  crossAxisAlignment: CrossAxisAlignment.end,
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
