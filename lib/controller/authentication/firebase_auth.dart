import 'package:firebase_auth/firebase_auth.dart';
import 'package:plendify/model/authentication/user_model.dart';

class FirebaseAuthService{
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? userDetailsFromFirebase(User? user){
    return user != null ? UserModel(uid: user.uid) : null ;
  }
  Future<UserModel?> signInSilently()async{
       User? user;
      try{
       UserCredential userCredential = await auth.signInAnonymously();
       user = userCredential.user;
         return userDetailsFromFirebase(user);
      }catch(e){
        print(e.toString());
        return userDetailsFromFirebase(user);
      }
  }

  Future<void> signOut() async {
    try {
      auth.signOut();
    } catch (err) {
      print("error:$err");
    }
  }

  Stream<UserModel?> get userModel {
    return auth.authStateChanges()
        .map(userDetailsFromFirebase);
}




}