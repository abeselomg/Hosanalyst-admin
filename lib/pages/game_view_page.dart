import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../helpers/utils.dart';
import '../helpers/api_services.dart';
import '../widgets/game_view/action_dialog.dart';
import '../widgets/game_view/substitution_card.dart';
import '../widgets/game_view/score_board.dart';

class GameViewPage extends StatefulWidget {
  @required
  Map<String, dynamic> gameDetail;
  @required
  Map<String, dynamic> selectedTeam;

  Function? onGameDetailChanged;

  GameViewPage(
      {Key? key,
      required this.gameDetail,
      required this.selectedTeam,
      this.onGameDetailChanged})
      : super(key: key);

  @override
  State<GameViewPage> createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  final ScrollController _firstController = ScrollController();
  final TextEditingController _halfhomeTextController = TextEditingController();
  final TextEditingController _halfawayTextController = TextEditingController();
  final TextEditingController _fullhomeTextController = TextEditingController();
  final TextEditingController _fullawayTextController = TextEditingController();

  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  int initialduration = 0;
  late Duration duration;
  Timer? timer;
  bool _isShowingExtraTime = false;
  int maxReachableTime = 1;
  bool _isLoading = false;
  bool _isLoadingSub = false;
  final _selectedActionType = "Attack";
  var selectedAction = "";
  Map selectedPlayer = {};
  Map<String, dynamic> _teamData = {};
  String _teamIsHomeOrAWAY = '';
  List _teamLineup = [];
  List _teamSubstitutes = [];
  Map _playerOut = {};
  Map _playerIn = {};

  List items = [2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  void onActionSubmit(zone, selectedPlayer, selectedAction) {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> actionData = {
      "playerId": selectedPlayer["id"].toString(),
      "teamId": _teamData["id"].toString(),
      "gameId": widget.gameDetail["id"].toString(),
      "action": selectedAction,
      "zone": zone.toString(),
      "time": _getCurrentTime()
    };

    setGameActions(actionData).then((value) {
      if (value == null) {
        showSnackBar(context, "Couldn't Send data");
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });

    selectedPlayer = {};
    selectedAction = "";
  }

  void onSubstitutionSubmit(playerOut, playerIn) {
    setState(() {
      _isLoadingSub = true;
      _playerIn = playerIn;
      _playerOut = playerOut;
    });

    setGameSubstitution({
      "playerInId": playerIn["id"],
      "playerOutId": playerOut["id"],
      "teamId": _teamData["id"],
      "gameId": widget.gameDetail["id"],
      "time_of_substitution": _getCurrentTime()
    }).then((value) {
      setState(() {
        _isLoadingSub = false;
      });
      if (value == null) {
        showSnackBar(context, "Could Not Set Substitution");
        Navigator.pop(context);
      } else {
        widget.gameDetail["game_substitutions"].add(value);
        widget.onGameDetailChanged!(widget.gameDetail);

        setState(() {
          _teamSubstitutes
              .removeWhere((element) => element["id"] == _playerIn["id"]);
          _teamLineup
              .removeWhere((element) => element["id"] == _playerOut["id"]);
          _teamLineup.add(_playerIn);
          _playerIn = {};
          _playerOut = {};
        });

        Navigator.pop(context);
      }
    });
  }

  void onUpdateScoreBoard(
      TextEditingController hometxtcontroller, awaytxtcontroller) {
    Map<String, int> halfdata = {
      "half_time_home_score": int.parse(hometxtcontroller.text),
      "half_time_away_score": int.parse(awaytxtcontroller.text)
    };
    Map<String, dynamic> fulldata = {
      "full_time_home_score": int.parse(hometxtcontroller.text),
      "full_time_away_score": int.parse(awaytxtcontroller.text),
      "status": "completed"
    };
    updateGameScoreBoard(widget.gameDetail["id"],
            hometxtcontroller == _halfhomeTextController ? halfdata : fulldata)
        .then((value) {
      if (value == null) {
        showSnackBar(context, "Could Not Set Half/Full time Data");
        Navigator.pop(context);
      } else {
        widget.gameDetail = value;
        widget.onGameDetailChanged!(widget.gameDetail);

        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    maxReachableTime =
        widget.gameDetail["half_time_home_score"] != null ? 90 : 45;
    initialduration =
        widget.gameDetail["half_time_home_score"] != null ? 45 : 0;

    duration = Duration(minutes: initialduration);
    _teamData = widget.selectedTeam;
    _teamIsHomeOrAWAY = _teamData["id"] == widget.gameDetail["home_team"]["id"]
        ? "home"
        : "away";
    _teamLineup = _teamIsHomeOrAWAY == "home"
        ? widget.gameDetail["home_team_lineup"]
        : widget.gameDetail["away_team_lineup"];

    _teamSubstitutes = _teamIsHomeOrAWAY == "home"
        ? widget.gameDetail["home_team_sub"]
        : widget.gameDetail["away_team_sub"];

    if (widget.gameDetail["game_substitutions"].length > 0) {
      widget.gameDetail["game_substitutions"].forEach((element) {
        var index = _teamLineup.indexWhere(
            (player) => player["id"] == element["player_out"]["id"]);
        if (index != -1) {
          _teamLineup[index] = element["player_in"];
          _teamSubstitutes.removeWhere(
              (player) => player["id"] == element["player_in"]["id"]);
        }
      });
    }
    items = _teamIsHomeOrAWAY != "home" ? items.reversed.toList() : items;
    items = initialduration == 45 ? items.reversed.toList() : items;

    starttimer();
  }

  void addtimer() {
    const addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
      });
    }
  }

  void starttimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addtimer());
  }

