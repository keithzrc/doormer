import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:logging/logging.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';

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
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _logger.info(
        'Initializing ChatboxPage for user: ${widget.userId}, contact: ${widget.contactId}');

    // 设置 SignalR 消息接收处理器
    widget.signalRService.hubConnection.on("ReceiveMessage", (args) {
      if (args!.isEmpty) {}
      setState(() {
        _messages.add({
          "from": args[0] as String,
          "message": args[1] as String,
          "timestamp": DateTime.now().toIso8601String(),
        });
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.signalRService.sendMessage(widget.contactId, message);
      setState(() {
        _messages.add({
          "from": widget.userId,
          "message": message,
          "timestamp": DateTime.now().toIso8601String(),
        });
        _messageController.clear();
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Chat with ${widget.contactName}',
            style: AppTextStyles.displayMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isFromMe = message['from'] == widget.userId;
              final timestamp = DateTime.parse(message['timestamp'] ?? '');

              return Column(
                children: [
                  if (index == 0 || _shouldShowTimestamp(index))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _formatTimestamp(timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Align(
                    alignment:
                        isFromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isFromMe ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message['message'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
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
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _shouldShowTimestamp(int index) {
    if (index == 0) return true;
    final currentTimestamp =
        DateTime.parse(_messages[index]['timestamp'] ?? '');
    final previousTimestamp =
        DateTime.parse(_messages[index - 1]['timestamp'] ?? '');
    return currentTimestamp.difference(previousTimestamp).inMinutes > 5;
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    //widget.signalRService.onMessageReceived = null;
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
