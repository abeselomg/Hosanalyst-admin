import 'package:flutter/material.dart';
import './select_box_area.dart';
import '../../helpers/api_services.dart';
import './drop_down.dart';
import '../../helpers/utils.dart';

class PlayerDetail extends StatefulWidget {
  Map? gameData;
  PlayerDetail({Key? key, this.gameData}) : super(key: key);

  @override
  State<PlayerDetail> createState() => _PlayerDetailState();
}

class _PlayerDetailState extends State<PlayerDetail> {
  bool _playerDetailLoading = false;
  List playerDetail = [];
  List overallStat = [];
  List attackStat = [];
  List defenceStat = [];
  List disciplineStat = [];
  dynamic playerId;

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
  void initState() {
    // TODO: implement initState
    super.initState();

    playerDetail = [...playerDetail, ...widget.gameData?['home_team_lineup']];
    playerDetail = [...playerDetail, ...widget.gameData?['away_team_lineup']];
    playerDetail = [...playerDetail, ...widget.gameData?['home_team_sub']];
    playerDetail = [...playerDetail, ...widget.gameData?['away_team_sub']];
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
                      "Here you can see the detail of the player.\nPlayer field is required."),
                ],
              )),
        ),
        DropDown(
            onChanged: (value) {
              setState(() {
                playerId = value;
              });
            },
            width: MediaQuery.of(context).size.width * 0.90,
            items: playerDetail
                .map((e) => {"value": e["id"], "text": e["name"]})
                .toList(),
            label: "Select Player"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SelectBoxArea(
              isLoading: _playerDetailLoading,
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
                  _playerDetailLoading = true;
                });
                getPlayerDetail(
                        gameId: widget.gameData!["id"],
                        playerId: playerId,
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
                    _playerDetailLoading = false;
                  });
                  if (value != null) {
                    List actions = value["actions"];
                    
                    for (var element in actions) {
                      if (playeroverview.contains(element["action"])) {
                        setState(() {
                          overallStat.add(element);
                        });
                      }
                      if (attack.contains(element["action"])) {
                        setState(() {
                          attackStat.add(element);
                        });
                      }
                      if (defensive.contains(element["action"])) {
                        setState(() {
                          defenceStat.add(element);
                        });
                      }
                      if (discipline.contains(element["action"])) {
                        setState(() {
                          disciplineStat.add(element);
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
                      teamvalue: actionList[index]["count"],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Column statRow({teamvalue, action}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(action,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w300)),
            Text(teamvalue.toString(),
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
