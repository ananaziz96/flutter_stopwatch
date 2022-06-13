import 'package:hive/hive.dart';

part 'stopwatch_data.g.dart';

@HiveType(typeId: 1)
class StopwatchData {
  StopwatchData({required this.time, required this.laps});
  @HiveField(0)
  String time;

  @HiveField(2)
  String laps;
}
