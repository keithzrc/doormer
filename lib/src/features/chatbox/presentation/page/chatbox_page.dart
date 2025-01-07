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

class _ChatboxPageState extends State<ChatboxPage> with AutomaticKeepAliveClientMixin {
  late final ChatboxBloc _chatboxBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('ChatboxPage initState with ID: ${widget.contactId}');
    _initializeBloc();
  }

  void _initializeBloc() {
    print('Initializing ChatboxBloc with ID: ${widget.contactId}');
    _chatboxBloc = ChatboxBloc(
      getMessages: GetIt.instance<GetMessages>(),
      sendMessage: GetIt.instance<SendMessage>(),
      sendFile: GetIt.instance<SendFile>(),
      getContactInfo: GetIt.instance<GetContactInfo>(),
    )..add(LoadContactInfo(widget.contactId))
      ..add(LoadMessages(widget.contactId));
  }

  @override
  void didUpdateWidget(ChatboxPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contactId != widget.contactId) {
      print('Contact ID changed from ${oldWidget.contactId} to ${widget.contactId}');
      _chatboxBloc.close();
      _initializeBloc();
    }
  }

  @override
  void dispose() {
    print('Disposing ChatboxPage');
    _chatboxBloc.close();
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
    super.build(context);
    print('Building ChatboxPage with contactId: ${widget.contactId}');
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatboxBloc),
      ],
      child: BlocListener<ChatboxBloc, ChatboxState>(
        listener: (context, state) {
          print('ChatboxBloc state changed: $state');
          if (state is ChatboxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ChatboxBloc, ChatboxState>(
              builder: (context, state) {
                print('AppBar BlocBuilder state: $state');
                if (state is ContactInfoLoaded) {
                  return ContactInfoHeader(contactInfo: state.contactInfo);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            toolbarHeight: 120,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 2,
            automaticallyImplyLeading: true,
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
      ),
    );
  }
}
