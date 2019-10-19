import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momento/screens/components/image_viewer.dart';
import 'package:page_transition/page_transition.dart';

/// UI part for viewable image
class ViewableImage extends StatelessWidget {
  final String url;
  ViewableImage(this.url);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ImageViewer(url),
          ),
        );
      },
      child: ExtendedImage.network(
        url,
        fit: BoxFit.fitWidth,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return SpinKitPumpingHeart(
                color: Colors.white,
              );
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
              );
            case LoadState.failed:
              return GestureDetector(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Text("???"),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Text(
                        "load image failed, click to reload",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
