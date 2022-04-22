import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_detail_page.dart';
import '../helpers/api_services.dart';
import '../helpers/utils.dart';

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  List allApiGames = [];
  late DateTime _currentlySelectedDate;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentlySelectedDate = DateTime.now();
      _isLoading = true;
    });

    getAllGames(DateFormat("y-M-d").format(_currentlySelectedDate))
        .then((value) {
      if (value != null) {
        setState(() {
          allApiGames = value;
          _isLoading = false;
        });
      }
    });
  }

  Widget dateRow() {
    List<Widget> dateRow = [];
    for (int i = 2; i > -3; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));

      dateRow.add(GestureDetector(
        onTap: () {
          setState(() {
            _currentlySelectedDate = date;
            _isLoading = true;
          });
          getAllGames(DateFormat("y-M-d").format(_currentlySelectedDate))
              .then((value) {
            if (value != null) {
              setState(() {
                allApiGames = value;
                _isLoading = false;
              });
            }
          });
        },
        child: Column(
          children: [
            i == 0
                ? Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentlySelectedDate.day == date.day
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                  )
                : Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentlySelectedDate.day == date.day
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                  ),
            Text(
              DateFormat('d MMM').format(date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _currentlySelectedDate.day == date.day
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dateRow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Colors.black87,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Hosanalyst",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: dateRow(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    allApiGames.isEmpty
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cancel_rounded, size: 50),
                                Text("No Games On This Date",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allApiGames.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                    "${allApiGames[index]["kick_off_time"].substring(0, 5)}"),
                              ),
                              title: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: networkImage(
                                              "${allApiGames[index]["home_team"]["logo_link"]}",
                                              20,
                                              20),
                                        ),
                                        Text(
                                            "${allApiGames[index]["home_team"]["name"]}"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: networkImage(
                                            "${allApiGames[index]["away_team"]["logo_link"]}",
                                            20,
                                            20,
                                          ),
                                        ),
                                        Text(
                                            "${allApiGames[index]["away_team"]["name"]}"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameDetail(
                                      gameId: allApiGames[index]["id"],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
