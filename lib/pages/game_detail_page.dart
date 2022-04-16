import 'package:flutter/material.dart';
import '../helpers/api_services.dart';
import 'package:intl/intl.dart';
import 'game_view_page.dart';

class GameDetail extends StatefulWidget {
  int? gameId;

  GameDetail({Key? key, this.gameId}) : super(key: key);

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  List<dynamic> _homeLineupPlayers = [];
  List<dynamic> _awayLineupPlayers = [];
  List<dynamic> _homeSubPlayers = [];
  List<dynamic> _awaySubPlayers = [];

  Map<String, dynamic> _selectedTeam = {};

  Map<String, dynamic> _gameData = {};
  bool _isLoadingLineup = false;
  bool _isAwayEditing = false;
  bool _isHomeEditing = false;
  bool _isHomeSubEditing = false;
  bool _isAwaySubEditing = false;
  bool _isUpdatingStatus = false;

  int selectedkey = -1;

  final List _actionList = [
    {"event": "goal", "player": "J.Mateta", "minute": "16", "team": "home"},
    {"event": "goal", "player": "J.Ayew", "minute": "24", "team": "home"},
    {
      "event": "yellow_card",
      "player": "T.Partey",
      "minute": "53",
      "team": "away"
    },
    {
      "event": "yellow_card",
      "player": "G.Xhaka",
      "minute": "77",
      "team": "away"
    },
    {"event": "goal", "player": "J.Mateta", "minute": "16", "team": "home"},
    {"event": "goal", "player": "J.Mateta", "minute": "16", "team": "away"},
    {
      "event": "sub",
      "player1": "J.Mateta",
      "player": "J.Mateta",
      "minute": "16",
      "team": "home"
    }
  ];
  Widget _buildShirts(int shirtNumber, List playerlist) {
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
            child: playerlist
                    .any((element) => element["shirt_number"] == shirtNumber)
                ? const Icon(Icons.star, color: Colors.yellow, size: 30)
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ))
      ],
    );
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
            color: Colors.white,
            size: 18,
          )
        : event.contains('card')
            ? _yelloworredcards(event)
            : const Icon(
                Icons.compare_arrows_outlined,
                color: Colors.white,
                size: 18,
              );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGameDetail(widget.gameId).then((value) {
      setState(() {
        _gameData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: Colors.black12,
        appBar: AppBar(),
        body: _gameData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Card(
                          elevation: 3,
                          borderOnForeground: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        _gameData["home_team"]["logo_link"],
                                        height: 50,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("${_gameData["home_team"]["name"]}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "${_gameData["kick_off_time"].substring(0, 5)}",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    Text("Today",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                Expanded(
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        _gameData["away_team"]["logo_link"],
                                        height: 50,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("${_gameData["away_team"]["name"]}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          // icon: Icon(Icons.directions_bike),
                          text: "Game Info",
                        ),
                        Tab(
                          // icon: Icon(
                          //   Icons.directions_car,
                          // ),
                          text: "Set Lineup",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1.5,
                      child: TabBarView(children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              DateFormat('d MMM ,yyyy').format(
                                                  DateTime.parse(
                                                      _gameData["date"]
                                                          .substring(0, 10))),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_outline,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text("${_gameData["referee"]}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.stadium_outlined,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${_gameData["stadium"]['name']}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Center(
                              child: Text("Game Info",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "Key match events will be displayed here",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: ListView.builder(
                                  itemCount: _gameData["game_data"].length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, index) =>
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Row(
                                              children: [
                                                //Minutes
                                                Text(
                                                    _gameData["game_data"]
                                                        [index]["time"],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    )),

                                                //HOME-TEAM EVENTS
                                                _gameData["game_data"][index]
                                                            ["team"]["id"] ==
                                                        _gameData["home_team"]
                                                            ["id"]
                                                    ? Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Text(
                                                                  _gameData["game_data"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "player"]
                                                                      ["name"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                            _gameData["game_data"][index]
                                                                            [
                                                                            "team"]
                                                                        [
                                                                        "id"] ==
                                                                    _gameData[
                                                                            "home_team"]
                                                                        ["id"]
                                                                ? _eventIcons(_gameData[
                                                                            "game_data"]
                                                                        [index]
                                                                    ["action"])
                                                                : Spacer(),
                                                          ],
                                                        ),
                                                      )
                                                    : Spacer(),

                                                //SCORELINE
                                                // const Padding(
                                                //   padding: EdgeInsets.symmetric(
                                                //       horizontal: 15.0),
                                                //   child: SizedBox(
                                                //     child: Text("1-0",
                                                //         style: TextStyle(
                                                //           fontSize: 16,
                                                //           color: Colors.white,
                                                //         )),
                                                //   ),
                                                // ),

                                                //AWAY-TEAM EVENTS
                                                _gameData["game_data"][index]
                                                            ["team"]["id"] ==
                                                        _gameData["away_team"]
                                                            ["id"]
                                                    ? Expanded(
                                                        child: Row(
                                                          children: [
                                                            _gameData["game_data"][index]
                                                                            [
                                                                            "team"]
                                                                        [
                                                                        "id"] ==
                                                                    _gameData[
                                                                            "away_team"]
                                                                        ["id"]
                                                                ? _eventIcons(_gameData[
                                                                            "game_data"]
                                                                        [index]
                                                                    ["action"])
                                                                : Spacer(),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Text(
                                                                  _gameData["game_data"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "player"]
                                                                      ["name"],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Spacer(),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                            ),
                          ],
                        ),

                        // Set Lineup
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            //HOME LINEUP
                            _gameData["home_team_lineup"].isEmpty ||
                                    _isHomeEditing == true
                                ? setLineUp(
                                    context,
                                    "Set Home-Team Lineup",
                                    _homeLineupPlayers,
                                    _gameData["home_team"]["players"],
                                    1)
                                : ListTile(
                                    title: Row(
                                      children: const [
                                        Text("Home Team Lineup",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        _homeLineupPlayers =
                                            _gameData["home_team_lineup"];
                                        setState(() {
                                          _isHomeEditing = true;
                                        });
                                      },
                                      child: const Icon(Icons.edit_note_sharp,
                                          color: Colors.blueAccent, size: 30),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),

                            //AWAY LINEUP
                            _gameData["away_team_lineup"].isEmpty ||
                                    _isAwayEditing == true
                                ? setLineUp(
                                    context,
                                    "Set Away-Team Lineup",
                                    _awayLineupPlayers,
                                    _gameData["away_team"]["players"],
                                    2)
                                : ListTile(
                                    title: Row(
                                      children: const [
                                        Text("Away Team Lineup",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        _awayLineupPlayers =
                                            _gameData["away_team_lineup"];
                                        setState(() {
                                          _isAwayEditing = true;
                                        });
                                      },
                                      child: const Icon(Icons.edit_note_sharp,
                                          color: Colors.blue, size: 30),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            //HOME SUBSTITUTIONS
                            _gameData["home_team_sub"].isEmpty ||
                                    _isHomeSubEditing == true
                                ? setSubstitution(
                                    context,
                                    "Set Home-Team Substitutes",
                                    _homeSubPlayers,
                                    List.from(Set.from(
                                            _gameData["home_team"]["players"])
                                        .difference(Set.from(
                                            _gameData["home_team_lineup"]))),
                                    //  _game Data["home_team"]["players"]
                                  )
                                : ListTile(
                                    title: Row(
                                      children: const [
                                        Text("Home Team Substitutes",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        _homeSubPlayers =
                                            _gameData["home_team_sub"];
                                        setState(() {
                                          _isHomeSubEditing = true;
                                        });
                                      },
                                      child: const Icon(Icons.edit_note_sharp,
                                          color: Colors.blueAccent, size: 30),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),

                            //AWAY SUBSTITUTIONS
                            _gameData["away_team_sub"].isEmpty ||
                                    _isAwaySubEditing == true
                                ? setSubstitution(
                                    context,
                                    "Set Away-Team Substitutes",
                                    _awaySubPlayers,
                                    List.from(Set.from(
                                            _gameData["away_team"]["players"])
                                        .difference(Set.from(
                                            _gameData["away_team_lineup"]))),
                                    // _gameData["away_team"]["players"]
                                  )
                                : ListTile(
                                    title: Row(
                                      children: const [
                                        Text("Away Team Substitutes",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                        Spacer(),
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        _awaySubPlayers =
                                            _gameData["away_team_sub"];
                                        setState(() {
                                          _isAwaySubEditing = true;
                                        });
                                      },
                                      child: const Icon(Icons.edit_note_sharp,
                                          color: Colors.blueAccent, size: 30),
                                    ),
                                  ),

                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                selectTeamMethod("home_team"),
                                selectTeamMethod("away_team"),
                              ],
                            ),
                            _isUpdatingStatus
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Align(
                                    child: SizedBox(
                                      width: 120,
                                      child: TextButton(
                                          onPressed: () {
                                            _gameData["away_team_sub"]
                                                        .isNotEmpty &&
                                                    _gameData["home_team_sub"]
                                                        .isNotEmpty &&
                                                    _gameData[
                                                            "home_team_lineup"]
                                                        .isNotEmpty &&
                                                    _gameData[
                                                            "away_team_lineup"]
                                                        .isNotEmpty &&
                                                    _selectedTeam.isNotEmpty
                                                ? {
                                                    setState(() {
                                                      _isUpdatingStatus = true;
                                                    }),
                                                    updateGameStatus(
                                                      widget.gameId,
                                                      "live",
                                                    ).then((value) {
                                                      if (value != null) {
                                                        setState(() {
                                                          _isUpdatingStatus =
                                                              false;
                                                        });
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                GameViewPage(
                                                              gameDetail:
                                                                  _gameData,
                                                              selectedTeam:
                                                                  _selectedTeam,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    })
                                                  }
                                                : null;
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                            _gameData["away_team_sub"]
                                                        .isNotEmpty &&
                                                    _gameData["home_team_sub"]
                                                        .isNotEmpty &&
                                                    _gameData[
                                                            "home_team_lineup"]
                                                        .isNotEmpty &&
                                                    _gameData[
                                                            "away_team_lineup"]
                                                        .isNotEmpty &&
                                                    _selectedTeam.isNotEmpty
                                                ? Colors.green
                                                : Colors.grey,
                                          )),
                                          child: const Text("Start Game",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ))),
                                    ),
                                  )
                          ],
                        )
                      ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  GestureDetector selectTeamMethod(String team) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTeam = _gameData[team];
        });
      },
      child: Stack(
        children: [
          Card(
            child: Text(_gameData[team]["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: _selectedTeam['id'] == _gameData[team]["id"]
                  ? const Icon(Icons.check_circle,
                      color: Colors.green, size: 18)
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ))
        ],
      ),
    );
  }

  Padding setLineUp(BuildContext context, String boxtext, List lineuplist,
      List players, expanedKey) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: ExpansionTile(
            key: Key(expanedKey.toString()),
            initiallyExpanded: expanedKey == selectedkey ? true : false,
            title: Text(boxtext,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
            onExpansionChanged: (value) {
              value
                  ? setState(() {
                      selectedkey = expanedKey;
                    })
                  : setState(() {
                      selectedkey = -1;
                    });
            },
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
                            child:
                                _buildShirts(data['shirt_number'], lineuplist),
                          )),
                    )
                    .toList(),
              ),
              lineuplist.length == 11
                  ? Align(
                      child: SizedBox(
                        width: 120,
                        child: _isLoadingLineup
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  String field;
                                  if (lineuplist == _homeLineupPlayers) {
                                    field = 'homeTeamLineup';
                                  } else {
                                    field = 'awayTeamLineup';
                                  }
                                  setState(() {
                                    _isLoadingLineup = true;
                                  });
                                  updateLineup(widget.gameId, field, lineuplist)
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _gameData = value;
                                      });
                                      lineuplist == _homeLineupPlayers
                                          ? setState(() {
                                              _isHomeEditing = false;
                                            })
                                          : setState(() {
                                              _isAwayEditing = false;
                                            });
                                    }
                                    setState(() {
                                      _isLoadingLineup = false;
                                    });
                                  });
                                },
                                // color: Colors.green,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                child: const Text("Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    )),
                              ),
                      ),
                    )
                  : Container(),
            ]),
      ),
    );
  }

  Widget setSubstitution(BuildContext context, String boxtext,
      List substitutionlist, List subplayers) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: ExpansionTile(
            title: Text(boxtext,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                crossAxisCount: 5,
                childAspectRatio: (1 / 1.5),
                children: subplayers
                    .map(
                      (data) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (substitutionlist.any(
                                  (element) => element["id"] == data["id"])) {
                                substitutionlist.removeWhere(
                                    (element) => element["id"] == data["id"]);
                              } else {
                                substitutionlist.add(data);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _buildShirts(
                                data['shirt_number'], substitutionlist),
                          )),
                    )
                    .toList(),
              ),
              substitutionlist.length > 6
                  ? Align(
                      child: SizedBox(
                        width: 120,
                        child: _isLoadingLineup
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  String field;
                                  if (substitutionlist == _homeSubPlayers) {
                                    // homeTeamSubs
                                    // awayTeamSubs
                                    field = 'homeTeamSubs';
                                  } else {
                                    field = 'awayTeamSubs';
                                  }
                                  setState(() {
                                    _isLoadingLineup = true;
                                  });
                                  updateLineup(widget.gameId, field,
                                          substitutionlist)
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _gameData = value;
                                        _isHomeSubEditing = false;
                                        _isAwaySubEditing = false;
                                      });
                                    }
                                    setState(() {
                                      _isLoadingLineup = false;
                                    });
                                  });
                                },
                                // color: Colors.green,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                child: const Text("Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    )),
                              ),
                      ),
                    )
                  : Container(),
            ]),
      ),
    );
  }
}
