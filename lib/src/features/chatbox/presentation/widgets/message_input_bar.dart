import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/message_entity.dart';
import 'emoji_picker.dart';

class MessageInputBar extends StatefulWidget {
  final Function(String, MessageType) onSendMessage;
  final Function(String, MessageType) onSendFile;

  const MessageInputBar({
    Key? key,
    required this.onSendMessage,
    required this.onSendFile,
  }) : super(key: key);

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        widget.onSendFile(file.name!, MessageType.file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (image != null) {
        widget.onSendFile(image.name, MessageType.image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  void _handleSendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text, MessageType.text);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickFile,
                  tooltip: 'Send file',
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                  tooltip: 'Send image',
                ),
                IconButton(
                  icon: Icon(
                    _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                  ),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                  tooltip: 'Show emojis',
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isComposing ? _handleSendMessage : null,
                  color: _isComposing ? Theme.of(context).primaryColor : null,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: EmojiPicker(
              onEmojiSelected: (emoji) {
                widget.onSendMessage(emoji, MessageType.emoji);
                setState(() {
                  _showEmojiPicker = false;
                });
              },
            ),
          ),
      ],
    );
  }
}