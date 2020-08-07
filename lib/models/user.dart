class User {
  String userId;
  User({this.userId});
}

class CustomerData {
  final String uid;
  final String customerName;

  CustomerData({this.uid, this.customerName});
}

class BusinessData {
  final String uid;
  final String businessName;
  final String category;
  final int maxCap;
  final int peopleInLine;
  final List<String> people = null;
  BusinessData({this.uid, this.businessName, this.category, this.maxCap, this.peopleInLine});
}

class CustomerTickets{
  final String businessName;
  final int positionInLine;
  CustomerTickets({this.businessName, this.positionInLine});
}