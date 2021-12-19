import 'package:flutter/material.dart';

class PlaylistImageWidget extends StatelessWidget {
  /// The url to the image
  final String image;

  /// The dimensions of the image
  final double width, height;

  /// Constructor
  const PlaylistImageWidget({Key? key, required this.image, required this.width, required this.height})
      : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return image == ''
        ? Image(
            width: width,
            height: height,
            image: const AssetImage('assets/preview_image.png'),
          )
        : FadeInImage(
            width: width,
            height: height,
            image: NetworkImage(image),
            placeholder: const AssetImage('assets/preview_image.png'),
          );
  }
}
