import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RefectoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RefectoryAppBar({Key key, this.pageName}) : super(key: key);
  final String pageName;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("${this.pageName}"),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.userCircle),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        )
      ],
    );
  }
}
