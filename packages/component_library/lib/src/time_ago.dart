import 'package:flutter/material.dart';

class TimeAgo extends StatelessWidget {
  const TimeAgo(this.time, {
    this.style,
    super.key,
  });

  final DateTime time;
  final TextStyle? style;

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final diff = difference.inMinutes;
      return '$diff minute${diff>1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final diff = difference.inHours;
      return '$diff hour${diff>1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      final diff = difference.inDays;
      return '$diff day${diff>1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks > 1 ? 'weeks' : 'week'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months > 1 ? 'months' : 'month'} ago';
    } else {
      final years = (difference.inDays / 365);
      final yStr = years.toStringAsFixed(1);
      return '$yStr ${double.parse(yStr) > 1 ? 'years' : 'year'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: '$time'.split('.').first,
        child: Text(timeAgo(time), style: style,));
  }
}
