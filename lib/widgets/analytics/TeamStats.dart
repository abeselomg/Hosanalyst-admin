import 'package:flutter/material.dart';
import './select_box_area.dart';
import '../../helpers/api_services.dart';
import '../../helpers/utils.dart';

class TeamStats extends StatefulWidget {
  Map? gameData;
  TeamStats({Key? key, this.gameData}) : super(key: key);

  @override
  State<TeamStats> createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  List teamStat = [];
  List overallStat = [];
  List attackStat = [];
  List defenceStat = [];
  List disciplineStat = [];
  bool _teamStatLoading = false;

  // List of items in our dropdown menu
  getval(List actionList, element) {
    var value = actionList.firstWhere((ele) => ele['action'] == element,
        orElse: () => -1);
    if (value != -1) {
      return value['count'];
    } else {
      return 0;
    }
  }

  void clearLists() {
    overallStat.clear();
    attackStat.clear();
    defenceStat.clear();
    disciplineStat.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
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
                      "Here you can see the stats of the game.\nNo field is required."),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SelectBoxArea(
              isLoading: _teamStatLoading,
              isFromTeam: true,
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
                clearLists();
                setState(() {
                  _teamStatLoading = true;
                });
                getTeamsStat(
                        gameId: widget.gameData!["id"],
                        action: value["actionValue"],
                        timeStart: value["minuteValue"] != null
                            ? value["minuteValue"]["timeStart"]
                            : null,
                        timeEnd: value["minuteValue"] != null
                            ? value["minuteValue"]["timeEnd"]
                            : null,
                        zone: value["zoneValue"])
                    .then((value) {
                  setState(() {
                    _teamStatLoading = false;
                  });
                  if (value != null) {
                    List homeactions = value["home_team"]["actions"];
                    List awayactions = value["away_team"]["actions"];

                    Set<String> combo = Set();
                    homeactions.forEach((element) {
                      combo.add(element['action']);
                    });
                    awayactions.forEach((element) {
                      combo.add(element['action']);
                    });
                    for (var element in combo) {
                      var homeval = getval(homeactions, element);
                      var awayval = getval(awayactions, element);
                      if (overview.contains(element)) {
                        setState(() {
                          overallStat.add({
                            "action": element,
                            "home_count": homeval,
                            "away_count": awayval,
                          });
                        });
                      }
                      if (attack.contains(element)) {
                        setState(() {
                          attackStat.add({
                            "action": element,
                            "home_count": homeval,
                            "away_count": awayval,
                          });
                        });
                      }
                      if (defensive.contains(element)) {
                        setState(() {
                          defenceStat.add({
                            "action": element,
                            "home_count": homeval,
                            "away_count": awayval,
                          });
                        });
                      }
                      if (discipline.contains(element)) {
                        setState(() {
                          disciplineStat.add({
                            "action": element,
                            "home_count": homeval,
                            "away_count": awayval,
                          });
                        });
                      }
                    }
                  }
                });
              }),
        ),
        expansion(
          actionList: overallStat,
          title: "Overview",
          isExpanded: true,
        ),
        expansion(
          actionList: attackStat,
          title: "Attacking",
        ),
        expansion(
          actionList: defenceStat,
          title: "Defensive",
        ),
        expansion(
          actionList: disciplineStat,
          title: "Discipline",
        ),
      ],
    );
  }

  Widget expansion({String? title, List? actionList, bool isExpanded = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            width: 1,
          ),
        ),
        child: ExpansionTile(
          title: Text(title!,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
          initiallyExpanded: isExpanded,
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: actionList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: statRow(
                      action: actionList[index]["action"],
                      homevalue: actionList[index]["home_count"],
                      awayvalue: actionList[index]["away_count"],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Column statRow({homevalue, awayvalue, action}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(homevalue.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Expanded(
              child: Text(action,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300)),
            ),
            Text(awayvalue.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
