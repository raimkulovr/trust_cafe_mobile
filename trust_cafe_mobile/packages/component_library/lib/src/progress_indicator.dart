import 'package:flutter/material.dart';

class ComponentProgressIndicator extends StatelessWidget {
  const ComponentProgressIndicator({
    this.maxHeight = 76,
    super.key,
  });

  final double maxHeight;

  Widget buildProgressIndicator(){
    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxHeight,
      ),
      child: SizedBox.square(
        dimension: maxHeight,
        child: Center(
            child: buildProgressIndicator()
        ),
      ),
    );
  }
}

class ImageProgressIndicator extends ComponentProgressIndicator {
  const ImageProgressIndicator({
    required this.progress,
    this.showText = true,
    super.key
  });

  final bool showText;
  final ImageChunkEvent progress;

  @override
  Widget buildProgressIndicator() {
    final bytesExpected = progress.expectedTotalBytes;
    final bytesLoaded = progress.cumulativeBytesLoaded;

    if (bytesExpected != null) {
      double percentage = (bytesLoaded / bytesExpected) * 100;
      String loadedText = '${bytesLoaded.inMegabytes.toStringAsFixed(2)} / ${bytesExpected.inMegabytes.toStringAsFixed(2)} MB';
      return FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: bytesLoaded / bytesExpected),
            if(showText)
              ...[const SizedBox(height: 8.0),
                  Text('$loadedText (${percentage.toStringAsFixed(2)}%)')],
          ],
        ),
      );
    }
    return super.buildProgressIndicator();
  }

}

extension ByteConversion on int {
  double get inMegabytes => this / (1024 * 1024);
}


class ComponentLinearProgressIndicator extends StatelessWidget {
  const ComponentLinearProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 25, maxWidth: 40),
          child: const LinearProgressIndicator()),
    );
  }
}
