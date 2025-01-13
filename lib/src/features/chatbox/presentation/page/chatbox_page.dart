import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../bloc/chatbox_bloc.dart';
import '../bloc/chatbox_event.dart';
import '../bloc/chatbox_state.dart';
import '../widgets/contact_info_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';

class ChatboxPage extends StatefulWidget {
  final String contactId;

  const ChatboxPage({
    super.key,
    required this.contactId,
  });

  @override
  State<ChatboxPage> createState() => _ChatboxPageState();
}

class _ChatboxPageState extends State<ChatboxPage> {
  final ScrollController _scrollController = ScrollController();
  late final ChatboxBloc _chatboxBloc;

  @override
  void initState() {
    super.initState();
    _chatboxBloc = serviceLocator<ChatboxBloc>();
    _chatboxBloc.add(LoadMessages(widget.contactId));
  }

  @override
  void dispose() {
    _chatboxBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatboxBloc,
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            _buildMessageList(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: BlocProvider.of<ChatBloc>(context, listen: false),
      builder: (context, state) {
        if (state is ChatLoadedState) {
          final contact = state.chats.firstWhere(
            (chat) => chat.id.toString() == widget.contactId,
            orElse: () => throw Exception('Contact not found'),
          );
          
          return ContactInfoHeader(
            contact: ContactInfo(
              id: contact.id,
              name: contact.userName,
              avatarUrl: contact.avatarUrl,
              status: contact.isRead ? 'Active' : 'Away',
            ),
          );
        }
        return const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: BlocBuilder<ChatboxBloc, ChatboxState>(
        builder: (context, state) {
          if (state is MessagesLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) => MessageBubble(
                message: state.messages[index],
              ),
            );
          }
          if (state is ChatboxError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return MessageInputBar(
      onSendMessage: _handleSendMessage,
      onSendFile: _handleSendFile,
    );
  }

  void _handleSendMessage(String content, MessageType type) {
    final message = Message(
      id: DateTime.now().toString(),
      content: content,
      timestamp: DateTime.now(),
      isFromMe: true,
      type: type,
    );
    _chatboxBloc.add(SendMessageEvent(message));
  }

  void _handleSendFile(String path, MessageType type) {
    _chatboxBloc.add(SendFileEvent(path, type));
  }
}
