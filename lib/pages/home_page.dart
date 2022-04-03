import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  static const items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final ScrollController _firstController = ScrollController();
  var _selectedActionType = "Attack";
  var selectedAction = "";
  int? selectedPlayer;
  String? _chosenValue = "Man Utd";
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
    "Total shotsFree kick",
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

  Widget _buildShirts(var shirtNumber) {
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
        const Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.star, color: Colors.yellow, size: 30))
      ],
    );
  }

  Widget _buildActionCards(List<dynamic> actionarr) {
    return GridView.count(
      crossAxisCount: 5,
      childAspectRatio: (1 / 1.5),
      children: actionarr
          .map(
            (data) => GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Text(
                      "$data",
                    ),
                  ),
                )),
          )
          .toList(),
    );
  }

  Future<dynamic> dialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    selectedPlayer != null || selectedAction != ''
                        ? Row(
                            children: [
                              Text(selectedAction),
                              Text(" by "),
                              Text(selectedPlayer.toString())
                            ],
                          )
                        : Container(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.lightGreen,
                          child: ListView.builder(
                            itemCount: players.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPlayer =
                                        players[index]["shirtNumber"];
                                  });
                                },
                                child: ListTile(
                                  title:
                                      Text("${players[index]["shirtNumber"]}"),
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedActionType = "Attack";
                                      });
                                    },
                                    child: Card(
                                        child: Text(
                                      "Att",
                                      style: TextStyle(
                                          fontSize:
                                              _selectedActionType == "Attack"
                                                  ? 20
                                                  : 14,
                                          color: _selectedActionType == "Attack"
                                              ? Colors.greenAccent
                                              : Colors.black),
                                    ))),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedActionType = "Defence";
                                    });
                                  },
                                  child: Card(
                                      child: Text("Def",
                                          style: TextStyle(
                                              fontSize: _selectedActionType ==
                                                      "Defence"
                                                  ? 20
                                                  : 14,
                                              color: _selectedActionType ==
                                                      "Defence"
                                                  ? Colors.greenAccent
                                                  : Colors.black))),
                                ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: _selectedActionType == "Attack"
                                  ? Scrollbar(
                                      controller: _firstController,
                                      isAlwaysShown: true,
                                      child: ListView.builder(
                                        controller: _firstController,
                                        itemCount: attackActions.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAction =
                                                    attackActions[index];
                                              });
                                            },
                                            child: ListTile(
                                              title: Text(
                                                  "${attackActions[index]}"),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Scrollbar(
                                      controller: _firstController,
                                      isAlwaysShown: true,
                                      child: ListView.builder(
                                        controller: _firstController,
                                        itemCount: defenceActions.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAction =
                                                    defenceActions[index];
                                              });
                                            },
                                            child: ListTile(
                                              title: Text(
                                                  "${defenceActions[index]}"),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          print(selectedAction);
                          print(selectedPlayer);
                          Navigator.pop(context);
                        },
                        child: Text("Submit"))
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<dynamic> simpledialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.all(15),
              content: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        crossAxisCount: 5,
                        childAspectRatio: (1 / 1.5),
                        children: players
                            .map(
                              (data) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPlayer = data["shirtNumber"];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: _buildShirts(data["shirtNumber"]),
                                  )),
                            )
                            .toList(),
                      ),
                    ),
                    Row(
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
                                          color: _selectedActionType == 'Attack'
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: _selectedActionType == "Attack"
                          ? _buildActionCards(attackActions)
                          : _buildActionCards(defenceActions),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 3;
    double cardHeight = MediaQuery.of(context).size.height / 4.3;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
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
                  vertical: 0.03324468085 * MediaQuery.of(context).size.height,
                  horizontal: 0.025 * MediaQuery.of(context).size.width),
              children: items
                  .map(
                    (data) => GestureDetector(
                        onTap: () {
                          // dialog();
                          simpledialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            border: Border(
                              right:
                                  BorderSide(width: 1, color: Colors.white70),
                              left: BorderSide(width: 1, color: Colors.white70),
                              top: BorderSide(width: 1, color: Colors.white70),
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
          ],
        ),
      ),
    );
  }
}
