import 'package:plendify/database/database.dart';
import 'package:plendify/model/weight/weighted_tracker_model.dart';

class WeightTrackerController{
  String documentId;
  WeightTrackerController({this.documentId = ''});


 Future<List<WeightedTrackerModel>> saveWeightValue(String weightValue)async{
    List<WeightedTrackerModel> listCurrentWeight = [];
    try{
        WeightedTrackerModel weightedTrackerModel = WeightedTrackerModel(
          weight: double.parse(weightValue),
          timestamp: DateTime.now().toString(),
          documentId: documentId,
        );
        await DatabaseService(documentId:documentId).updateUserWeight(weightedTrackerModel );
        listCurrentWeight.add(weightedTrackerModel);
        return listCurrentWeight;
    }catch(e){
      print(e.toString());
     return listCurrentWeight;
    }
  }
 Future<WeightedTrackerModel?> updateWeightValue(WeightedTrackerModel? weightedTrackerModel)async{
    try{
        await DatabaseService(documentId:documentId).updateUserWeight(weightedTrackerModel!);
        return weightedTrackerModel;
    }catch(e){
      print(e.toString());
     return null;
    }
  }
}