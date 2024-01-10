

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exa_chircea/FbObjects/fbPost.dart';
import 'package:exa_chircea/Home/PhonePostView.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FbObjects/fbUser.dart';


class FirebaseAdmin {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<fbUser> getCurrentUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    fbUser user;

    DocumentReference<fbUser> ref = db.collection("Usuarios")
        .doc(uid).withConverter(fromFirestore: fbUser.fromFirestore,
      toFirestore: (fbUser user, _) => user.toFirestore(),);

    DocumentSnapshot<fbUser> docSnap = await ref.get();
    user = docSnap.data()!;

    return user;
  }
  Future<fbUser> getUser(uid) async {
    fbUser user;

    DocumentReference<fbUser> ref = db.collection("Usuarios")
        .doc(uid).withConverter(fromFirestore: fbUser.fromFirestore,
      toFirestore: (fbUser user, _) => user.toFirestore(),);

    DocumentSnapshot<fbUser> docSnap = await ref.get();
    user = docSnap.data()!;

    return user;
  }
  Future<void> updateUserData(String name, int age, String image) async {
    fbUser usuario = fbUser(age: age, name: name, sAvatar: image);
    String uidUsuario = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }
  Future<void> updatePostData({required String title, required String body, required String idPost}) async {
    DocumentReference<Map<String, dynamic>> postRef = db.collection("Posts").doc(idPost);

    // Create a map with only the fields to update
    Map<String, dynamic> postData = {
      'title': title,
      'body': body,
    };

    // Update only the specified fields in Firestore
    await postRef.update(postData);
    }

  Future<List<Map<String, dynamic>>> searchPostsByTitle(String searchValue) async {
    QuerySnapshot querySnapshot = await db
        .collection('Posts')
        .where('title', isGreaterThanOrEqualTo: searchValue)
        .get();

    return querySnapshot.docs
        .where((doc) =>
    (doc['title'] as String).contains(searchValue) ||
        (doc['sUserName'] as String).contains(searchValue))
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

}