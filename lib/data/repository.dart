import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pusher_client/pusher_client.dart';
import 'dart:convert';

class Repository {
  final StreamController<String> _eventData = StreamController<String>();
  late PusherClient pusher;
  late Channel channel;

  Sink get _inEventData => _eventData.sink;
  Stream<String> get eventStream => _eventData.stream;

  Future<void> initPusher() async {
    http.Response response = await http.get(
      Uri.parse('https://api.chatapp.online/v1/tokens/check'),
      headers: {
        'Authorization': '\$2y\$10\$sFLMCLfFPIjYNkiXCq/no.LwdkPVaAZkxf5Z62/Wb40orxuc7Glw.',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse['success']) {
      PusherAuth auth = PusherAuth(
        'https://api.chatapp.online/broadcasting/auth',
        headers: {
          'Authorization': decodedResponse['data']['accessToken'],
        },
      );

      pusher = PusherClient(
        'ChatsAppApiProdKey',
        PusherOptions(
          host: 'api.chatapp.online',
          wssPort: 6001,
          auth: auth,
        ),
      );
    }
  }

  @override
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

  void bindEvent(String eventName) {
    channel.bind(eventName, (last) {
      final String data = last!.data.toString();
      Map<String, dynamic> messageText = jsonDecode(data.toString());
      messageText['payload']['data'][0]['fromUser']['username'] == 'chatapptest'
          ? _inEventData.add(messageText['payload']['data'][0]['message']['text'])
          : null;
    });
  }

  void dispose(String channelName, String eventName) {
    pusher.unsubscribe(channelName);
    channel.unbind(eventName);
    _eventData.close();
  }
}
