import 'package:flutter/material.dart';

class ZCard extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Color borderRadiusColor;
  final Color? color;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCallback? onLongPress;
  final Color? shadowColor;
  final double? elevation;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final Color? inkColor;
  ZCard({
    Key? key,
    required this.child,
    this.borderRadius,
    this.borderWidth = 1,
    this.borderRadiusColor = Colors.transparent,
    this.color,
    this.onTap,
    this.shadowColor,
    this.elevation,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.onDoubleTap,
    this.onLongPress,
    this.inkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? null,
      width: width ?? null,
      decoration: BoxDecoration(
        border: Border.all(color: borderRadiusColor, width: borderWidth),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.all(0),
        color: color ?? null,
        elevation: elevation ?? 0,
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(8)),
        child: InkWell(
          splashColor: inkColor ?? null,
          // splashColor: Color(0x66C8C8C8),
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          onTap: onTap ?? null,
          onDoubleTap: onDoubleTap ?? null,
          onLongPress: onLongPress ?? null,
          child: Container(padding: padding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 12), child: child),
        ),
      ),
    );
  }

  Color? get getColor {
    if (color == null) return null;
    return color!.withOpacity(0.9);
  }
}
