import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



  Container gameInfoCard(BuildContext context, gameData) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.95,
    padding: const EdgeInsets.symmetric(
      vertical: 10.0,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    DateFormat('dd MMM ,yyyy').format(
                        DateTime.parse(gameData["date"].substring(0, 10))),
                    style: const TextStyle(
                      fontSize: 12,
                    )),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.sports_sharp,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("${gameData["referee"]}",
                    style: const TextStyle(
                      fontSize: 12,
                    )),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.stadium_outlined,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("${gameData["stadium"]['name']}",
                style: const TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      ],
    ),
  );
}
