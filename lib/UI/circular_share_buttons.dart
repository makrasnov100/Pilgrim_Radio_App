import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';


class CircularShareIconButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final String link;
  final bool isShare;

  const CircularShareIconButton({Key key, this.iconData, this.color, this.link, this.isShare}) : super(key: key);

  _launchURL() async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        onPressed: () {
          if(isShare)
          {
            Share.share(link);
          }
          else
          {
            _launchURL();
          }
        },
        child: FaIcon(
          iconData,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 1.0,
        fillColor: color,
        padding: const EdgeInsets.all(15.0),
      ),
    );
  }
}