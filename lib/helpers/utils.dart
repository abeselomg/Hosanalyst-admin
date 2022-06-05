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

List<Map> majorActions = [
  {"text": "Short Pass", "value": "short pass"},
  {"text": "Long Pass", "value": "long pass"},
  {"text": "Dribbles", "value": "dribbles"},
  {"text": "Assists", "value": "assists"},
  {"text": "Crosses", "value": "crosses"},
  {"text": "Goals Scored", "value": "goals scored"},
  {"text": "Headers On Target", "value": "headers on target"},
  {"text": "Shots On Target", "value": "shots on target"},
  {"text": "Shots Off Target", "value": "shots off target"},
  {"text": "Tackles Won", "value": "tackles won"},
  {"text": "Interceptions of Long Pass", "value": "interceptions of long pass"},
  {
    "text": "Interceptions of Short Pass",
    "value": "interceptions of short pass"
  },
  {"text": "Yellow Cards", "value": "yellow cards"},
  {"text": "Red Cards", "value": "red cards"}
];

// overview

List playeroverview = [
  "goals scored",
  "short pass",
  "long pass",
  "shots on target",
  "shots off target",
];

List overview = [
  "possession",
  "shots on target",
  "shots off target",
  "corners",
  "yellow cards",
  "red cards",
  "off-sides committed"
];



List attack = [
  "short pass",
  "long pass",
  "dribbles",
  "assists",
  "crosses",
  "goals scored",
  "headers on target",
  "shots on target",
  "shots off target",
  "shot accuracy",
  "fouls received",
  "free kick",
  "corners",
];

List defensive = [
  "tackles won",
  "tackles lost",
  "interceptions of long pass",
  "interceptions of short pass",
  "clearance",
  "crosses against",
  "corners against",
  "headers won",
  "headers lost",
  "off-sides received",
  "shots on target received",
  "shots off target received",
  "goals conceded",
  "free kick conceded",
  "penalties conceded",
  "defensive moves",
  "body checks",
];

List discipline = [
  "yellow cards",
  "red cards",
  "off-sides committed"
];


// TableCalendar(
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDate = selectedDay;
//                     });
//                   },
//                   locale: 'en_US',
//                   firstDay: DateTime.utc(2010, 10, 16),
//                   lastDay: DateTime.utc(2030, 3, 14),
//                   focusedDay: _selectedDate,
//                   selectedDayPredicate: (day) {
//                     return _selectedDate == day;
//                   },
//                   calendarStyle: CalendarStyle(
//                       cellMargin: const EdgeInsets.all(2),
//                       selectedDecoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       todayDecoration: const BoxDecoration(
//                         color: Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                       weekendTextStyle: const TextStyle(
//                         color: Colors.white,
//                       )),
//                   headerStyle: const HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                   ),
//                   shouldFillViewport: true,
//                   daysOfWeekStyle: const DaysOfWeekStyle(
//                     weekdayStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.0,
//                     ),
//                     weekendStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                   rowHeight: 30,
//                 ),