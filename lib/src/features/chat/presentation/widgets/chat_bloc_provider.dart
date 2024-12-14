import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_event.dart';

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
      create: (context) => ChatBloc(
        getChatList: context.read(),
        getArchivedChatList: context.read(),
        archiveChat: context.read(),
        deleteChat: context.read(),
      )..add(event),
      child: child,
    );
  }
}
