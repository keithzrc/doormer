import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/chatbox_bloc.dart';
import '../bloc/chatbox_event.dart';
import '../bloc/chatbox_state.dart';
import '../widgets/contact_info_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';

/// A page that displays a chat conversation with a specific contact
class ChatboxPage extends StatefulWidget {
  /// The ID of the contact to chat with
  final String contactId;

  /// Creates a new [ChatboxPage]
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
            // ContactInfo header
            BlocBuilder<ChatBloc, ChatState>(
              bloc: BlocProvider.of<ChatBloc>(context, listen: false),
              builder: (context, state) {
                AppLogger.debug('Building header with state: $state');
                if (state is ChatLoadedState) {
                  try {
                    final contact = state.chats.firstWhere(
                      (chat) => chat.id.toString() == widget.contactId,
                    );
                    AppLogger.debug('Found contact: ${contact.userName}');
                    return ContactInfoHeader(
                      contact: contact,
                      onTap: () {},
                    );
                  } catch (e) {
                    AppLogger.error('Error finding contact', e);
                    return _buildErrorHeader('Contact not found');
                  }
                }
                return _buildLoadingHeader();
              },
            ),
            // 消息列表
            Expanded(
              child: BlocBuilder<ChatboxBloc, ChatboxState>(
                builder: (context, state) {
                  if (state is MessagesLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          message: state.messages[index],
                        );
                      },
                    );
                  }
                  if (state is ChatboxError) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            // 输入栏
            MessageInputBar(
              onSendMessage: (content, type) {
                _chatboxBloc.add(
                  SendMessageEvent(
                    Message(
                      id: DateTime.now().toString(),
                      content: content,
                      timestamp: DateTime.now(),
                      isFromMe: true,
                      type: type,
                    ),
                  ),
                );
              },
              onSendFile: (path, type) {
                _chatboxBloc.add(SendFileEvent(path, type));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorHeader(String message) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          'Error: $message',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
