import 'package:flutter/cupertino.dart';

class ResponsiveBase extends StatelessWidget {
  final Widget child;

  const ResponsiveBase({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (_, constraints) {
          final horizontalPadding =
              constraints.maxWidth >= 600 ? 34.0 : 18.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(
              child: child,
            ),
          );
        },
      ),
    );
  }
}
