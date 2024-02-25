import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/screen/music/audioplayer.dart';
import 'package:oxoo/service/audio_service.dart';
import 'package:path_provider/path_provider.dart';
import '../../service/get_config_service.dart';
import 'app.dart';
import 'data/repository/config_repository.dart';
import 'helpers/config.dart';
import 'models/configuration.dart';
import 'models/user_model.dart';
import 'service/locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize();
  // Admob.initialize(testDeviceIds: ["17A3B83DAC6AB3357062439AAD33FEA3"]);
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  // Hive not only supports primitives, lists and maps but also any Dart object you like. You need to generate a type adapter before you can store objects.
  Hive.registerAdapter(ConfigurationModelAdapter());
  Hive.registerAdapter(AppConfigAdapter());
  Hive.registerAdapter(AdsConfigAdapter());
  Hive.registerAdapter(PaymentConfigAdapter());
  Hive.registerAdapter(ApkVersionInfoAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(TvCategoryAdapter());
  Hive.registerAdapter(AuthUserAdapter());
  await Hive.openBox<ConfigurationModel>('configBox');
  await Hive.openBox<AppConfig>('appConfigbox');
  await Hive.openBox<AdsConfig>('adsConfigbox');
  await Hive.openBox<PaymentConfig>('paymentConfigbox');
  await Hive.openBox<AuthUser>('oxooUser');
  await Hive.openBox('appModeBox');
  await Hive.openBox('settings');
  await Hive.openBox('downloads');
  await Hive.openBox('stats');
  await Hive.openBox('Favorite Songs');
  await Hive.openBox('cache');

  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.freeburnmusic.channel.audio',
      androidNotificationChannelName: 'Freeburn',
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: false,
      // Hive.box('settings').get('stopServiceOnPause', defaultValue: true) as bool,
      notificationColor: Colors.grey[900],
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
  ConfigurationModel? configurationModel;
  configurationModel = await ConfigurationRepositoryImpl().getConfigurationData();
  GetConfigService().updateGetConfig(configurationModel);
  setupLocator();
  //if (defaultTargetPlatform == TargetPlatform.android) {
  //  InAppPurchaseConnection.enablePendingPurchases();
  //}
  runApp(MyApp());
}
