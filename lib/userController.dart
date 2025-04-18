import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {

  UserController._internal();

  static final UserController _instance = UserController._internal();

  static UserController get instance => _instance;

  var userId = ''.obs;
  var name = ''.obs;
  var emailId = ''.obs;
  var password = ''.obs;
  var mobileNumber = ''.obs;
  var bloodGroup = ''.obs;
  var address = ''.obs;
  var eligibilityStatus = false.obs;
  var rewardPoints = 0.obs;
  var fcmToken = ''.obs;
  var userPhoto = ''.obs;

  Rx<bool> isInitialized = Rx(false);

  void setUser({
    required String userId,
    required String name,
    required String emailId,
    required String password,
    required String mobileNumber,
    required String bloodGroup,
    required String address,
    required bool eligibilityStatus,
    required int rewardPoints,
    required String fcmToken,
  }) {
    this.userId.value = userId;
    this.name.value = name;
    this.emailId.value = emailId;
    this.password.value = password;
    this.mobileNumber.value = mobileNumber;
    this.bloodGroup.value = bloodGroup;
    this.address.value = address;
    this.eligibilityStatus.value = eligibilityStatus;
    this.rewardPoints.value = rewardPoints;
    this.fcmToken.value = fcmToken;
  }

  void clearUser() {
    userId.value = '';
    name.value = '';
    emailId.value = '';
    password.value = '';
    mobileNumber.value = '';
    bloodGroup.value = '';
    address.value = '';
    eligibilityStatus.value = false;
    rewardPoints.value = 0;
    fcmToken.value = '';
  }

  // Optional: populate from Firestore map
  void fromMap(Map<String, dynamic> data) {
    setUser(
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      emailId: data['email_id'] ?? '',
      password: data['password'] ?? '',
      mobileNumber: data['mobile_number'] ?? '',
      bloodGroup: data['blood_group'] ?? '',
      address: data['address'] ?? '',
      eligibilityStatus: data['eligibility_status'] ?? false,
      rewardPoints: data['reward_points'] ?? 0,
      fcmToken: data['fcm_token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId.value,
      'name': name.value,
      'email_id': emailId.value,
      'password': password.value,
      'mobile_number': mobileNumber.value,
      'blood_group': bloodGroup.value,
      'address': address.value,
      'eligibility_status': eligibilityStatus.value,
      'reward_points': rewardPoints.value,
      'fcm_token': fcmToken.value,
    };
  }


  Future<void> initAndListenToUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('currentUser');
    print(uid);
    if (uid != null && uid.isNotEmpty) {
      userId.value = uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          fromMap(snapshot.data()!);
        } else {
          print('⚠️ User doc doesn\'t exist or has no data.');
        }
      });
    } else {
      print('❌ current_user not found in SharedPreferences.');
    }
  }

  Future getImageUrl() async{
    userPhoto.value = await FirebaseStorage.instance.ref().child("${userId}.jpg").getDownloadURL();
  }


  /// ✅ Update the eligibility status
  Future<void> updateEligibility(bool status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .update({'eligibility_status': status});
  }

  /// 🎯 Update the reward points
  Future<void> updateRewardPoints(int points) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .update({'reward_points': points});
  }

  Future<void> updateFcmToken(String token) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.value)
        .update({'fcm_token': fcmToken});
  }
}
