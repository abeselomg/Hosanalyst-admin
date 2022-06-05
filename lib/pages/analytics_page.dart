import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/utils.dart';
import '../widgets/analytics/PlayerStats.dart';
import '../widgets/analytics/TeamStats.dart';
import '../widgets/analytics/PlayerDetail.dart';

class Analytics extends StatefulWidget {
  Map? gameData;
  Analytics({Key? key, this.gameData}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.of(context).pop(),
          )),
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: SingleChildScrollView(
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
                                    widget.gameData!["home_team"]["logo_link"],
                                    50,
                                    50,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${widget.gameData!["home_team"]["name"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            widget.gameData!["status"] == "completed"
                                ? Row(
                                    children: [
                                      //
                                      Text(
                                          "${widget.gameData!["full_time_home_score"]}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      const Text(" - "),
                                      Text(
                                          "${widget.gameData!["full_time_away_score"]}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text(
                                          "${widget.gameData!["kick_off_time"].substring(0, 5)}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          DateFormat("dd MMM y").format(
                                              DateTime.parse(
                                                  widget.gameData!["date"])),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                            Expanded(
                              child: Column(
                                children: [
                                  networkImage(
                                    widget.gameData!["away_team"]["logo_link"],
                                    50,
                                    50,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${widget.gameData!["away_team"]["name"]}",
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
                      text: "Player Stats",
                    ),
                    Tab(
                      text: "Team Stats",
                    ),
                    Tab(
                      text: "Player Detail",
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 2,
                  child: TabBarView(
                    children: [
                      PlayerStats(gameData: widget.gameData),
                      TeamStats(gameData: widget.gameData),
                      PlayerDetail(gameData: widget.gameData)
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
