import 'package:chatapp/business/bloc/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chatapp/business/bloc/message_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: ((blocContext, state) {
          state.props.isNotEmpty ? messages.insert(0, state.props[0]) : null;
          return state is MessageLoadedState
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.green.shade100, Colors.blue.shade100]),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                messages[index],
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
