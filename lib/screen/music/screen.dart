import 'package:flutter/material.dart';
import '../../style/theme.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final isDark = true;

  const Screen({required Key key, required this.child, required this.title})
      : assert(child != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(title),
      ),*/
      backgroundColor: isDark! ? CustomTheme.primaryColorDark : Colors.transparent,
      body: child,
    );
  }
}
