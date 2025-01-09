import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecase/chatbox_usecase.dart';
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

class _ChatboxPageState extends State<ChatboxPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => ChatboxBloc(
        getMessages: GetIt.instance<GetMessages>(),
        sendMessage: GetIt.instance<SendMessage>(),
        sendFile: GetIt.instance<SendFile>(),
        getContactInfo: GetIt.instance<GetContactInfo>(),
      )..add(LoadContactInfo(widget.contactId))
        ..add(LoadMessages(widget.contactId)),
      child: BlocListener<ChatboxBloc, ChatboxState>(
        listener: (context, state) {
          if (state is ChatboxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ChatboxBloc, ChatboxState>(
        builder: (context, state) {
          if (state is ContactInfoLoaded) {
            return ContactInfoHeader(contactInfo: state.contactInfo);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      toolbarHeight: 120,
      backgroundColor: Theme.of(context).cardColor,
      elevation: 2,
      automaticallyImplyLeading: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatboxBloc, ChatboxState>(
            builder: (context, state) {
              if (state is MessagesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MessagesLoaded) {
                if (state.messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: state.messages[index]);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        MessageInputBar(
          onSendMessage: (content, type) {
            context.read<ChatboxBloc>().add(
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
            context.read<ChatboxBloc>().add(SendFileEvent(path, type));
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
