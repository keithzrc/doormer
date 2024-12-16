import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';

class ChatBlocProvider extends StatelessWidget {
  final Widget child;
  final ChatEvent event;

  const ChatBlocProvider({
    super.key,
    required this.child,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatArchiveBloc(
        getChatListUseCase: context.read(),
        getArchivedChatListUseCase: context.read(),
        archiveChatUseCase: context.read(),
        // unarchiveChatUseCase: context.read(),
        deleteChatUseCase: context.read(),
      )..add(event),
      child: child,
    );
  }
}
