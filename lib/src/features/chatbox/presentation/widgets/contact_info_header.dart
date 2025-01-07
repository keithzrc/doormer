import 'package:flutter/material.dart';
import '../../domain/entities/contact_info_entity.dart';

class ContactInfoHeader extends StatelessWidget {
  final ContactInfo contactInfo;

  const ContactInfoHeader({
    Key? key,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building ContactInfoHeader with: ${contactInfo.name}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: contactInfo.avatarUrl.isNotEmpty
                ? NetworkImage(contactInfo.avatarUrl) as ImageProvider
                : const AssetImage('assets/default_avatar.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contactInfo.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Position: ${contactInfo.position}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Expected Salary: ${contactInfo.expectedSalary}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Status: ${contactInfo.status}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
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
}
