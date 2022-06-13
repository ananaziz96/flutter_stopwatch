import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stopwatch/stopwatch_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;
void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('box');
  Hive.registerAdapter(StopwatchDataAdapter());
  box.put(
      'stopwatchData', StopwatchData(time: "00:00:07", laps: "Lap 1 00:00:04"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeApp());
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  StopwatchData db = box.get('stopwatchData');

  bool isRunning = false;
  int secs = 0, mins = 0, hrs = 0;
  String dispSeconds = "00", dispMinutes = "00", dispHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = secs + 1;
      int localMinutes = mins;
      int localHours = hrs;

      debugPrint('movieTitle');

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        secs = localSeconds;
        mins = localMinutes;
        hrs = localHours;
        dispSeconds = (secs >= 10) ? "$secs" : "0$secs";
        dispMinutes = (mins >= 10) ? "$mins" : "0$mins";
        dispHours = (hrs >= 10) ? "$hrs" : "0$hrs";
      });
    });
  }

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      secs = 0;
      mins = 0;
      hrs = 0;

      dispSeconds = "00";
      dispMinutes = "00";
      dispHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$dispHours:$dispMinutes:$dispSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 38, 38, 39),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.watch_later_outlined,
                                  size: 30.0, color: Colors.yellow[600]),
                            ),
                            TextSpan(
                                text: " Stopwatch",
                                style: TextStyle(
                                    color: Colors.yellow[600],
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'cursive')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                        child: Text("$dispHours:$dispMinutes:$dispSeconds",
                            style: TextStyle(
                              color: Colors.yellow[600],
                              fontSize: 82.0,
                              fontWeight: FontWeight.w600,
                            ))),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                            onPressed: () {
                              if (!isRunning) {
                                start();
                              } else {
                                //disable start button
                              }
                              isRunning = true;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.yellow),
                            ),
                            child: Text(
                              "Start",
                              style: TextStyle(color: Colors.yellow[600]),
                            )),
                        SizedBox(
                          width: 8.0,
                        ),
                        RawMaterialButton(
                            onPressed: () {
                              if (isRunning) {
                                stop();
                              } else {
                                //disable stop button
                              }
                              isRunning = false;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.yellow),
                            ),
                            child: Text(
                              "Stop",
                              style: TextStyle(color: Colors.yellow[600]),
                            )),
                        SizedBox(
                          width: 8.0,
                        ),
                        RawMaterialButton(
                            onPressed: () {
                              addLaps();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.yellow),
                            ),
                            child: Text(
                              "Lap",
                              style: TextStyle(color: Colors.yellow[600]),
                            )),
                        SizedBox(
                          width: 8.0,
                        ),
                        RawMaterialButton(
                            onPressed: () {
                              reset();
                              isRunning = false;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.yellow),
                            ),
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.yellow[600]),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Your Laps",
                      style: TextStyle(color: Colors.yellow[600]),
                    ),
                    SingleChildScrollView(
                        child: Container(
                            //max width and height for mobile/web
                            height: 300.0,
                            width: 600.0,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 65, 65, 65),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            //list builder
                            child: ListView.builder(
                                itemCount: laps.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Time saved: ${db.time}",
                                                style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 16.0,
                                                )),
                                            Text("Laps saved: ${db.laps}",
                                                style: TextStyle(
                                                  color: Colors.yellow,
                                                  fontSize: 16.0,
                                                ))
                                          ]));
                                }))),
                    Text(
                      "Show saved data from previous session",
                      style: TextStyle(color: Colors.yellow[600]),
                    ),
                    Container(
                        //max width and height for mobile/web
                        height: 300.0,
                        width: 600.0,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 65, 65, 65),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        //list builder
                        child: ListView.builder(
                            itemCount: laps.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Lap ${index + 1}",
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 16.0,
                                            )),
                                        Text("${laps[index]}",
                                            style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 16.0,
                                            ))
                                      ]));
                            }))
                  ],
                ))));
  }
}
