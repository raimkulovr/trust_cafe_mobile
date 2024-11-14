import 'package:component_library/src/expandable_html_widget.dart';
import 'package:component_library/src/image_viewer.dart';
import 'package:component_library/src/time_ago.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, {required this.isProduction, super.key});

  final Comment comment;
  final bool isProduction;

  Widget _buildCommentHeader({required double horizontalPadding}){
    final author = comment.data.createdByUser;
    final imageTag = ImageData(
      src: 'https://wts2-${isProduction? 'production' : 'alpha'}-post-uploads.s3.amazonaws.com/profilepics/${author.userId}',
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: horizontalPadding),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: ClipOval(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ImageViewer(imageTag,
                    imageFit: BoxFit.cover,
                    imageProvider: CustomImageProvider(images: [imageTag], initialIndex: 0),
                    type: ImageType.profile,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(author.fullName, style: const TextStyle(fontWeight: FontWeight.bold),),
                      if(author.trustName!=null) Text(' (${author.trustName})', style: const TextStyle(fontWeight: FontWeight.w300),),
                      const SizedBox(width: 10,),
                      TimeAgo(DateTime.fromMillisecondsSinceEpoch(comment.createdAt)),
                    ],),
                  if(comment.data.comment!=null) Text('replied to ${comment.data.comment!.createdByUser.fullName}')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCommentHeader(horizontalPadding: 7),
        // const Divider(),
        ExpandableHtmlWidget(html: comment.commentText, maxHeight: 200),
        // const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Row(children: [
            Text('reply', style: TextStyle(color: Colors.black54),),
            Spacer(),
            const Icon(Icons.arrow_upward),
            Text(comment.statistics.voteValueSum.toString()),
            const Icon(Icons.arrow_downward),
          ],),
        )
      ],
    );
  }
}
