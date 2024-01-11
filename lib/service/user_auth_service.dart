import 'package:firebase_auth/firebase_auth.dart';

class UserAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<User> login({required String email, required String password}) async {
    var user =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user!;
  }

  Future<User> signin({required String email, required String password}) async {
    var user = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.user!;
  }

  Future logout() async {
    await auth.signOut();
  }

 

  Future<bool> isSignin() async {
    var user =  auth.currentUser;
    return user != null;
  }

 
}
