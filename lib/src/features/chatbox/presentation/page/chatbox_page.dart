import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:signalr_netcore/hub_connection.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';
import '../bloc/chatbox_bloc.dart';
import '../bloc/chatbox_event.dart';
import '../bloc/chatbox_state.dart';
import '../widgets/contact_info_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';
import 'package:uuid/uuid.dart';

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
  final HubConnection _hubConnection = serviceLocator<HubConnection>();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();

    // 初始化 ChatboxBloc
    _chatboxBloc = serviceLocator<ChatboxBloc>();
    _chatboxBloc.add(LoadMessages(widget.contactId));

    _hubConnection.on("ReceiveMessage", (args) {
      if (args!.isNotEmpty) {
        final message = Message(
          id: _uuid.v4(),
          contactId: widget.contactId,
          content: args[1],
          timestamp: DateTime.now(),
          isFromMe: false, // SignalR 收到的消息通常来自对方
          type: MessageType.text, // 假设收到的消息为文本类型
        );
        _chatboxBloc.add(ReceiveMessageEvent(message)); // 将消息交给 Bloc
      }
    });
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
    if (content.trim().isEmpty) return;

    final message = Message(
      id: _uuid.v4(),
      contactId: widget.contactId,
      content: content.trim(),
      timestamp: DateTime.now(),
      isFromMe: true,
      type: type,
    );
    final HubConnection _hubConnection = serviceLocator<HubConnection>();
    try {
      _chatboxBloc.add(SendMessageEvent(message));
      _hubConnection.invoke("SendMessage",
          args: [widget.contactId, content]); // 同步发送到 SignalR
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  void _handleSendFile(String path, MessageType type) {
    if (path.trim().isEmpty) {
      return; // 基本验证：不允许发送空路径
    }

    try {
      _chatboxBloc.add(SendFileEvent(path.trim(), type));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send file. Please try again.'),
        ),
      );
    }
  }
}
