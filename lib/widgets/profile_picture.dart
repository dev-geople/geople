import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePictureMedium extends StatelessWidget {
  ProfilePictureMedium({this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(100),
      child: Stack(
        children: <Widget>[
          Center(
              child: SizedBox(
            width: 150,
            height: 150,
            child: Padding(
                padding: EdgeInsets.all(55),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )),
          )),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                width: 150,
                height: 150,
                placeholder: kTransparentImage,
                image: imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePictureSmall extends StatelessWidget {
  ProfilePictureSmall({this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 50,
          width: 50,
          child: Padding(
            padding: EdgeInsets.all(13),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: imageUrl,
            ),
          ),
        ),
      ],
    );
  }
}
