import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uikit/router/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      router.replace(const AuthRoute());
      return;
    }

    // Проверяем профиль в Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((doc) {
          if (doc.exists && doc.data()?['name'] != null) {
            resolver.next(); // Профиль заполнен
          } else {
            router.replace(const ProfileRoute()); // Профиль не заполнен
          }
        })
        .catchError((e) {
          // Если ошибка - пропускаем (или редирект на Auth)
          resolver.next();
        });
  }
}
