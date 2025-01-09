import 'package:flutter/material.dart';
import '../../domain/entities/contact_info_entity.dart';

class ContactInfoHeader extends StatelessWidget {
  final ContactInfo contactInfo;
  final VoidCallback? onTap;

  const ContactInfoHeader({
    Key? key,
    required this.contactInfo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildName(context),
                  const SizedBox(height: 4),
                  _buildStatusRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: contactInfo.avatarUrl.isNotEmpty
              ? NetworkImage(contactInfo.avatarUrl) as ImageProvider
              : const AssetImage('assets/default_avatar.png'),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      contactInfo.name,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            contactInfo.position,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${contactInfo.expectedSalary}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (contactInfo.status.toLowerCase()) {
      case 'online':
      case 'active':
        return Colors.green;
      case 'away':
        return Colors.orange;
      case 'busy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
