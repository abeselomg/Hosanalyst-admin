import 'package:flutter/material.dart';
import 'package:snack/snack.dart';
import 'package:cached_network_image/cached_network_image.dart';

void showSnackBar(BuildContext context, String message) {
  SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    backgroundColor: Colors.red,
    elevation: 2,
  ).show(context);
}

Widget networkImage(imageUrl, double height, double width) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
        ),
      ),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.shield_rounded),
  );
}


  List attackActions = [
  {"SP": "short pass"},
  {"LP": "long pass"},
  {"Dr": "dribbles"},
  {"Ass": "assists"},
  {"Cros": "crosses"},
  {"GoSc": "goals scored"},
  {"HdonTar": "headers on target"},
  {"TotShot": "total shots"},
  {"FK": "free kick"},
  {"FoRec": "fouls received"},
  {"Cor": "corners"},
  {"ShonTar": "shots on target"},
  {"ShofTar": "shots off target "},
  {"OfSi": "off-sides committed "},
];

List defenceActions = [
  {"TakLost": "tackles lost"},
  {"TakWon": "tackles won"},
  {"IntrcpLoPas": "interceptions of long pass"},
  {"IntrcpShoPas": "interceptions of short pass"},
  {"Clr": "clearance"},
  {"CrosAg": "crosses against "},
  {"CorAg": "corners against "},
  {"HedWon": "headers won"},
  {"HedLos": "headers lost"},
  {"OfsRec": "off-sides received "},
  {"ShoOntarRec": "shots on target received"},
  {"ShoOfftarRec": "shots off target received"},
  {"GoConc": "goals conceded"},
  {"FkConc": "free kick conceded"},
  {"PenConc": "penalties conceded"},
  {"DefMov": "defensive moves "},
  {"BodCeck": "body checks"},
  {"YC": "yellow cards"},
  {"RC": "red cards"},
];
