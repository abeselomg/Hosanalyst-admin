import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_view_page.dart';
import '../helpers/api_services.dart';
import '../helpers/utils.dart';
import '../widgets/game_detail/match_events.dart';
import '../widgets/game_detail/game_info_card.dart';
import '../widgets/game_detail/set_game_lineup_card.dart';
import '../widgets/game_detail/set_substitution_card.dart';
import '../widgets/game_detail/lineup_list.dart';
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

  void onUpdateLineup(lineuplist) {
    String field;
    if (lineuplist == _homeLineupPlayers) {
      field = 'homeTeamLineup';
    } else {
      field = 'awayTeamLineup';
    }
    setState(() {
      _isLoadingLineup = true;
    });
    updateLineup(widget.gameId, field, lineuplist).then((value) {
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
  }

  void onUpdateSubstitution(substitutionlist) {
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
    updateLineup(widget.gameId, field, substitutionlist).then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        )),
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
                                      networkImage(
                                        _gameData["home_team"]["logo_link"],
                                        50,
                                        50,
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
                                _gameData["status"] == "completed"
                                    ? Row(
                                        children: [
                                          //
                                          Text(
                                              "${_gameData["full_time_home_score"]}",
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                          const Text(" - "),
                                          Text(
                                              "${_gameData["full_time_away_score"]}",
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                              "${_gameData["kick_off_time"].substring(0, 5)}",
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "${DateFormat("dd MMM y").format(DateTime.parse(_gameData["date"]))}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                Expanded(
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  child: Column(
                                    children: [
                                      networkImage(
                                        _gameData["away_team"]["logo_link"],
                                        50,
                                        50,
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
                    TabBar(
                      isScrollable: true,
                      labelColor: Theme.of(context).accentColor,
                      tabs: const [
                        Tab(
                          text: "Game Info",
                        ),
                        Tab(
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
                            gameInfoCard(context, _gameData),
                            const SizedBox(
                              height: 20,
                            ),
                            const Center(
                              child: Text("Game Info",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                "Key match events will be displayed here",
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: matchEvents(_gameData),
                            ),
                          ],
                        ),

                        // Set Lineup
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _gameData["status"] != "upcoming"
                                ? lineupList(_gameData)
                                : Column(children: [
                                    //HOME LINEUP
                                    _gameData["home_team_lineup"].isEmpty ||
                                            _isHomeEditing == true
                                        ? setLineUp(
                                            context,
                                            "Set Home-Team Lineup",
                                            _homeLineupPlayers,
                                            _gameData["home_team"]["players"],
                                            setState,
                                            onUpdateLineup,
                                            _isLoadingLineup)
                                        : ListTile(
                                            title: Row(
                                              children: const [
                                                Text("Home Team Lineup",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                                Spacer(),
                                                Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20),
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () {
                                                _homeLineupPlayers = _gameData[
                                                    "home_team_lineup"];
                                                setState(() {
                                                  _isHomeEditing = true;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.edit_note_sharp,
                                                  color: Colors.blueAccent,
                                                  size: 30),
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
                                            setState,
                                            onUpdateLineup,
                                            _isLoadingLineup)
                                        : ListTile(
                                            title: Row(
                                              children: const [
                                                Text("Away Team Lineup",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                                Spacer(),
                                                Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20),
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () {
                                                _awayLineupPlayers = _gameData[
                                                    "away_team_lineup"];
                                                setState(() {
                                                  _isAwayEditing = true;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.edit_note_sharp,
                                                  color: Colors.blue,
                                                  size: 30),
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
                                            _gameData["home_team"]["players"]
                                                .where((o1) => !_gameData[
                                                        "home_team_lineup"]
                                                    .any((o2) =>
                                                        o1["id"] == o2["id"]))
                                                .toList(),
                                            setState,
                                            onUpdateSubstitution,
                                            _isLoadingLineup)
                                        : ListTile(
                                            title: Row(
                                              children: const [
                                                Text("Home Team Substitutes",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                                Spacer(),
                                                Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20),
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
                                              child: const Icon(
                                                  Icons.edit_note_sharp,
                                                  color: Colors.blueAccent,
                                                  size: 30),
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
                                            _gameData["away_team"]["players"]
                                                .where((o1) => !_gameData[
                                                        "away_team_lineup"]
                                                    .any((o2) =>
                                                        o1["id"] == o2["id"]))
                                                .toList(),
                                            setState,
                                            onUpdateSubstitution,
                                            _isLoadingLineup)
                                        : ListTile(
                                            title: Row(
                                              children: const [
                                                Text("Away Team Substitutes",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                                Spacer(),
                                                Icon(Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20),
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
                                              child: const Icon(
                                                  Icons.edit_note_sharp,
                                                  color: Colors.blueAccent,
                                                  size: 30),
                                            ),
                                          ),
                                  ]),
                            const SizedBox(
                              height: 30,
                            ),
                            _gameData["status"] == "completed"
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      selectTeamMethod("home_team"),
                                      selectTeamMethod("away_team"),
                                    ],
                                  ),
                            _gameData["status"] == "completed"
                                ? const SizedBox()
                                : Container(
                                    child: _isUpdatingStatus
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                            child: Align(
                                              child: SizedBox(
                                                width: 120,
                                                child: TextButton(
                                                    onPressed: () {
                                                      _gameData[
                                                                      "away_team_sub"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "home_team_sub"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "home_team_lineup"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "away_team_lineup"]
                                                                  .isNotEmpty &&
                                                              _selectedTeam
                                                                  .isNotEmpty
                                                          ? {
                                                              if (_gameData[
                                                                      "status"] ==
                                                                  "upcoming")
                                                                {
                                                                  setState(() {
                                                                    _isUpdatingStatus =
                                                                        true;
                                                                  }),
                                                                  updateGameStatus(
                                                                    widget
                                                                        .gameId,
                                                                    "live",
                                                                  ).then(
                                                                      (value) {
                                                                    if (value !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        _isUpdatingStatus =
                                                                            false;
                                                                      });
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              GameViewPage(
                                                                            gameDetail:
                                                                                _gameData,
                                                                            selectedTeam:
                                                                                _selectedTeam,
                                                                            onGameDetailChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                _gameData = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  })
                                                                }
                                                              else
                                                                {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              GameViewPage(
                                                                        gameDetail:
                                                                            _gameData,
                                                                        selectedTeam:
                                                                            _selectedTeam,
                                                                        onGameDetailChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            _gameData =
                                                                                value;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  )
                                                                }
                                                            }
                                                          : null;
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                      _gameData[
                                                                      "away_team_sub"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "home_team_sub"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "home_team_lineup"]
                                                                  .isNotEmpty &&
                                                              _gameData[
                                                                      "away_team_lineup"]
                                                                  .isNotEmpty &&
                                                              _selectedTeam
                                                                  .isNotEmpty
                                                          ? Colors.green
                                                          : Colors.grey,
                                                    )),
                                                    child: const Text(
                                                        "Start Game",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
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
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border:
                    Border.all(width: 2, color: Theme.of(context).accentColor)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_gameData[team]["name"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  )),
            ),
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
}