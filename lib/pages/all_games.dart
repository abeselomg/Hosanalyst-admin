import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/api_services.dart';
import '../helpers/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import './analytics_page.dart';

class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  List allApiGames = [];
  late DateTime _currentlySelectedDate;
  bool _isLoading = false;
  var _selectedDate = DateTime.now();
  var _focusedDay = DateTime.now();

  getGamePerDate(date) async {
    setState(() {
      _isLoading = true;
    });
    getAllGames(date).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value != null) {
        setState(() {
          allApiGames = value;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentlySelectedDate = DateTime.now();
    });

    getGamePerDate(DateFormat("y-M-d").format(_currentlySelectedDate));
  }

  showCalendar() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.4,
                child: TableCalendar(
                  onDaySelected: (selectedDay, focusedDay) async {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    getGamePerDate(DateFormat("y-M-d").format(focusedDay));
                    await Future.delayed(const Duration(milliseconds: 600), () {
                      Navigator.pop(context);
                    });
                  },
                  locale: 'en_US',
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2090, 3, 14),
                  focusedDay: _selectedDate,
                  selectedDayPredicate: (day) {
                    return isSameDay(day, _focusedDay);
                  },
                  calendarStyle: CalendarStyle(
                      cellMargin: const EdgeInsets.all(2),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  shouldFillViewport: true,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    weekendStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  rowHeight: 30,
                ),
              ),
            );
          });
        });
  }

  Widget dateRow() {
    List<Widget> dateRow = [];
    for (int i = 2; i > -3; i--) {
      DateTime date = DateTime.now().subtract(Duration(days: i));

      dateRow.add(GestureDetector(
        onTap: () {
          setState(() {
            _currentlySelectedDate = date;
            _isLoading = true;
          });
          getGamePerDate(DateFormat("y-M-d").format(_currentlySelectedDate));
        },
        child: Column(
          children: [
            isSameDay(date, DateTime.now())
                ? Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentlySelectedDate.day == date.day
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                  )
                : Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _currentlySelectedDate.day == date.day
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                  ),
            Text(
              DateFormat('d MMM').format(date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _currentlySelectedDate.day == date.day
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dateRow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.calendar_month_outlined,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    showCalendar();
                    // _insertOverlay(context);
                  },
                ),
              )
            ],
            centerTitle: true,
            title: Text("Hossanalyst",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),
        body: Container(
          // color: Colors.black87,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: dateRow(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    allApiGames.isEmpty
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cancel_rounded, size: 50),
                                Text("No Games On This Date",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allApiGames.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                    "${allApiGames[index]["kick_off_time"].substring(0, 5)}"),
                              ),
                              title: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: networkImage(
                                              "${allApiGames[index]["home_team"]["logo_link"]}",
                                              20,
                                              20),
                                        ),
                                        Text(
                                            "${allApiGames[index]["home_team"]["name"]}"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: networkImage(
                                            "${allApiGames[index]["away_team"]["logo_link"]}",
                                            20,
                                            20,
                                          ),
                                        ),
                                        Text(
                                            "${allApiGames[index]["away_team"]["name"]}"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Analytics(gameData: allApiGames[index]),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
