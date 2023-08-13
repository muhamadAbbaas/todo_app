// ignore_for_file: prefer_final_fields, unused_field, avoid_print, avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_task/archived_task.dart';
import '../../modules/done_task/done_task.dart';
import '../../modules/new_task/new_task.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  int currentIndex = 0;
  late Database dataBase;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData icon = Icons.edit;
  List screens = [
    const NewTask(),
    const DoneTask(),
    const ArchivedTask(),
  ];

  AppCubit() : super(AppCubitInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDateBase() {
    openDatabase(
      'todo1.db',
      version: 1,
      onCreate: (db, version) {
        print('dateBase created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when table created ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDateFromDatebase(db);
        print('dateBase opened');
      },
    ).then((value) {
      dataBase = value;
      emit(CreateDataBaseState());
    });
  }

  void insertToDatebase({
    @required title,
    @required time,
    @required date,
  }) {
    dataBase
        .transaction((txn) => txn
                .rawInsert(
                    'INSERT INTO tasks(title, time, date) VALUES("$title", "$time", "$date")')
                .then((value) {
              print("$value inserted successfuly");
            }).catchError((error) {
              print(error);
            }))
        .then((value) {
      emit(InsertToDataBaseState());
      getDateFromDatebase(dataBase);
    }).catchError(
      (error) {
        print(error);
      },
    );
  }

  void updateDate({
    required String status,
    required int id,
  }) async {
    await dataBase.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDateFromDatebase(dataBase);
      emit(UpdateDataBaseState());
    });
  }

  void deleteDate({
    required int id,
  }) async {
    await dataBase.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDateFromDatebase(dataBase);
      emit(DeleteFromDataBaseState());
    });
  }

  void getDateFromDatebase(Database dataBase) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    dataBase.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'done')
          doneTasks.add(element);
        else if (element['status'] == 'archived')
          archivedTasks.add(element);
        else
          newTasks.add(element);
      });
      emit(GetFromDataBaseState());
      print(value);
    });
  }

  void changeBottomSheetShow({
    required bool isShown,
    required IconData myIcon,
  }) {
    isBottomSheetShown = isShown;
    icon = myIcon;
    emit(ChangeIconState());
  }
}
