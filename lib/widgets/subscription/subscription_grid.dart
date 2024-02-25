import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oxoo/screen/subscription/payment_screen.dart';
import 'package:oxoo/widgets/artist/tappable_image.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../../screen/subscription/payfast_payment_screen.dart';

class SubscriptionItem {
  final String id;
  final String name;
  final String days;
  final String price;
  final String userId;

  const SubscriptionItem({required this.id, required this.name,required this.days,required this.price,required this.userId});
}

class SubscriptionsGrid extends StatelessWidget {
  final List<SubscriptionItem> items;
  final Function(int) onTap;

  const SubscriptionsGrid({required Key key, required this.items, required this.onTap})
      : assert(items != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  textColor: Colors.redAccent,
                  leading: Icon(Icons.album,color: Colors.redAccent),
                  title: Text(item.name,style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('R ${item.price}'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text('BUY'),
                      onPressed: () { /*Navigator.pushNamed(context, PaymentScreen.route);*/
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              plainId: item.id,
                              userId: item.userId,
                        )));
                        },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
    );
  }

  String _getValue(String value) =>
    value;
}
