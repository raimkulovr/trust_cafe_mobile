import 'package:flutter/material.dart';

import 'image_viewer.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    required this.userId,
    required this.isProduction,
    required this.imageSizeThreshold,
    this.allowActions = false,
    super.key,
  });

  final String userId;
  final bool isProduction;
  final bool allowActions;
  final double? imageSizeThreshold;

  @override
  Widget build(BuildContext context) {
    final imageData = ImageData(
      src: 'https://wts2-${isProduction ? 'production' : 'alpha'}-post-uploads.s3.amazonaws.com/profilepics/$userId',
    );

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: AsyncImageViewer(imageData,
              imageFit: BoxFit.cover,
              imageProvider: CustomImageProvider(images: [imageData], initialIndex: 0, type: ImageType.profile,),
              type: ImageType.profile,
              allowActions: allowActions,
              imageSizeThreshold: imageSizeThreshold,
            ),
          ),
        ),
      ),
    );
  }
}