  void stoptimer() {
    if (mounted) {
      setState(() {
        duration = const Duration(minutes: 0, seconds: 0);
      });
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  List extractMInutesAndSeconds(Duration duration) {
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [minutes, seconds];
  }

  String _getCurrentTime() {
    final List _time = extractMInutesAndSeconds(duration);

    return _isShowingExtraTime
        ? "${twoDigits(maxReachableTime)} + ${_time[0]}:${_time[1]}"
        : "${_time[0]}:${_time[1]}";
  }

  Future<dynamic> onExitDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: const Text(
                  "Existing this page before half or full time is not recommended!\n\nAre you sure you want to exit?"),
              actions: [
                FlatButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 3;
    double cardHeight = MediaQuery.of(context).size.height / 4.3;
    return WillPopScope(
      onWillPop: () async {
        onExitDialog();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SliderDrawer(
            key: _key,
            appBar: null,
            sliderOpenSize: MediaQuery.of(context).size.height * 0.20,
            slideDirection: SlideDirection.TOP_TO_BOTTOM,
            slider: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF17AC2B),
                  Color(0xFF17AC35),
                ],
              )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Game Settings",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setScoreBoard(
                                      context,
                                      _halfhomeTextController,
                                      _halfawayTextController,
                                      widget.gameDetail,
                                      onUpdateScoreBoard);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      border: Border.all(
                                          width: 2, color: Colors.white)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Call Half Time",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setScoreBoard(
                                      context,
                                      _fullhomeTextController,
                                      _fullawayTextController,
                                      widget.gameDetail,
                                      onUpdateScoreBoard);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      border: Border.all(
                                          width: 2, color: Colors.white)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Call Full Time",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              substitutionCard(
                                  context,
                                  _teamLineup,
                                  _playerOut,
                                  _playerIn,
                                  _teamSubstitutes,
                                  selectedPlayer,
                                  _isLoadingSub,
                                  onSubstitutionSubmit);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  border: Border.all(
                                      width: 2, color: Colors.white)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Substitute Player",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.green,
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
                  children: items
                      .map(
                        (data) => GestureDetector(
                            onTap: () {
                              actionDialog(
                                  context,
                                  data,
                                  _teamLineup,
                                  selectedPlayer,
                                  selectedAction,
                                  _selectedActionType,
                                  _firstController,
                                  _isLoading,
                                  onActionSubmit);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                border: Border(
                                  right: BorderSide(
                                      width: 1, color: Colors.white70),
                                  left: BorderSide(
                                      width: 1, color: Colors.white70),
                                  top: BorderSide(
                                      width: 1, color: Colors.white70),
                                  bottom: BorderSide(
                                      width: 1, color: Colors.white70),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data.toString(),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.white54),
                                ),
                              ),
                            )),
                      )
                      .toList(),
                ),
                Align(
                    alignment: const Alignment(-0.9, -0.9),
                    child: GestureDetector(
                      onTap: () {
                        _key.currentState!.isDrawerOpen
                            ? _key.currentState!.closeSlider()
                            : _key.currentState!.openSlider();
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(blurRadius: 4)]),
                          child: const Center(
                              child: Icon(
                            Icons.menu_rounded,
                            size: 24,
                            color: Colors.black,
                          ))),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildTimer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimer() {
    List extractedData = extractMInutesAndSeconds(duration);
    final minutes = extractedData[0];
    final seconds = extractedData[1];

    minutes == twoDigits(maxReachableTime) && !_isShowingExtraTime
        ? {
            stoptimer(),
            setState(() {
              _isShowingExtraTime = true;
            }),
          }
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: _isShowingExtraTime
          ? Row(
              children: [
                Text(
                  "$maxReachableTime:00",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  " + $minutes:$seconds",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            )
          : Text(
              "$minutes:$seconds",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
    );
  }
}
