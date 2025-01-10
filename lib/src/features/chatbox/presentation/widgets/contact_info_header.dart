import 'package:flutter/material.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/core/utils/app_logger.dart';

class ContactInfoHeader extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactInfoHeader({
    Key? key,
    required this.contact,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromARGB(255, 152, 33, 243),
            backgroundImage: contact.avatarUrl.isNotEmpty
                ? NetworkImage(contact.avatarUrl)
                : null,
            onBackgroundImageError: (exception, stackTrace) {
              AppLogger.error('Error loading avatar', exception, stackTrace);
            },
            child: contact.avatarUrl.isEmpty
                ? Text(
                    contact.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          // 联系人信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // 状态指示器
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  contact.isRead ? 'Active' : 'Away',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    return contact.isRead ? Colors.green : Colors.orange;
  }
}
