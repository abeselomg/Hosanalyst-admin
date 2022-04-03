import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  List all_games = [
    {
      "HomeTeam": "Manchester United",
      "AwayTeam": "Chelsea",
    },
    {
      "HomeTeam": "Manchester City",
      "AwayTeam": "Liverpool",
    },
    {
      "HomeTeam": "Spurs",
      "AwayTeam": "Arsenal",
    },
    {
      "HomeTeam": "Everton",
      "AwayTeam": "Watford",
    },
    {
      "HomeTeam": "Leicester City",
      "AwayTeam": "Brighton",
    },
    {
      "HomeTeam": "Tottenham",
      "AwayTeam": "West Ham",
    },
    {
      "HomeTeam": "Burnley",
      "AwayTeam": "Crystal Palace",
    },
    {
      "HomeTeam": "Newcastle",
      "AwayTeam": "Southampton",
    },
    {
      "HomeTeam": "Wolves",
      "AwayTeam": "Bournemouth",
    },
    {
      "HomeTeam": "Hull City",
      "AwayTeam": "Aston Villa",
    },
    {
      "HomeTeam": "Norwich City",
      "AwayTeam": "Swansea City",
    },
    {
      "HomeTeam": "Fulham",
      "AwayTeam": "Cardiff City",
    },
    {
      "HomeTeam": "Sunderland",
      "AwayTeam": "Stoke City",
    },
    {
      "HomeTeam": "West Brom",
      "AwayTeam": "Newcastle",
    },
    {
      "HomeTeam": "Barnsley",
      "AwayTeam": "Huddersfield",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color:Colors.black87,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "All Games",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: ListView.builder(
                  itemCount: all_games.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Text("16:30"),
                        title: Text(
                            "${all_games[index]["HomeTeam"]} vs ${all_games[index]["AwayTeam"]}"),
                        style: ListTileStyle.list,
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => homepage(),
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
