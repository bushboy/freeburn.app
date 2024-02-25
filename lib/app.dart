import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/auth/registration_bloc.dart';
import '../../service/authentication_service.dart';
import 'bloc/auth/firebase_auth/firebase_auth_bloc.dart';
import 'bloc/auth/login_bloc.dart';
import 'bloc/auth/phone_auth/phone_auth_bloc.dart';
import 'constants.dart';
import 'screen/landing_screen.dart';
import 'service/get_config_service.dart';
import 'models/configuration.dart';
import 'screen/auth/auth_screen.dart';
import 'server/phone_auth_repository.dart';
import 'server/repository.dart';
import 'utils/route.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';


class MyApp extends StatefulWidget {
  static final String route = "/MyApp";

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  var appModeBox = Hive.box('appModeBox');
  static bool? isDark = true;

  @override
  void initState() {
    super.initState();
    isDark = appModeBox.get('isDark');
    if (isDark == null) {
      appModeBox.put('isDark', true);
    }
    //final String systemLangCode = Platform.localeName.substring(0, 2);
    //if (ConstantCodes.languageCodes.values.contains(systemLangCode)) {
    //  _locale = Locale(systemLangCode);
    //} else {
     // final String lang =
     // Hive.box('settings').get('lang', defaultValue: 'English') as String;
     // _locale = Locale(ConstantCodes.languageCodes[lang] ?? 'en');
    //}
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        Provider<GetConfigService>(
          create: (context) => GetConfigService(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<HomeContentBloc>(create: (context) => HomeContentBloc(repository: Repository())),
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(Repository()),
            ),
            BlocProvider<PhoneAuthBloc>(create: (context) => PhoneAuthBloc(userRepository: UserRepository())),
            BlocProvider<RegistrationBloc>(
              create: (context) => RegistrationBloc(Repository()),
            ),
            BlocProvider<FirebaseAuthBloc>(
              create: (context) => FirebaseAuthBloc(Repository()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const<Locale> [Locale('en','')],
            routes: Routes.getRoute(),
            home: RenderFirstScreen(),
          )),
    );
  }
}

// ignore: must_be_immutable
class RenderFirstScreen extends StatelessWidget {
  static final String route = "/RenderFirstScreen";
  bool? isMandatoryLogin = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ConfigurationModel>('configBox').listenable(),
      builder: (context, dynamic box, widget) {
        isMandatoryLogin = box.get(0).appConfig.mandatoryLogin;
        printLog("isMandatoryLogin " + "$isMandatoryLogin");
        return renderFirstScreen(isMandatoryLogin!);
      },
    );
  }

  Widget renderFirstScreen(bool isMandatoryLogin) {
    print(isMandatoryLogin);
    if (isMandatoryLogin) {
      return AuthScreen();
    } else {
      return LandingScreen();
    }
  }
}
