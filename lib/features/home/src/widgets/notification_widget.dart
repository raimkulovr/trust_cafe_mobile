import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget(this.notification, {
    required this.isProduction,
    required this.imageSizeThreshold,
    super.key});

  final Notification notification;
  final bool isProduction;
  final double? imageSizeThreshold;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reason = notification.reason;
    final initiator = notification.item.initiator;
    final replacements = notification.item.replacements;

    return notification.isTrustBoost || notification.isRankUp
        ? ListTile(
            leading: initiator.isSystem
                ? const SizedBox.square(dimension: 40, child: Icon(Icons.notifications),)
                : ProfilePictureWidget(
                    userId: initiator.userId,
                    isProduction: isProduction,
                    imageSizeThreshold: imageSizeThreshold,
                  ),
            title: RichText(text: TextSpan(children: [
              if(!initiator.isSystem) TextSpan(text: initiator.fullName, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),),
              if(initiator.trustName!=null) TextSpan(text: ' (${initiator.trustName}) ', style: TextStyle(fontWeight: FontWeight.w300, color: colorScheme.onSurface),),
              TextSpan(text: '$reason ${notification.isTrustBoost ? '${replacements.ratingPercentage}% trust boost':'to ${replacements.newLevel ?? ''}!'}', style: TextStyle(color: colorScheme.onSurface)),
            ],)),
            subtitle: RichText(text: TextSpan(children: [
              TextSpan(text: TimeAgo.timeAgo(DateTime.fromMillisecondsSinceEpoch(notification.createdAt)), style: TextStyle(color: colorScheme.onSurface)),
              if(!notification.item.read) const TextSpan(text: ' (new)', style: TextStyle(color: Colors.pink),),
            ],
            ),
              maxLines: 2,
            ),
          )
        : ExpandableNotificationWidget(notification, isProduction, imageSizeThreshold: imageSizeThreshold,);
  }
}




class ExpandableNotificationWidget extends StatefulWidget {
  const ExpandableNotificationWidget(this.notification, this.isProduction, {required this.imageSizeThreshold, super.key});

  final Notification notification;
  final bool isProduction;
  final double? imageSizeThreshold;

  @override
  State<ExpandableNotificationWidget> createState() => _ExpandableNotificationWidgetState();
}

class _ExpandableNotificationWidgetState extends State<ExpandableNotificationWidget> {

  bool isExpanded = false;

  late final Notification notification;
  late final Author initiator;

  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  void initState() {
    notification = widget.notification;
    initiator = notification.item.initiator;
    super.initState();
  }

  void switchIsExpanded(){
    setState(() {
      isExpanded=!isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final replacements = notification.item.replacements;
    return ListTile(
      // isThreeLine: true,
      leading: ProfilePictureWidget(
        userId: initiator.userId,
        isProduction: widget.isProduction,
        imageSizeThreshold: widget.imageSizeThreshold,
      ),
      title: RichText(text: TextSpan(children: [
        TextSpan(text: initiator.fullName, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),),
        if(initiator.trustName!=null) TextSpan(text: ' (${initiator.trustName}) ', style: TextStyle(fontWeight: FontWeight.w300, color: colorScheme.onSurface),),
        TextSpan(text: '${notification.reason} ${notification.isTrustBoost ? '${notification.item.replacements.ratingPercentage}% trust boost':''}', style: TextStyle(color: colorScheme.onSurface)),
      ],)),
      trailing: (replacements.commentSnippet!=null ||  replacements.postSnippet!=null) ? IconButton(onPressed: switchIsExpanded, icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more)) : null,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isExpanded && (replacements.commentSnippet !=null ||  replacements.postSnippet!=null)
            ? Column(
                children: [
                  ExpandableHtmlWidget(
                      html: replacements.commentSnippet ?? replacements.postSnippet!,
                      horizontalPadding: 0,
                    allowSelection: false,
                    gradientColor: colorScheme.surfaceContainer,
                    imageSizeThreshold: widget.imageSizeThreshold,
                  ),
                  const Divider(),
                ],
              )
            : const SizedBox(height: 4,),
          RichText(text: TextSpan(children: [
              TextSpan(text: TimeAgo.timeAgo(DateTime.fromMillisecondsSinceEpoch(notification.createdAt)), style: TextStyle(color: colorScheme.onSurface)),
              if(!notification.item.read) const TextSpan(text: ' (new)', style: TextStyle(color: Colors.pink),),
              ],
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
