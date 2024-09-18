import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:trackapplication/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(Duration(days: 0)),
        datasets: datasets,
        defaultColor: Colors.grey[200], // Removed the colorMode
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        // Changed colorsets from Set<Color> to Map<int, Color>
        colorsets: const {
  1: Color.fromRGBO(2, 179, 8, 0.08),  // 20/255
  2: Color.fromRGBO(2, 179, 8, 0.16),  // 40/255
  3: Color.fromRGBO(2, 179, 8, 0.24),  // 60/255
  4: Color.fromRGBO(2, 179, 8, 0.31),  // 80/255
  5: Color.fromRGBO(2, 179, 8, 0.39),  // 100/255
  6: Color.fromRGBO(2, 179, 8, 0.47),  // 120/255
  7: Color.fromRGBO(2, 179, 8, 0.59),  // 150/255
  8: Color.fromRGBO(2, 179, 8, 0.71),  // 180/255
  9: Color.fromRGBO(2, 179, 8, 0.86),  // 220/255
  10: Color.fromRGBO(2, 179, 8, 1.0),  // 255/255
},


        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ), //HeatMap
    ); //Container
  }
}
