import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yt/campaign_page.dart';
import 'package:yt/donatepage.dart';
import 'package:yt/edit_profile_page.dart';
import 'package:yt/widgets/blooddonationslide.dart';
import 'package:yt/create_request_page.dart';
import 'package:yt/donation_request_page.dart';
import 'package:yt/finddonor.dart';
import 'package:yt/firstpage.dart';
import 'package:yt/gemini_chat_screen.dart';
import 'package:yt/login.dart';
import 'package:yt/passwordreset.dart';
import 'package:yt/eligibilitycheck.dart';
import 'package:yt/registration.dart';
import 'package:yt/splash.dart';
import 'package:yt/resetverify.dart';
import 'package:yt/homepage.dart' as HomePage;
import 'package:yt/search_filter_page.dart';
import 'package:yt/profilescreen.dart';
import 'carousel_slider_widget.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings = const Settings(
  //   persistenceEnabled: true,
  // );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  print("ggtggt${await FirebaseMessaging.instance.getToken()}");
  FirebaseMessaging.onBackgroundMessage((message)async{
    print("${message.data}");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message){
    print("${message.data}");
  });
  FirebaseMessaging.onMessage.listen((message){
    print("${message.data}");
  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    title: 'Rakt Seva',
    routes: {
      '/splash': (context) => SplashScreen(),
      '/firstpage': (context) => FirstPage(),
      '/login': (context) => LoginPage(),
      '/passwordreset': (context) => PasswordResetPage(),
      '/registration': (context) => RegistrationPage(),
      '/resetverify': (context) => OtpVerificationScreen(),
      '/homepage': (context) => HomePage.HomeScreen(),
      '/donation_request_page': (context) => DonationRequestPage(),
      '/search_filter_page': (context) => SearchFilterPage(),
      '/profilescreen': (context) => ProfileScreen(),
      '/eligibilitycheck': (context) => EligibilityCheckPage(),
      '/finddonor': (context) => FindDonorsScreen(),
      '/create_request_page': (context) => CreateRequestPage(),
      '/gemini_chat_screen' : (context) => GeminiChatScreen(),
      '/carousel_widget_dart': (context) => CarouselSliderWidget(),
      '/blooddonationslide': (context) => BloodDonationSlides(),
      '/donatePage': (context) => DonatePage(),
      '/campaign_page': (context) => CampaignPage(),
      '/edit_profile_page': (context) => EditProfilePage(),
    },
  ));
}
