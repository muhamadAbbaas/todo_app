import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toda_app/shared/cubit/app_cubit.dart';

import '../../shared/components/components.dart';

class NewTask extends StatelessWidget {
  const NewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var newTasks = AppCubit.get(context).newTasks;
        if (newTasks.isNotEmpty) {
          return ListView.separated(
            itemCount: newTasks.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.grey,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return buildTaskItems(newTasks[index], context);
            },
          );
        }
        return buildFallbackCondation();
      },
    );
  }
}
