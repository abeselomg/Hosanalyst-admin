import 'package:flutter/material.dart';

ListView matchEvents(gameData) {
  return ListView.builder(
      itemCount: gameData["game_data"].length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, index) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    //Minutes
                    Text(
                        gameData["game_data"][index]["time"].contains("+")
                            ? gameData["game_data"][index]["time"]
                                    .split("+")[0]
                                    .substring(0, 2) +
                                "+" +
                                int.parse(gameData["game_data"][index]["time"]
                                        .split("+")[1]
                                        .substring(0, 3))
                                    .toString() +
                                "'"
                            : gameData["game_data"][index]["time"]
                                    .substring(0, 2) +
                                "'",
                        style: const TextStyle(
                          fontSize: 16,
                        )),

                    //HOME-TEAM EVENTS
                    gameData["game_data"][index]["team"]["id"] ==
                            gameData["home_team"]["id"]
                        ? Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                      gameData["game_data"][index]["player"]
                                          ["name"],
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      )),
                                ),
                                gameData["game_data"][index]["team"]["id"] ==
                                        gameData["home_team"]["id"]
                                    ? _eventIcons(
                                        gameData["game_data"][index]["action"])
                                    : Spacer(),
                              ],
                            ),
                          )
                        : const Spacer(),

                    //AWAY-TEAM EVENTS
                    gameData["game_data"][index]["team"]["id"] ==
                            gameData["away_team"]["id"]
                        ? Expanded(
                            child: Row(
                              children: [
                                gameData["game_data"][index]["team"]["id"] ==
                                        gameData["away_team"]["id"]
                                    ? _eventIcons(
                                        gameData["game_data"][index]["action"])
                                    : Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                      gameData["game_data"][index]["player"]
                                          ["name"],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      )),
                                ),
                              ],
                            ),
                          )
                        : Spacer(),
                  ],
                ),
              ),
              const Divider(),
            ],
          ));
}

Widget _yelloworredcards(cardcolor) {
  return Container(
    width: 13,
    height: 18,
    decoration: BoxDecoration(
      color: cardcolor.contains("red") ? Colors.red[900] : Colors.amber[700],
      borderRadius: const BorderRadius.all(Radius.circular(3)),
    ),
  );
}

Widget _eventIcons(String event) {
  return event.contains("goal")
      ? const Icon(
          Icons.sports_soccer,
          size: 18,
        )
      : event.contains('card')
          ? _yelloworredcards(event)
          : const Icon(
              Icons.compare_arrows_outlined,
              size: 18,
            );
}
