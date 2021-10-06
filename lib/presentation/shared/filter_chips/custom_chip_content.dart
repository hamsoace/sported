import 'package:flutter/material.dart';

class CustomChipContent extends StatefulWidget {
  final Widget child;

  CustomChipContent({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _CustomChipContentState createState() => _CustomChipContentState();
}

class _CustomChipContentState extends State<CustomChipContent> with AutomaticKeepAliveClientMixin<CustomChipContent> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.child,
      ],
    );
  }
}
