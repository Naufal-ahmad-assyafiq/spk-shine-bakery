import 'package:flutter/material.dart';

class ResponsiveTableContainer extends StatefulWidget {
  final Widget child;

  const ResponsiveTableContainer({
    super.key,
    required this.child,
  });

  @override
  State<ResponsiveTableContainer> createState() => _ResponsiveTableContainerState();
}

class _ResponsiveTableContainerState extends State<ResponsiveTableContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0), // Padding below table for scrollbar visibility
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 32,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
