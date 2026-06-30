import 'package:flutter/material.dart';

class ResponsiveTable extends StatelessWidget {
  final Widget child;

  const ResponsiveTable({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
