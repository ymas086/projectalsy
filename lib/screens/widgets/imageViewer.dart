import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({Key key, @required this.image});

  final Image image;

  @override
  Widget build(BuildContext context) {
    void onImageClick(Image image) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Configure Test'),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return Center(
                      heightFactor: 1.0,
                      child: InteractiveViewer(
                        panEnabled: true,
                        // Set it to false
                        boundaryMargin: EdgeInsets.all(10),
                        minScale: 0.5,
                        maxScale: 5,
                        child: image,
                      ),
                    );
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Close'),
                    child: const Text('Close'),
                  ),
                ],
              ));
    }

    return GestureDetector(
      onTap: () => onImageClick(image),
      child: image,
    );
  }
}
