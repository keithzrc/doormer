import 'package:flutter/material.dart';

class ContactInfo {
  final String name;
  final String position;
  final String expectedSalary;
  final String avatarUrl;

  ContactInfo({
    required this.name,
    required this.position,
    required this.expectedSalary,
    required this.avatarUrl,
  });
}

class ContactInfoHeader extends StatelessWidget {
  final ContactInfo contactInfo;

  const ContactInfoHeader({
    Key? key,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: contactInfo.avatarUrl.isNotEmpty
                  ? NetworkImage(contactInfo.avatarUrl) as ImageProvider
                  : const AssetImage('assets/default_avatar.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactInfo.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Position: ${contactInfo.position}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Expected Salary: ${contactInfo.expectedSalary}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
