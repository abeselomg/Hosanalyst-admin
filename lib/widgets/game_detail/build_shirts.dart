import 'package:flutter/material.dart';


  Widget buildShirts(context,int shirtNumber, List playerlist) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Shirt-1.png"),
            fit: BoxFit.none,
          ),
        ),
      ),
      Text(
        shirtNumber.toString(),
        style: const TextStyle(fontSize: 20, decoration: TextDecoration.none),
      ),
      Positioned(
          top: 0,
          right: 0,
          child: playerlist
                  .any((element) => element["shirt_number"] == shirtNumber)
              ? const Icon(Icons.star, color: Colors.yellow, size: 30)
              : const SizedBox(
                  height: 0,
                  width: 0,
                ))
    ],
  );
}
