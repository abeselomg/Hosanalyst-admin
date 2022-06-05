import 'package:flutter/material.dart';
import './select_box_area.dart';
import '../../helpers/api_services.dart';
import '../../helpers/utils.dart';

class PlayerStats extends StatefulWidget {
  Map? gameData;
  PlayerStats({Key? key, this.gameData}) : super(key: key);

  @override
  State<PlayerStats> createState() => _PlayerStatsState();
}

class _PlayerStatsState extends State<PlayerStats> {
  List playerStat = [];
  bool _playerStatLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 1,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Here you can see the stats of the players.\nTime and action fields are required."),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SelectBoxArea(
                isLoading: _playerStatLoading,
                isFromTeam: false,
                teamItems: [
                  {
                    "value": widget.gameData!["home_team"]["id"],
                    "text": widget.gameData!["home_team"]["name"],
                    "logo": widget.gameData!["home_team"]["logo_link"]
                  },
                  {
                    "value": widget.gameData!["away_team"]["id"],
                    "text": widget.gameData!["away_team"]["name"],
                    "logo": widget.gameData!["away_team"]["logo_link"],
                  }
                ],
                onPressed: (value) {
                  setState(() {
                    _playerStatLoading = true;
                  });
                  getPlayerStat(
                          gameId: widget.gameData!["id"],
                          action: value["actionValue"],
                          timeStart: value["minuteValue"]["timeStart"],
                          timeEnd: value["minuteValue"]["timeEnd"],
                          teamId: value["teamValue"],
                          zone: value["zoneValue"])
                      .then((value) {
                    setState(() {
                      _playerStatLoading = false;
                    });
                    if (value != null) {
                      setState(() {
                        playerStat = value["action_count"].reversed.toList();
                      });
                    }
                  });
                }),
          ),
          Flexible(
              child: ListView.builder(
                  itemCount: playerStat.length,
                  itemBuilder: (context, index) {
                    return playerRank(context,
                        playerName: playerStat[index]["player_info"]
                            ["player_name"],
                        rank: index + 1,
                        count: playerStat[index]["action_count"],
                        teamName: playerStat[index]["team_name"],
                        teamLogo: playerStat[index]["team_logo"]);
                  }))
        ],
      ),
    );
  }

  Widget playerRank(BuildContext context,
      {String? playerName,
      int? rank,
      String? teamName,
      String? teamLogo,
      int? count = 0}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(rank.toString()),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Text(
                  playerName!,
                  overflow: TextOverflow.ellipsis,
                )),
            networkImage(teamLogo, 20, 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                teamName!.substring(0, 3),
                overflow: TextOverflow.clip,
              ),
            ),
            Text(count.toString()),
          ],
        ),
        const Divider()
      ],
    );
  }
}
