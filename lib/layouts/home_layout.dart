// ignore_for_file: avoid_print, unused_local_variable, body_might_complete_normally_nullable, must_be_immutable

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:toda_app/shared/cubit/app_cubit.dart";

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var textController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDateBase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Todo App'),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown &&
                    formKey.currentState!.validate()) {
                  cubit.insertToDatebase(
                    title: textController.text,
                    time: timeController.text,
                    date: dateController.text,
                  );
                  cubit.changeBottomSheetShow(
                    isShown: false,
                    myIcon: Icons.edit,
                  );
                  Navigator.pop(context);
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          return Container(
                            width: double.infinity,
                            color: Colors.white54,
                            padding: const EdgeInsets.all(8),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: textController,
                                    keyboardType: TextInputType.text,
                                    onTap: () {
                                      print('tabed');
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "task title can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Task Title"),
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "task time can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                        print(value.format(context));
                                      }).catchError(
                                        (error) {
                                          print(error);
                                        },
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Task Time "),
                                      prefixIcon:
                                          Icon(Icons.watch_later_outlined),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "task date can't be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-08-30'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      }).catchError((error) {
                                        print(error);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Task date "),
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetShow(
                          isShown: false,
                          myIcon: Icons.edit,
                        );
                      });
                  cubit.changeBottomSheetShow(
                    isShown: true,
                    myIcon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
