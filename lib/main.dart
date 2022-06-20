import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatapp/business/bloc/message_bloc.dart';
import 'package:chatapp/business/bloc/message_event.dart';
import 'package:chatapp/data/repository.dart';
import 'ui/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<Repository>(
      create: (context) => Repository(),
      child: BlocProvider(
        create: ((context) => MessageBloc(RepositoryProvider.of(context))..add(GetMessageEvent())),
        child: MaterialApp(
          title: 'ChatApp',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'ChatApp'),
        ),
      ),
    );
  }
}
