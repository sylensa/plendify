import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plendify/controller/weight/weight_tracker_controller.dart';
import 'package:plendify/helper/custom_text_field_form.dart';
import 'package:plendify/helper/helper.dart';
import 'package:plendify/model/weight/weighted_tracker_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WeightListData extends StatefulWidget {
  const WeightListData({Key? key}) : super(key: key);

  @override
  State<WeightListData> createState() => _WeightListDataState();
}

class _WeightListDataState extends State<WeightListData> {
  TextEditingController weightValueController = TextEditingController();
  int weightIndex = 0;
  updateWeight(int index,WeightedTrackerModel? weightedTrackerModel)async{
    try{
        showLoaderDialog(context);
        WeightedTrackerModel newWeightedTrackerModel = WeightedTrackerModel(
          weight: double.parse(weightValueController.text),
          timestamp: weightedTrackerModel!.timestamp,
          documentId: weightedTrackerModel.documentId,
        );
        WeightedTrackerModel? res = await  WeightTrackerController(documentId:  weightedTrackerModel.documentId!).updateWeightValue(newWeightedTrackerModel);
        if(res != null){
          setState((){
            FocusScope.of(context).unfocus();
            weightValueController.clear();
            listWeightedTrackerModel.removeAt(index);
            listWeightedTrackerModel.insert(index, res);
          });
        }
        toastMessage("Updated successfully");
        Navigator.pop(context);

    }catch(e){
      Navigator.pop(context);
      print(e.toString());
    }
  }
  editWeight(int index,WeightedTrackerModel? weightedTrackerModel){
    weightValueController.text = listWeightedTrackerModel[index].weight.toString();
    return showDialog(
        context: context,

        builder: (context) {
          return AlertDialog(
            title: sText('Edit Weight',weight: FontWeight.bold,color: kAccessmentButtonColor),
            backgroundColor: kHomeBackgroundColor,
            content: SizedBox(
              height: 60,
              width: appWidth(context),
              child: CustomTextField(
                title: "",
                autoFocus: true,
                textInputType: const TextInputType.numberWithOptions(decimal: true),
                controller: weightValueController,
                hintText: "Enter weight value",
                labelText: "Enter weight value",
                radius: 0,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child:  sText('Cancel',weight: FontWeight.bold,color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              GestureDetector(
                onTap: ()async{
                  Navigator.of(context).pop();
                  updateWeight(index,weightedTrackerModel);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                  margin: rightPadding(10),
                  child: sText("Update",color: Colors.white),

                  decoration: BoxDecoration(
                      color: kAccessmentButtonColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              )

            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    listWeightedTrackerModel = Provider.of<List<WeightedTrackerModel>>(context);
    return
      Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 20.5,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sText('Weighted Values',color: kAccessmentButtonColor,size: 15),
                listWeightedTrackerModel.isNotEmpty ?
                GestureDetector(
                  onTap: ()async{
                    showDeleteDialog(message: "Are you sure you want to delete all weights?",context: context,deleteAll: true);
                  },
                  child: sText('Clear',color: Colors.red,size: 15,weight: FontWeight.bold),
                ):Container(),
              ],
            ),
            const SizedBox(
              height: 20.5,
            ),
            listWeightedTrackerModel.isNotEmpty ?

            Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listWeightedTrackerModel.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,

                  elevation: 0,
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: ListTile(
                    onTap: () {
                    },
                    title:  sText(
                      "${listWeightedTrackerModel[index].weight.toString()}Kg",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    subtitle:  sText(
                      listWeightedTrackerModel[index].timestamp.toString().split(".").first,
                      size: 9,
                      color: Colors.grey,
                    ),
                    trailing: Container(
                      width: 60,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                editWeight(index,listWeightedTrackerModel[index]);
                              },
                              child: Icon(Icons.edit,color: Colors.blue,)
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                              onTap: ()async{
                                showDeleteDialog(message: "Are you sure you want to delete?",context: context,index: index);
                              },
                              child: Icon(Icons.delete,color: Colors.red,)
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    )  : Expanded(child: Center(child: sText("No records",color: Colors.black),))
          ],
        ),
      );
  }
}
