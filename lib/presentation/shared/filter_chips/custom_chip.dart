import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final bool selected;
  final Function(bool selected) onSelect;

  CustomChip({
    Key key,
    this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: this.width,
      height: this.height,
      margin: EdgeInsets.only(right: 10.w),
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? (color ?? Color(0xff8FD974)) : Color(0xff31323B),
      ),
      child: InkWell(
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Visibility(
              visible: selected,
              child: ImageIcon(
                AssetImage(label),
                size: 24.r,
                color: selected ? Color(0xff28282B) : Colors.white,
              ),
            ),
            ImageIcon(
              AssetImage(label),
              size: 24.r,
              color: selected ? Color(0xff28282B) : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
