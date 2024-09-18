// reference to our box
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackapplication/datetime/date_time.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase{
    List todaysHabitList = [];
    Map<DateTime, int> heatMapDataSet = {};

    // create initial default data
    void createDefaultData() {
        todaysHabitList = [
            ["Run", false],
            ["Read", false],
        ];

        _myBox.put("START_DATE", todaysDateFormatted());
    }

    // load data that already exists
    void loadData() {
        // if it's a new day or if it's not
        if (_myBox.get(todaysDateFormatted()) == null) {
            todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
            //set all habit completed to false since it's a new day
            for (int i = 0; i < todaysHabitList.length; i++) {
                todaysHabitList[i][1] = false;
            }
        }
        else{
            todaysHabitList = _myBox.get(todaysDateFormatted());
        }
    }

    // update database
    void updateDatabase() {
        //update today entry
        _myBox.put(todaysDateFormatted(), todaysHabitList);

        //update universal habit list
        _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

        //calculate percentage completed everyday
        calculateHabitPercentages();

        //load heat map
        loadHeatMap();
    }

    void calculateHabitPercentages() {
        int countCompleted = 0;
        // Fix the comparison operator in the for loop
        for (int i = 0; i < todaysHabitList.length; i++) {
            if (todaysHabitList[i][1] == true) {
                countCompleted++;
            }
        }

        String percent = todaysHabitList.isEmpty ? '0.0'
            : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

        _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
    }

    void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // Count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
        String yyyymmdd = convertDateTimeToString(
            startDate.add(Duration(days: i)),
        );

        double strengthAsPercent = double.tryParse(
            _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
        )?.clamp(0.0, 1.0) ?? 0.0;

        int year = startDate.add(Duration(days: i)).year;
        int month = startDate.add(Duration(days: i)).month;
        int day = startDate.add(Duration(days: i)).day;

        final percentageForEachDay = <DateTime, int>{
            DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
        };

        heatMapDataSet.addEntries(percentageForEachDay.entries);
        print("Updated heatMapDataSet: $heatMapDataSet");
    }
}

}
