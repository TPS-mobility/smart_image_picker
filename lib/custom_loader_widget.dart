import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatefulWidget {
  final bool isTrue;
  final Widget child;
  CustomLoaderWidget({Key key, @required this.isTrue, @required this.child})
      : super(key: key);

  @override
  _CustomLoaderWidgetState createState() => _CustomLoaderWidgetState();
}

class _CustomLoaderWidgetState extends State<CustomLoaderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    offset = Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 4.5))
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTrue) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return AbsorbPointer(
      absorbing: widget.isTrue,
      child: Stack(
        children: <Widget>[
          Container(child: widget.child),
          Align(
            alignment: Alignment(0.0, -1.2,),
            child: SlideTransition(
              position: offset,
              child: RefreshProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
