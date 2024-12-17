import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chatbox_bloc.dart';
import '../bloc/chatbox_event.dart';
import '../bloc/chatbox_state.dart';
import '../widgets/contact_info_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';
import '../../domain/entities/message_entity.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecase/chatbox_usecase.dart';

class ChatboxPage extends StatefulWidget {
  final String contactId;

  const ChatboxPage({
    Key? key,
    required this.contactId,
  }) : super(key: key);

  @override
  State<ChatboxPage> createState() => _ChatboxPageState();
}

class _ChatboxPageState extends State<ChatboxPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final getIt = GetIt.instance;
        return ChatboxBloc(
          getMessages: getIt<GetMessages>(),
          sendMessage: getIt<SendMessage>(),
          sendFile: getIt<SendFile>(),
          getContactInfo: getIt<GetContactInfo>(),
        )
          ..add(LoadMessages(widget.contactId))
          ..add(LoadContactInfo(widget.contactId));
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ChatboxBloc, ChatboxState>(
            builder: (context, state) {
              if (state is ContactInfoLoaded) {
                return Text(state.contactInfo.name);
              }
              return const Text('Chat');
            },
          ),
          actions: [
            BlocBuilder<ChatboxBloc, ChatboxState>(
              builder: (context, state) {
                if (state is ContactInfoLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      _showContactInfo(context, state.contactInfo);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatboxBloc, ChatboxState>(
                listener: (context, state) {
                  if (state is MessageSent) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text('No messages yet'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return MessageBubble(
                          message: message,
                          key: ValueKey(message.id),
                        );
                      },
                    );
                  }

                  if (state is ChatboxError) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocBuilder<ChatboxBloc, ChatboxState>(
              builder: (context, state) {
                if (state is MessageSending) {
                  return const LinearProgressIndicator();
                }
                return const SizedBox.shrink();
              },
            ),
            MessageInputBar(
              onSendMessage: (content, type) {
                final message = Message(
                  id: DateTime.now().toString(), // 临时ID，实际应由后端生成
                  content: content,
                  timestamp: DateTime.now(),
                  isFromMe: true,
                  type: type,
                );
                context.read<ChatboxBloc>().add(SendMessageEvent(message));
              },
              onSendFile: (path, type) {
                context.read<ChatboxBloc>().add(SendFileEvent(path, type));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContactInfo(BuildContext context, contactInfo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContactInfoHeader(contactInfo: contactInfo),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.work),
              title: Text('Position: ${contactInfo.position}'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text('Expected Salary: ${contactInfo.expectedSalary}'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('Status: ${contactInfo.status}'),
            ),
          ],
        ),
      ),
    );
  }
}
