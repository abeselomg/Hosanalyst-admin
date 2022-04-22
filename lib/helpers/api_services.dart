import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://serene-brook-52238.herokuapp.com/';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String> getToken() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString('token')!;
}

Future getAllGames(String date) async {
  String token = await getToken();
  Map<String, String> headers = {
    "Accept": "application/json",
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http
        .get(Uri.parse(baseUrl + "api/v1/all_games?date=$date"), headers: headers);

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
  String token = await getToken();
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
  String token = await getToken();
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
  String token = await getToken();
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

Future login(phone, password) async {
  final SharedPreferences prefs = await _prefs;
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
  };

  try {
    http.Response response = await http.post(
        Uri.parse(baseUrl + "api/v1/auth/login/"),
        headers: headers,
        body:
            jsonEncode(<String, String>{"phone": phone, "password": password}));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var userData = json.decode(response.body);
      prefs.setString('token', userData['token']);
      prefs.getString("token");

      return userData;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}

Future setGameActions(Map<String, String> data) async {
  final SharedPreferences prefs = await _prefs;
  String token = await getToken();
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http.post(
        Uri.parse(baseUrl + "api/v1/create_gamedata/"),
        headers: headers,
        body: jsonEncode(data));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var gameAction = json.decode(response.body);

      return gameAction;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}

Future updateGameScoreBoard(id, Map<String, dynamic> data) async {
  String token = await getToken();
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http.patch(
        Uri.parse(baseUrl + "api/v1/game_rud/$id/"),
        headers: headers,
        body: jsonEncode(data));

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

Future setGameSubstitution( Map<String, dynamic> data) async {
  String token = await getToken();
  Map<String, String> headers = {
    "Accept": "application/json",
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': "Token $token",
  };

  try {
    http.Response response = await http.post(
        Uri.parse(baseUrl + "api/v1/create_gamesubdata/"),
        headers: headers,
        body: jsonEncode(data));

     

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
