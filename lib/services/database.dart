import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:y_wait/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference customerCollection = Firestore.instance.collection('customers');
  final CollectionReference businessCollection = Firestore.instance.collection('business');

//  Future<void> updateBusinessCollection() async {
//    final CollectionReference specificBusinessCollection = Firestore.instance.collection('$this.uid');
//    await updateBusinessData(peopleInLine: )
//  }

  Future<void> updateBusinessData({String businessName, String category, int maxCap, int peopleInLine}) async {
    return await businessCollection.document(uid).setData({
      'uid': uid,
      'businessName': businessName,
      'category' : category,
      'maxCap': maxCap,
      'peopleInLine': peopleInLine,
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
      uid: snapshot.data['uid'],
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

  List<BusinessData> _businessListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return BusinessData(
        uid: doc.data['uid'].trim(),
        businessName: doc.data['businessName'],
        category: doc.data['category'],
        peopleInLine: doc.data['peopleInLine']
      );
    }).toList();
  }


  Stream<List<BusinessData>> get businesses {
    return businessCollection.snapshots()
        .map(_businessListFromSnapshot);
  }

}