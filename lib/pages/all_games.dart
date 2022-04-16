import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_view_page.dart';
import 'game_detail_page.dart';
import '../helpers/api_services.dart';

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  Widget dateRow() {
    List<Widget> dateRow = [];
    for (int i = 2; i > -3; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      dateRow.add(Column(
        children: [
          i == 0
              ? const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  DateFormat('EEE').format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          Text(
            DateFormat('d MMM').format(date),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dateRow,
    );
  }

  List allApiGames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllGames().then((value) {
      setState(() {
        allApiGames = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black87,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text("Hosanalyst",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: dateRow(),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                // height: MediaQuery.of(context).size.height*.82,
                
                child: ListView.builder(
                  itemCount: allApiGames.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                                    child: Image.network(
                                      "${allApiGames[index]["home_team"]["logo_link"]}",
                                      height: 20,
                                      width: 20,
                                    ),
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
                                    child: Image.network(
                                      "${allApiGames[index]["away_team"]["logo_link"]}",
                                      height: 20,
                                      width: 20,
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
