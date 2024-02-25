
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/apis/subscription_api.dart';
import 'package:oxoo/models/plan_model.dart';
import 'package:oxoo/widgets/subscription/subscription_grid.dart';
import 'package:oxoo/widgets/subscription/subscription_page.dart';
import 'package:oxoo/screen/music/screen.dart';
import 'package:oxoo/bloc/subscription/plans_block.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/user_model.dart';
import '../../service/authentication_service.dart';
import '../../strings.dart';
import '../../style/theme.dart';

class PlansScreen extends StatelessWidget {
  static final String route = '/PlansScreen';

  final PlansBLoC _bloc = PlansBLoC(SubscritionApi());

  @override
  Widget build(BuildContext context) {
    printLog("_MySubscriptionScreenState");
    final authService = Provider.of<AuthService>(context);
    AuthUser authUser = authService.getUser()!;
    var appModeBox = Hive.box('appModeBox');
    var isDark = appModeBox.get('isDark') ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppContent.subscribe),
        backgroundColor: isDark ? CustomTheme.colorAccentDark : CustomTheme.primaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: isDark ? CustomTheme.primaryColorDark : Colors.white,
        child: Column (
          children: <Widget>[
            SizedBox(height: 10),
            Center(
              child:Card(
                color: Colors.black,
                child: SizedBox(
                width: 380,
                child: Center(child: Text(AppContent.subscribe_message,style: isDark!? CustomTheme.bodyText2White:CustomTheme.coloredBodyText2)),
            ),
          )),
            Expanded(child: _buildMain(context,authUser.userId!))
          ]),),
    );
  }


  _space(double space) {
    return SizedBox(height: space);
  }
  //@override
  Widget _buildMain(BuildContext context,String userId) {
    return StreamBuilder<List<PlanModel>>(
      stream: _bloc.packages,
      builder: (context, snapshot) {
        return Screen(
          key : Key("Subscriptions"),
          title: "Subscriptions",
          child: _buildChild(context, snapshot,userId),
        );
      },
    );
  }

  Widget _buildChild(
      BuildContext context, AsyncSnapshot<List<PlanModel>> snapshot,String userId) {
    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "An error occured. Please retry in a bit.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return SubscriptionPage<PlanModel>(
        key: Key('SubscribePage'),
        items: snapshot.data??<PlanModel>[],
        transform: (item) =>
            SubscriptionItem(id: item.id, name: item.name, price: item.price,days: item.days,userId: userId),
        onTap: (artist) => Fluttertoast.showToast(
            msg: "To Purchase",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1)
      );
    }
  }
}
