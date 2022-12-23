import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataServices {
  final fireStore = FirebaseFirestore.instance;

  void firstLoginSetUp() async {
    final data =
        fireStore.collection('users').where("id", isEqualTo: getUserEmail());
    try {
      await data.get().then((value) {
        value.docs.first;
      });
    } catch (e) {
      fireStore.collection('users').add({"id": getUserEmail()});
    }
  }

  String? getUserEmail() {
    User? loggedInUser = FirebaseAuth.instance.currentUser;
    String? userEmail;
    if (loggedInUser != null) {
      userEmail = loggedInUser.email;
    }
    return userEmail;
  }

  dynamic getUserDoc() async {
    late String userDoc;
    final data =
        fireStore.collection('users').where("id", isEqualTo: getUserEmail());
    await data.get().then((value) {
      userDoc = value.docs.first.id;
    });
    return userDoc;
  }

  void addCalories(String mealName, int calories, String mealType) async {
    String userDoc = await getUserDoc();
    fireStore.collection('users').doc(userDoc).collection("meals").add({
      'time': Timestamp.now(),
      'name': mealName,
      'calories': calories,
      'type': mealType
    });
  }

  dynamic getDayWeekCalories({bool weekly = false}) async {
    String userDoc = await getUserDoc();
    DateTime now = DateTime.now();
    int weeklyInt = 0;
    if (weekly) {
      weeklyInt = 7;
    }
    final data = fireStore
        .collection('users')
        .doc(userDoc)
        .collection("meals")
        .where("time",
            isGreaterThanOrEqualTo:
                DateTime(now.year, now.month, now.day - weeklyInt));
    late List<int> meals = [];
    await data.get().then((value) {
      for (dynamic meal in value.docs) {
        meals.add(meal.get('calories'));
      }
    });
    return meals.reduce((a, b) => a + b);
  }
}
