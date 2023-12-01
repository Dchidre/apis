import 'package:cloud_firestore/cloud_firestore.dart';

class fbUser{

  final String nombre;
  final int edad;

  fbUser ({
    required this.nombre,
    required this.edad,
  });

  factory fbUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return fbUser(
      nombre: data?['nombre'],
      edad: data?['edad'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (nombre != null) "nombre": nombre,
      if (edad != null) "edad": edad,
    };
  }

}