import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

const String baseUrl = 'https://serene-brook-52238.herokuapp.com/';
String token = 'a4de982842007b41441037473507fd25169ce2c7';
// String token = prefs.getString('token');

Future getAllGames() async {
  Map<String, String> headers = {
    "Accept": "application/json",
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http
        .get(Uri.parse(baseUrl + "api/v1/all_games"), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var gamedata = json.decode(response.body);

      return gamedata;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}

Future getGameDetail(id) async {
  Map<String, String> headers = {
    "Accept": "application/json",
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http
        .get(Uri.parse(baseUrl + "api/v1/game_rud/$id/"), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var singlegamedata = json.decode(response.body);

      return singlegamedata;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}

Future updateLineup(id, field, List data) async {
  List<int> lineupIds = [];

  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Token $token",
  };
  for (var element in data) {
    lineupIds.add(element['id'] as int);
  }
 
  try {
    http.Response response =
        await http.patch(Uri.parse(baseUrl + "api/v1/game_rud/$id/"),
            headers: headers,
            body: jsonEncode(<String, List<int>>{
              field: lineupIds,
            }));


    if (response.statusCode == 200 || response.statusCode == 201) {
      var singlegamedata = json.decode(response.body);

      return singlegamedata;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}


Future updateGameStatus(id, status) async {

  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Token $token",
  };


  try {
    http.Response response =
        await http.patch(Uri.parse(baseUrl + "api/v1/game_rud/$id/"),
            headers: headers,
            body: jsonEncode(<String, String>{
              "status": status,
            }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var singlegamedata = json.decode(response.body);

      return singlegamedata;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}
