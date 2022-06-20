import 'package:equatable/equatable.dart';

import 'package:chatapp/business/models/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageLoadingState extends MessageState {
  @override
  List<String> get props => [];
}

class MessageLoadedState extends MessageState {
  final String message;

  const MessageLoadedState(this.message);

  @override
  List<Object> get props => [message];
}
