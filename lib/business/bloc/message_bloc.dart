import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_event.dart';
import 'message_state.dart';
import 'package:chatapp/data/repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Repository repository;

  @override
  MessageBloc(this.repository) : super(MessageLoadingState()) {
    repository.firePusher('private-v1.licenses.20690.messengers.telegram', 'message');
    on<GetMessageEvent>((event, emit) async {
      await emit.forEach(
        repository.eventStream,
        onData: (String message) {
          return MessageLoadedState(message);
        },
      );
    });
  }

  @override
  Future<void> close() {
    repository.dispose('private-v1.licenses.20690.messengers.telegram', 'message');
    return super.close();
  }
}
