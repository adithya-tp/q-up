import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:y_wait/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference customerCollection = Firestore.instance.collection('customers');
  final CollectionReference businessCollection = Firestore.instance.collection('business');

  Future<void> updateBusinessData({String businessName, String category, int maxCap}) async {
    return await businessCollection.document(uid).setData({
      'businessName': businessName,
      'category' : category,
      'maxCap': maxCap,
      'peopleInLine': 0,
    });
  }

  Future<void> updateCustomerData({String customerName}) async {
    return await customerCollection.document(uid).setData({
      'customerName': customerName,
    });
  }

  Future<void> updateUserData({bool isCustomer}) async {
    return await userCollection.document(uid).setData({
      'isCustomer': isCustomer,
    });
  }

  Future<bool> getCustomerOrNot() async {
    return await userCollection.document(uid).get()
        .then((DocumentSnapshot ds) => ds["isCustomer"]);
  }

  BusinessData _businessDataFromSnapshot(DocumentSnapshot snapshot) {
    return BusinessData(
      uid: uid,
      businessName: snapshot.data['businessName'],
      category: snapshot.data['category'],
      maxCap: snapshot.data['maxCap'],
    );
  }

  Stream<BusinessData> get businessData {
    return businessCollection.document(uid).snapshots()
        .map(_businessDataFromSnapshot);
  }

  CustomerData _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomerData(
      uid: uid,
      customerName: snapshot.data['customerName'],
    );
  }

  Stream<CustomerData> get customerData {
    return customerCollection.document(uid).snapshots()
        .map(_customerDataFromSnapshot);
  }

}