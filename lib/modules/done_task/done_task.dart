import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/app_cubit.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var doneTasks = AppCubit.get(context).doneTasks;
        if (doneTasks.isNotEmpty) {
          return ListView.separated(
            itemCount: doneTasks.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.grey,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItems(doneTasks[index], context);
            },
          );
        }
        return buildFallbackCondation();
      },
    );
  }
}
