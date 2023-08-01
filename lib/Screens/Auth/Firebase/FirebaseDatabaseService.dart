import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:seefood/Screens/Auth/Objects/CutomerObject.dart';

class AuthFirebaseDatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<bool> createNewCustomer({required CustomerObject customer}) async {
    bool done = false;

    DatabaseReference dbf =
        _firebaseDatabase.ref().child('Customers').child(customer.uid!);
    Map<String, dynamic> customerData = {
      'uid': customer.uid,
      'name': customer.name,
      'email': customer.email,
      'phoneNumber': customer.phoneNumber,
    };

    await dbf.set(customerData).then((value) {
      done = true;
    });

    return done;
  }

  Future<CustomerObject?> getCustomerProfile() async {
    CustomerObject customer = CustomerObject();

    DatabaseReference dbf = _firebaseDatabase
        .ref()
        .child('Customers')
        .child(FirebaseAuth.instance.currentUser!.uid);
    await dbf.once().then((snapshot) {
      customer = CustomerObject.fromJson(snapshot.snapshot.value);
    });

    return customer;
  }
}
