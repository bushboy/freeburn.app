import 'package:flutter/material.dart';

class WhenLoading extends StatelessWidget {
  final bool isLoading;
  final Widget Function() builder;

  const WhenLoading({required Key key, required this.isLoading, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator(value: null,),) : builder();
  }
}
