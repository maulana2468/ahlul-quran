import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'injection_container.dart' as di;
import 'features/home/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'audioQuran',
    androidNotificationChannelName: 'Audio Quran',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/launcher_icon',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahlul Quran',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MainMenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
