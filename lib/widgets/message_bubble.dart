import 'package:flutter/material.dart';
import '../config/index.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isCurrentUser;
  final String timestamp;

  const MessageBubble({
    required this.text,
    required this.isCurrentUser,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Constants.paddingSmall,
        horizontal: Constants.paddingMedium,
      ),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.paddingMedium,
                vertical: Constants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? AppTheme.primaryColor
                    : AppTheme.greyColor,
                borderRadius: BorderRadius.circular(
                  Constants.borderRadiusMedium,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(timestamp, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
