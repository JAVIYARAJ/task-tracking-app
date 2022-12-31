import 'package:flutter/material.dart';
class ShimmerWidget extends StatelessWidget {
  //const ShimmerWidget({Key? key}) : super(key: key);

  final double? height;
  final double? width;
  final ShapeBorder? shape;

  ShimmerWidget.rectangle({this.width,this.height}):shape=const RoundedRectangleBorder();

  ShimmerWidget.circle({this.width,this.height,this.shape=const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
      color: Colors.grey,
        shape: shape!
      ),
    );
  }
}
