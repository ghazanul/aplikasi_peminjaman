import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
   Future loginWithEmailandPassword(String email, String password) async {
    try{
      User user = 
      (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user!;

      if (user != null){
        return true;
      }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
    try{
      User user = 
      (await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user!;

     

    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //signout
  Future signOut() async {
    try{
      
      await firebaseAuth.signOut();
    }catch(e) {
      return null;
    }
  }

}