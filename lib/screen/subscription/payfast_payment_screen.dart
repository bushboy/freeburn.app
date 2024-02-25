

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxoo/apis/payfast_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayfastPayment extends StatefulWidget {
  PayfastPayment({Key? key}) : super(key: key);

  @override
  _PayfastPaymentState createState() => _PayfastPaymentState();
}

class _PayfastPaymentState extends State<PayfastPayment> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  PaymentViewModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Payment Page")),
      body: Form(
        key: formstate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextFormField(
              controller: itemNameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Item Name',
              ),
            ),
            SizedBox(
              width: 220,
              height: 100,
              child: InkWell(
                onTap: () {
                  print(
                      "Amount: ${amountController.text} Item: ${itemNameController.text}");
                  model?.payment(
                      amountController.text, itemNameController.text);

                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: const Center(
                      child: Text("Pay",
                          style: TextStyle(fontSize: 22, color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String plainId;
  final String userId;
  //final String? amount;
  //final String? planName;

  const WebViewPage({Key? key,required this.plainId,required this.userId}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  //PaymentViewModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Confirm Payment"),
        ),
        body: Column(children: [
          Expanded(
              child: WebView(
                initialUrl: "https://freeburnmusic.com/pay?planId=" + widget.plainId + "&userId="+widget.userId,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: _onUrlChange,
                debuggingEnabled: true,
              ))
        ]));
  }

  _onUrlChange(String url) {
    print('Page finished loading: $url');
    if (mounted) {
      setState(() {
        if (url.contains("http://localhost:8080/#/onSuccess")) {
          Navigator.pushNamed(context, "/onSuccess");
        } else if (url.contains("http://localhost:8080/#/onCancel")) {
          Navigator.pushNamed(context, "/onCancel");
        }
      });
    }
  }
}

class PaymentViewModel {
  TextEditingController itemNameController = TextEditingController();
  PayfastApi? api;
  String? errorMessage;
  String? payFast;

  void payment(String? amount, String? item_name) {
    //amount = amountController.text;
    //item_name = itemNameController.text;
    api
        ?.payFastPayment(amount: amount, item_name: item_name)
        .then((createdPayment) {
      if (createdPayment == null) {
        errorMessage = "Something went wrong. Please try again.";
      } else {
        payFast = createdPayment;
      }
      print("It reaches here");
    }).catchError((error) {
      errorMessage = '${error.toString()}';
    });
  }
}

class OnSuccess extends StatelessWidget {
  const OnSuccess({Key? key}) : super(key: key);
  static const String route = 'onSuccess';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "This is on Success",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.check,
                color: Colors.green,
                size: 40,
              )
            ],
          )),
    );
  }
}

class OnCancel extends StatelessWidget {
  const OnCancel({Key? key}) : super(key: key);
  static const String route = 'OnCancel';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "This is on Cancel",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.close,
                color: Colors.red,
                size: 40,
              )
            ],
          )),
    );
  }
}