import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
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
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

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
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
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
                        child: Text("$digitHours:$digitMinutes:$digitSeconds",
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
                              start();
                              // (started) ? start() : stop();
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
                              stop();
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
                                }))),
                  ],
                ))));
  }
}
