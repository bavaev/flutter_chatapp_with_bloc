import 'package:equatable/equatable.dart';

import 'package:chatapp/business/models/message.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class GetMessageEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}
