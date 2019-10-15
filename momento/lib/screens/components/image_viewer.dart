import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class image_viewer extends StatelessWidget {
  final String url;

  double initScale({Size imageSize, Size size, double initialScale}) {
    var n1 = imageSize.height / imageSize.width;
    var n2 = size.height / size.width;
    if (n1 > n2) {
      final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      Size destinationSize = fittedSizes.destination;
      return size.width / destinationSize.width;
    } else if (n1 / n2 < 1 / 4) {
      final FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, size);
      //final Size sourceSize = fittedSizes.source;
      Size destinationSize = fittedSizes.destination;
      return size.height / destinationSize.height;
    }

    return initialScale;
  }

  image_viewer(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(builder: (_, c) {
                Size size = Size(c.maxWidth, c.maxHeight);
                return ExtendedImage.network(
                  url,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) {
                    double initialScale = 1.0;
                    if (state.extendedImageInfo != null && state.extendedImageInfo.image != null) {
                      initialScale = initScale(
                        size: size,
                        initialScale: initialScale,
                        imageSize: Size(
                          state.extendedImageInfo.image.width.toDouble(),
                          state.extendedImageInfo.image.height.toDouble(),
                        ),
                      );
                    }
                    return GestureConfig(
                      minScale: 0.9,
                      animationMinScale: 0.1,
                      maxScale: 3.0,
                      animationMaxScale: 20,
                      speed: 1.0,
                      inertialSpeed: 100.0,
                      initialScale: initialScale,
                      inPageView: false,
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
