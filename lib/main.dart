import 'package:flutter/material.dart';
import 'package:yt/campaignPage.dart';
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
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
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
      '/campaignPage': (context) => CampaignPage(),
    },
  ));
}
