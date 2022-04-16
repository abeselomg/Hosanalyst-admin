import 'dart:async';

import 'package:flutter/material.dart';
import '../helpers/utils.dart';

class GameViewPage extends StatefulWidget {
  Map<String, dynamic>? gameDetail;
  Map<String, dynamic>? selectedTeam;

  GameViewPage({Key? key, this.gameDetail, this.selectedTeam})
      : super(key: key);

  @override
  State<GameViewPage> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage>
    with TickerProviderStateMixin {
  Duration duration = Duration();
  Timer? timer;

  static const items = [2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final ScrollController _firstController = ScrollController();
  var _selectedActionType = "Attack";
  var selectedAction = "";
  Map selectedPlayer = {};
  Map<String, dynamic> _teamData = {};
  bool _isOnAddTime = false;
  List players = [
    {"name": "de gea", "shirtNumber": 1},
    {"name": "lindelof", "shirtNumber": 2},
    {"name": "varane", "shirtNumber": 19},
    {"name": "telles", "shirtNumber": 27},
    {"name": "dalot", "shirtNumber": 20},
    {"name": "fred", "shirtNumber": 17},
    {"name": "pogba", "shirtNumber": 6},
    {"name": "fernandes", "shirtNumber": 18},
    {"name": "rashford", "shirtNumber": 10},
    {"name": "sancho", "shirtNumber": 21},
    {"name": "ronaldo", "shirtNumber": 7},
  ];

  List man_city_players = [
    {"name": "de gea", "shirtNumber": 30},
    {"name": "lindelof", "shirtNumber": 27},
    {"name": "varane", "shirtNumber": 14},
    {"name": "telles", "shirtNumber": 5},
    {"name": "dalot", "shirtNumber": 2},
    {"name": "fred", "shirtNumber": 17},
    {"name": "pogba", "shirtNumber": 16},
    {"name": "fernandes", "shirtNumber": 20},
    {"name": "rashford", "shirtNumber": 10},
    {"name": "sancho", "shirtNumber": 26},
    {"name": "ronaldo", "shirtNumber": 47},
  ];

  List attackActions = [
    "Short Pass",
    "Long Pass",
    "Dribbles",
    "Assists",
    "Crosses",
    "Goals Scored",
    "Headers on target",
    "Total shots",
    "Free kick",
    "Fouls received",
    "Corners",
    "Shots on target",
    "Shots off target ",
    "Off-sides committed ",
  ];

  List defenceActions = [
    "Tackles lost",
    "Tackles won",
    "Interceptions of long pass",
    "Interceptions of short pass",
    "Clearance",
    "Crosses against ",
    "Corners against ",
    "Headers won",
    "Headers lost",
    "Off-sides received ",
    "Shots on target received",
    "Shots off target received",
    "Goals conceded",
    "Free Kick conceded",
    "Penalties conceded",
    "Defensive moves ",
    "Body checks",
    "Yellow cards",
    "Red cards",
  ];

  Widget _buildShirts(
    var shirtNumber,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Shirt-1.png"),
              fit: BoxFit.none,
            ),
          ),
        ),
        Text(
          shirtNumber.toString(),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration: TextDecoration.none),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: selectedPlayer["shirt_number"] == shirtNumber
                ? const Icon(Icons.star, color: Colors.yellow, size: 30)
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ))
      ],
    );
  }

  Widget _buildActionCards(List<dynamic> actionarr, Function setState) {
    return GridView.count(
      controller: _firstController,
      crossAxisCount: 3,
      childAspectRatio: (1 / 0.55),
      children: actionarr
          .map(
            (data) => Stack(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAction = data;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "$data",
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    top: 0,
                    right: 0,
                    child: selectedAction == data
                        ? const Icon(Icons.star, color: Colors.yellow, size: 25)
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ))
              ],
            ),
          )
          .toList(),
    );
  }

  Future<dynamic> simpledialog(zone) {
    print(zone);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.all(20),
              content: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Select Player",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        crossAxisCount: 5,
                        childAspectRatio: (1 / 1.5),
                        children: _teamData["players"]
                            .map<Widget>(
                              (player) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPlayer = player;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: _buildShirts(player["shirt_number"]),
                                  )),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedActionType = "Attack";
                                });
                              },
                              child: Container(
                                  height: 30,
                                  // width: 50,
                                  decoration: BoxDecoration(
                                    color: _selectedActionType == 'Attack'
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text("Attack",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                _selectedActionType == 'Attack'
                                                    ? Colors.white
                                                    : Colors.black)),
                                  )),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedActionType = "Defence";
                                });
                              },
                              child: Container(
                                  height: 30,
                                  // width: 50,
                                  decoration: BoxDecoration(
                                    color: _selectedActionType == 'Defence'
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text("Defence",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                _selectedActionType == 'Defence'
                                                    ? Colors.white
                                                    : Colors.black)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: Scrollbar(
                        controller: _firstController,
                        isAlwaysShown: true,
                        child: _selectedActionType == "Attack"
                            ? _buildActionCards(attackActions, setState)
                            : _buildActionCards(defenceActions, setState),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          showSnackBar(context, "message");
                          selectedPlayer = {};
                          selectedAction = "";
                          Navigator.pop(context);
                          print(selectedPlayer);
                          print(widget.selectedTeam);
                          print(selectedAction);
                          print(zone);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _teamData = widget.selectedTeam!;

    starttimer();
  }

  void addtimer() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void starttimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addtimer());
  }

  void stoptimer() {
    setState(() {
      duration = Duration();
      timer!.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 3;
    double cardHeight = MediaQuery.of(context).size.height / 4.3;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/Soccer_Field_Transparant.svg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (cardWidth / cardHeight),
                padding: EdgeInsets.symmetric(
                    vertical:
                        0.03324468085 * MediaQuery.of(context).size.height,
                    horizontal: 0.025 * MediaQuery.of(context).size.width),
                children: items.reversed
                    .map(
                      (data) => GestureDetector(
                          onTap: () {
                            // dialog();
                            simpledialog(data);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                              border: Border(
                                right:
                                    BorderSide(width: 1, color: Colors.white70),
                                left:
                                    BorderSide(width: 1, color: Colors.white70),
                                top:
                                    BorderSide(width: 1, color: Colors.white70),
                                bottom:
                                    BorderSide(width: 1, color: Colors.white70),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                data.toString(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white54),
                              ),
                            ),
                          )),
                    )
                    .toList(),
              ),
              Align(
                  alignment: Alignment(-0.9, -0.9),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(blurRadius: 4)]),
                        child: Center(
                            child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 24,
                        ))),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildTimer()],
              ),
              FlatButton(onPressed: () {}, child: Text("ghgh"))
            ],
          ),
        ),
      ),
    );
  }

  Text buildTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      "$minutes:$seconds",
      style: TextStyle(color: Colors.black, fontSize: 20),
    );
  }
}
