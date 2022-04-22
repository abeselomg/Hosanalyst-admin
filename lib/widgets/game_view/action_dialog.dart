import 'package:flutter/material.dart';
import './build_shirts.dart';
import './action_cards.dart';
import '../../helpers/utils.dart';

Future<dynamic> actionDialog(
  context,
  zone,
  teamLineup,
  selectedPlayer,
  selectedAction,
  selectedActionType,
  firstController,
  isLoading,
  onActionSubmit,
) =>
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return DefaultTabController(
              length: 2,
              child: AlertDialog(
                scrollable: true,
                insetPadding: EdgeInsets.all(20),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Select Player",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.32,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count(
                          crossAxisCount: 5,
                          childAspectRatio: (1 / 1.5),
                          children: teamLineup
                              .map<Widget>(
                                (player) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPlayer = player;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: buildShirts(
                                          context,
                                          player["shirt_number"],
                                          selectedPlayer),
                                    )),
                              )
                              .toList(),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 15.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             setState(() {
                      //               selectedActionType = "Attack";
                      //             });
                      //           },
                      //           child: Container(
                      //               height: 30,
                      //               // width: 50,
                      //               decoration: BoxDecoration(
                      //                 color: selectedActionType == 'Attack'
                      //                     ? Colors.green
                      //                     : Colors.white,
                      //                 border: Border.all(
                      //                   color: Colors.black,
                      //                   width: 1,
                      //                 ),
                      //               ),
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(3.0),
                      //                 child: Text("Attack",
                      //                     style: TextStyle(
                      //                         fontSize: 20,
                      //                         color: selectedActionType == 'Attack'
                      //                             ? Colors.white
                      //                             : Colors.black)),
                      //               )),
                      //         ),
                      //       ),
                      //       Center(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             setState(() {
                      //               selectedActionType = "Defence";
                      //             });
                      //           },
                      //           child: Container(
                      //               height: 30,
                      //               // width: 50,
                      //               decoration: BoxDecoration(
                      //                 color: selectedActionType == 'Defence'
                      //                     ? Colors.green
                      //                     : Colors.white,
                      //                 border: Border.all(
                      //                   color: Colors.black,
                      //                   width: 1,
                      //                 ),
                      //               ),
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(3.0),
                      //                 child: Text("Defence",
                      //                     style: TextStyle(
                      //                         fontSize: 20,
                      //                         color: selectedActionType == 'Defence'
                      //                             ? Colors.white
                      //                             : Colors.black)),
                      //               )),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TabBar(
                          isScrollable: true,
                          labelColor: Theme.of(context).accentColor,
                          tabs: const [
                            Tab(
                              text: "Attack",
                            ),
                            Tab(
                              text: "Defence",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        child: Scrollbar(
                            controller: firstController,
                            isAlwaysShown: true,
                            child: TabBarView(
                              children: [
                                GridView.builder(
                                    controller: firstController,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 100,
                                      crossAxisSpacing: 3,
                                      childAspectRatio: (1 / 0.55),
                                    ),
                                    itemCount: attackActions.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Stack(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedAction =
                                                      attackActions[index]
                                                          .values
                                                          .first;
                                                });
                                              },
                                              child: actionWidgets(context,
                                                  attackActions, index)),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: selectedAction ==
                                                      attackActions[index]
                                                          .values
                                                          .first
                                                  ? const Icon(Icons.star,
                                                      color: Colors.yellow,
                                                      size: 25)
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ))
                                        ],
                                      );
                                    }),

                                //Defence Actions

                                GridView.builder(
                                    controller: firstController,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 100,
                                      crossAxisSpacing: 3,
                                      childAspectRatio: (1 / 0.55),
                                    ),
                                    itemCount: defenceActions.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Stack(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedAction =
                                                      defenceActions[index]
                                                          .values
                                                          .first;
                                                });
                                              },
                                              child: actionWidgets(context,
                                                  defenceActions, index)),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: selectedAction ==
                                                      defenceActions[index]
                                                          .values
                                                          .first
                                                  ? const Icon(Icons.star,
                                                      color: Colors.yellow,
                                                      size: 25)
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ))
                                        ],
                                      );
                                    }),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : FlatButton(
                                color: Colors.green,
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  onActionSubmit(
                                      zone, selectedPlayer, selectedAction);
                                },
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
