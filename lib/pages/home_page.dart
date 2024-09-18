import 'package:flutter/material.dart';
import 'package:trackapplication/components/habit_tile.dart';
import 'package:trackapplication/components/my_alert_box.dart';
import 'package:trackapplication/components/my_fab.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackapplication/data/habit_database.dart';
import 'package:trackapplication/datetime/date_time.dart';
import 'package:trackapplication/components/month_summary.dart';

class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    HabitDatabase db = HabitDatabase();
    final _myBox = Hive.box("Habit_Database");

    @override
    void initState() {
        // when the app is opened for the first time ever
        // then create default data
        if (_myBox.get("CURRENT_HABIT_LIST") == null) {
            db.createDefaultData();
        } else {
            db.loadData();
        }

        // updating the database
        db.updateDatabase();

        super.initState();
    }

    // bool to habit completed
    bool habitCompleted = false;

    // checkbox was tapped
    void checkboxTapped(bool? value, int index) {
        setState(() {
            db.todaysHabitList[index][1] = value;
        });
        db.updateDatabase();   // <-- MISSING BRACKET WAS HERE
    }

    // create a new habit
    final _newHabitNameController = TextEditingController();
    void createNewHabit() {
        //show alert dialog for user to enter the new habit details
        showDialog(
            context: context,
            builder: (context) {
                return MyAlertBox(
                    controller: _newHabitNameController,
                    hintText: 'Enter Habit Name',
                    onSave: saveNewHabit,
                    onCancel: cancelDialogBox,
                );
            },
        );
    }

    // save new habit
    void saveNewHabit() {
        // add new habit to todays habit list
        setState(() {
            db.todaysHabitList.add([_newHabitNameController.text, false]);
        });

        //clear textfield
        _newHabitNameController.clear();
        Navigator.of(context).pop();

        db.updateDatabase();
    }

    // cancel new habit
    void cancelDialogBox() {
        //clear textfield
        _newHabitNameController.clear();
        Navigator.of(context).pop();
    }

    //open habit settings to edit
    void openHabitSettings(int index) {
        showDialog(
            context: context,
            builder: (context) {
                return MyAlertBox(
                    controller: _newHabitNameController,
                    hintText: db.todaysHabitList[index][0],
                    onSave: () => saveExistingHabit(index),
                    onCancel: cancelDialogBox,
                );
            },
        );
    }

    //save existing habit with a new name
    void saveExistingHabit(int index) {
        setState(() {
            db.todaysHabitList[index][0] = _newHabitNameController.text;
        });
        _newHabitNameController.clear();
        Navigator.pop(context);

        db.updateDatabase();
    }

    //delete habit
    void deleteHabit(int index) {
        setState(() {
            db.todaysHabitList.removeAt(index);
        });
        db.updateDatabase();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
            body: ListView(
                children: [
                    //monthly summary heat map
                    MonthlySummary(
                        datasets: db.heatMapDataSet, 
                        startDate: _myBox.get("START_DATE")
                    ),

                    //list of habits
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: db.todaysHabitList.length,
                        itemBuilder: (context, index) {
                            return HabitTile(
                                habitName: db.todaysHabitList[index][0],
                                habitCompleted: db.todaysHabitList[index][1],
                                onChanged: (value) => checkboxTapped(value, index),
                                settingsTapped: (context) => openHabitSettings(index),
                                deleteTapped: (context) => deleteHabit(index),
                            );
                        },
                    ), //list view builder
                ],
            ), //list view
        ); // Scaffold
    }
}
