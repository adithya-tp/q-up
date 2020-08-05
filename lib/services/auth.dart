import 'package:firebase_auth/firebase_auth.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/services/database.dart';

class FireBaseAuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFireBaseUser);
  }

  Future signUpBusinessWithEmailAndPassword({String businessName, String email, String password, String category, int maxCap}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Done with business user authentication");
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateBusinessData(businessName: businessName, category: category, maxCap: maxCap, peopleInLine: 0);
      print("Created document in business collection");
      await DatabaseService(uid: user.uid).updateUserData(isCustomer: false);
      print("Created document in users collection");
      return _userFromFireBaseUser(result.user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpCustomerWithEmailAndPassword({String customerName, String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateCustomerData(customerName: customerName);
      await DatabaseService(uid: user.uid).updateUserData(isCustomer: true);
      return _userFromFireBaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}