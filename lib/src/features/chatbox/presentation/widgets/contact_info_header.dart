import 'package:flutter/material.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';

class ContactInfoHeader extends StatelessWidget {
  final ContactInfo contact;
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
            radius: 24,
            backgroundImage: NetworkImage(contact.avatarUrl),
            onBackgroundImageError: (exception, stackTrace) {
              AppLogger.error('Error loading avatar', exception, stackTrace);
            },
            child: Text(
              contact.name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 联系人信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      contact.position ?? 'Not Available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Expected: ${contact.expectedSalary ?? 'Not Available'}',
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
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
                const SizedBox(width: 6),
                Text(
                  contact.status,
                  style: TextStyle(
                    fontSize: 14,
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
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
    return contact.status.toLowerCase() == 'active' ? Colors.green : Colors.orange;
  }
}
