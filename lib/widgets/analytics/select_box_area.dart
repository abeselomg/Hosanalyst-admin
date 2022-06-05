import 'package:flutter/material.dart';
import 'drop_down.dart';
import 'minute_text_field.dart';
import '../../helpers/utils.dart';

class SelectBoxArea extends StatefulWidget {
  List<Map>? teamItems;
  Function? onPressed;
  @required
  bool isLoading;
  @required
  bool isFromTeam;
  SelectBoxArea(
      {Key? key,
      this.teamItems,
      this.onPressed,
      required this.isLoading,
      required this.isFromTeam})
      : super(key: key);

  @override
  State<SelectBoxArea> createState() => _SelectBoxAreaState();
}

class _SelectBoxAreaState extends State<SelectBoxArea> {
  final TextEditingController _fromController = TextEditingController();

  final TextEditingController _toController = TextEditingController();

  dynamic teamValue;

  dynamic actionValue;
  dynamic minuteValue;
  int? zoneValue;
  bool _showError = false;

  String? minString;
  String twoDigits(String n) => n.padLeft(2, "0");
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TEAM
              widget.isFromTeam
                  ? DropDown(
                      onChanged: (value) {
                        zoneValue = int.parse(value);
                      },
                      width:MediaQuery.of(context).size.width * 0.35,
                      items: List.generate(12, (index) => index)
                          .map((e) => {
                                "value": (e + 1).toString(),
                                "text": (e + 1).toString()
                              })
                          .toList(),
                      label: "Zone")
                  : DropDown(
                     width: MediaQuery.of(context).size.width * 0.35,
                items: widget.teamItems,
                label: "Team",
                onChanged: (value) {
                  teamValue = value;
                },
              ),
              //Action
              DropDown(
                 width: MediaQuery.of(context).size.width * 0.35,
                label: "Action",
                items: majorActions,
                onChanged: (value) {
                  actionValue = value;
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TIME
              DropDown(
                 width: MediaQuery.of(context).size.width * 0.35,
                label: "Time",
                items: const [
                   {
                    "value": "00:00-90:00",
                    "text": "Full Game",
                  },
                  {
                    "value": "00:00-15:00",
                    "text": "First 15 minutes",
                  },
                  {
                    "value": "00:00-45:00",
                    "text": "First half",
                  },
                  {
                    "value": "45:00-90:00",
                    "text": "Second half",
                  },
                  {
                    "value": "75:00-90:00",
                    "text": "Last 15 minutes",
                  },
                  {
                    "value": "custom",
                    "text": "Custom time",
                  }
                ],
                onChanged: (String value) {
                  setState(() {
                    minString = value;
                  });
                  if (value == 'custom') {
                    minuteValue = {
                      "timeStart": twoDigits(_fromController.text),
                      "timeEnd": twoDigits(_toController.text),
                    };
                  } else {
                    minuteValue = {
                      "timeStart": value.split('-')[0],
                      "timeEnd": value.split('-')[1]
                    };
                  }
                },
              ),
              minString == 'custom'
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        minuteTextField(context, "From", _fromController),
                        minuteTextField(context, "To", _toController),
                      ],
                    )
                  : const SizedBox(),
              !widget.isFromTeam
                  ? DropDown(
                     width: MediaQuery.of(context).size.width * 0.35,
                      onChanged: (value) {
                        zoneValue = int.parse(value);
                      },
                      items: List.generate(12, (index) => index)
                          .map((e) => {
                                "value": (e + 1).toString(),
                                "text": (e + 1).toString()
                              })
                          .toList(),
                      label: "Zone")
                  : const SizedBox(),
            ],
          ),
          widget.isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextButton(
                        child: const Center(
                            child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor,
                          ),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                        ),
                        onPressed: () {
                          if (!widget.isFromTeam &&
                              (minuteValue == null || actionValue == null)) {
                            setState(() {
                              _showError = true;
                            });
                          } else {
                            setState(() {
                              _showError = false;
                            });
                            if (minString == 'custom') {
                              minuteValue = {
                                "timeStart": twoDigits(_fromController.text),
                                "timeEnd": twoDigits(_toController.text),
                              };
                            }
                            widget.onPressed!({
                              "teamValue": teamValue,
                              "actionValue": actionValue,
                              "minuteValue": minuteValue,
                              "zoneValue": zoneValue,
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
          _showError
              ? const Text(
                  'Time and action must be selected',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                )
              : const SizedBox(),
        ]),
      ),
    );
  }
}
