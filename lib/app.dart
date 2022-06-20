import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController<String> _eventData = StreamController<String>();
  late PusherClient pusher;
  late Channel channel;

  Future<void> initPusher() async {
    PusherAuth auth = PusherAuth(
      'https://api.chatapp.online/broadcasting/auth',
      headers: {},
    );

    http.Response response = await http.get(
      Uri.parse('https://api.chatapp.online/v1/tokens/check'),
      headers: {
        'Authorization': '\$2y\$10\$.tJOAB6O.ff0xXusQXm8heyGN6YD4QdhDSQUqF0rgvkDrKVzuWev2',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (jsonDecode(response.body)['success'] == 'true') {
      auth = PusherAuth(
        'https://api.chatapp.online/broadcasting/auth',
        headers: {
          'Authorization': jsonDecode(response.body)['data']['accessToken'],
        },
      );
    } else {
      http.Response response = await http.post(
        Uri.parse('https://api.chatapp.online/v1/tokens/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Refresh': 'quo',
        },
      );
    }

    pusher = PusherClient(
      'ChatsAppApiProdKey',
      PusherOptions(
        host: 'api.chatapp.online',
        wssPort: 6001,
        auth: auth,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    firePusher('private-5377148715h2814302583747762396.licenses.20690.messengers.telegram', 'message');
  }

  Future<void> firePusher(String channelName, String eventName) async {
    await initPusher();
    connectPusher();
    await subscribePusher(channelName);
    bindEvent(eventName);
  }

  void connectPusher() {
    pusher.connect();
    pusher.onConnectionStateChange((state) {
      print('previousState: ${state!.previousState}, currentState: ${state.currentState}');
    });
    pusher.onConnectionError((error) {
      print('error: ${error!.message}');
    });
  }

  Future<void> subscribePusher(String channelName) async {
    channel = pusher.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    pusher.unsubscribe(channelName);
  }

  void bindEvent(String eventName) {
    channel.bind(eventName, (last) {
      print('123');
      print(last);
      final String data = last!.data.toString();
      _inEventData.add(data);
    });
  }

  void unbindEvent(String eventName) {
    channel.unbind(eventName);
    _eventData.close();
  }

  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          }
          return const Center(child: SizedBox());
        },
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
