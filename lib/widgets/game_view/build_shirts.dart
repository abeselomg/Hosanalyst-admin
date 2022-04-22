import 'package:flutter/material.dart';


  Widget buildShirts(context,var shirtNumber, selectedPlayer,{markedPlayer}) {
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
        style: const TextStyle(
            color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
      ),
      markedPlayer != null
          ? Positioned(
              top: 0,
              right: 0,
              child: markedPlayer["shirt_number"] == shirtNumber
                  ? const Icon(Icons.star, color: Colors.yellow, size: 30)
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ))
          : Positioned(
              top: 0,
              right: 0,
              child: selectedPlayer["shirt_number"] == shirtNumber
                  ? Icon(markedPlayer != null ? Icons.swap_horiz : Icons.star,
                      color: Colors.yellow, size: 30)
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ))
    ],
  );
}
