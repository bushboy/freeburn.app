import 'package:flutter/material.dart';
import 'package:oxoo/widgets/artist/charts_grid.dart';
import 'package:oxoo/screen/music/when_loading.dart';

class ChartsPage<T> extends StatelessWidget {
  final List<T> items;
  final ChartItem Function(T) transform;
  final Function(T) onTap;

  const ChartsPage({required Key key, required this.items, required this.transform, required this.onTap})
      : assert(transform != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: WhenLoading(
        key: Key('artists'),
        isLoading: items == null,
        builder: () => ChartsGrid(
              key: Key("ChartsGrid"),
              onTap: (index) => onTap != null ? onTap(items[index]) : () {},
              items: items.map((item) => transform(item)).toList(),
            ),
      ),
    );
  }
}
