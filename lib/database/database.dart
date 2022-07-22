import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plendify/helper/helper.dart';
import 'package:plendify/model/weight/weighted_tracker_model.dart';

class DatabaseService{
  final String documentId;
  DatabaseService({this.documentId = ''});
  final CollectionReference weightedTrackerCollection = FirebaseFirestore.instance.collection(userDataModel!.uid);

  Future updateUserWeight(WeightedTrackerModel weightedTrackerModel)async{
    return await weightedTrackerCollection.doc(documentId).set(weightedTrackerModel.toJson());
  }

  Future deleteUserWeight()async{
    return await weightedTrackerCollection.doc(documentId).delete();
  }
  Future deleteAllUsersWeight()async{
    weightedTrackerCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
        }

  List<WeightedTrackerModel> weightedListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return WeightedTrackerModel(
        weight:   WeightedTrackerModel.fromJson(jsonDecode(jsonEncode(doc.data()))).weight,
        timestamp: WeightedTrackerModel.fromJson(jsonDecode(jsonEncode(doc.data()))).timestamp,
        documentId: WeightedTrackerModel.fromJson(jsonDecode(jsonEncode(doc.data()))).documentId,
      );
    }).toList();
  }

  Stream<List<WeightedTrackerModel>>? get weightedTracker{
    return weightedTrackerCollection.orderBy("timestamp",descending: true).snapshots()
        .map(weightedListFromSnapshot);
  }



}