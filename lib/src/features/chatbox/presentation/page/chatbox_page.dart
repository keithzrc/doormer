import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chatbox/domain/usecase/chatbox_usecase.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:logging/logging.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_bloc.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_event.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_state.dart';
import '../../domain/entities/message_entity.dart';
import 'package:doormer/src/core/di/service_locator.dart';

final _logger = Logger('ChatboxPage');

class ChatboxPage extends StatefulWidget {
  final String userId;
  final String contactId;
  final String contactName;
  final SignalRService signalRService;

  const ChatboxPage({
    super.key,
    required this.userId,
    required this.contactId,
    required this.contactName,
    required this.signalRService,
  });

  @override
  State<ChatboxPage> createState() => _ChatboxPageState();
}

class _ChatboxPageState extends State<ChatboxPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatboxBloc(
        getMessages: serviceLocator<GetMessages>(),
        sendMessage: serviceLocator<SendMessage>(),
        sendFile: serviceLocator<SendFile>(),
       // getContactInfo: serviceLocator<GetContactInfo>(),
        signalRService: widget.signalRService,
        userId: widget.userId,
      ),
      child: _ChatboxView(
        userId: widget.userId,
        contactId: widget.contactId,
        contactName: widget.contactName,
        messageController: _messageController,
        scrollController: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _ChatboxView extends StatefulWidget {
  final String userId;
  final String contactId;
  final String contactName;
  final TextEditingController messageController;
  final ScrollController scrollController;

  const _ChatboxView({
    required this.userId,
    required this.contactId,
    required this.contactName,
    required this.messageController,
    required this.scrollController,
  });

  @override
  State<_ChatboxView> createState() => _ChatboxViewState();
}

class _ChatboxViewState extends State<_ChatboxView> {
  late final ChatboxBloc _chatboxBloc;

  @override
  void initState() {
    super.initState();
    _chatboxBloc = context.read<ChatboxBloc>();
    
    // 加载消息
    _chatboxBloc.add(LoadMessages(widget.contactId));
    // 加载联系人信息
   // _chatboxBloc.add(LoadContactInfo(widget.contactId));

    // 重新添加 SignalR 处理
    _setupSignalRHandler();
  }

  void _setupSignalRHandler() {
    _chatboxBloc.signalRService.hubConnection.on("ReceiveMessage", (args) {
      if (args != null && args.isNotEmpty) {
        final message = Message(
          id: DateTime.now().toString(),
          content: args[1] as String,
          timestamp: DateTime.now(),
          isFromMe: args[0] == widget.userId,
          type: MessageType.text,
          contactId: args[0] as String,
        );
        _chatboxBloc.add(ReceiveMessageEvent(message));
      }
    });
  }

  @override
  void dispose() {
    // 清理 SignalR 处理器
    _chatboxBloc.signalRService.hubConnection.off("ReceiveMessage");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatboxBloc, ChatboxState>(
      listener: (context, state) {
        if (state is MessageSent) {
          widget.messageController.clear();
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            _buildHeader(),
            _buildMessageList(state),
            _buildInputArea(),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        'Chat with ${widget.contactName}',
        style: AppTextStyles.displayMedium,
      ),
    );
  }

  Widget _buildMessageList(ChatboxState state) {
    if (state is MessagesLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is MessagesLoaded) {
      return Expanded(
        child: ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: state.messages.length,
          itemBuilder: (context, index) =>
              _buildMessageItem(state.messages[index], index, state),
        ),
      );
    }

    return const Expanded(child: SizedBox());
  }

  Widget _buildMessageItem(Message message, int index, ChatboxState state) {
    final isFromMe = message.isFromMe;
    return Column(
      children: [
        if (index == 0 || _shouldShowTimestamp(index, state))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        Align(
          alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isFromMe ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message.content, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.messageController,
              decoration: const InputDecoration(
                hintText: 'Enter message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _handleSendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSendMessage,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  void _handleSendMessage() {
    final content = widget.messageController.text.trim();
    if (content.isNotEmpty) {
      final message = Message(
        id: DateTime.now().toString(),
        content: content,
        timestamp: DateTime.now(),
        isFromMe: true,
        type: MessageType.text,
        contactId: widget.contactId,
      );
      _chatboxBloc.add(SendMessageEvent(message));
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _shouldShowTimestamp(int index, ChatboxState state) {
    if (state is MessagesLoaded) {
      final messages = state.messages;
      if (index == 0) return true;
      final currentMessage = messages[index];
      final previousMessage = messages[index - 1];
      return currentMessage.timestamp
              .difference(previousMessage.timestamp)
              .inMinutes >
          5;
    }
    return false;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
