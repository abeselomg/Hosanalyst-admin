import 'package:flutter/material.dart';

bool actionEvaluator(selectedAction, action) {
  return selectedAction == action ? true : false;
}


Padding actionWidgets(BuildContext context, List<dynamic> actionarr, int index) {
  return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${actionarr[index].keys.first}",
                    ),
                  ),
                ),
              );
}
