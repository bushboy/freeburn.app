import 'package:flutter/material.dart';
import 'package:oxoo/screen/music/when_loading.dart';
import 'package:oxoo/widgets/subscription/subscription_grid.dart';

class SubscriptionPage<T> extends StatelessWidget {
  final List<T> items;
  final SubscriptionItem Function(T) transform;
  final Function(T) onTap;

  const SubscriptionPage({required Key key, required this.items, required this.transform, required this.onTap})
      : assert(transform != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: WhenLoading(
        key: Key('subscriptions'),
        isLoading: items == null,
        builder: () => SubscriptionsGrid(
          key: Key("SubscriptionsGrid"),
          onTap: (index) => onTap != null ? onTap(items[index]) : () {},
          items: items.map((item) => transform(item)).toList()
        ),
      ),
    );
  }
}