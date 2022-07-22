import 'package:plendify/controller/weight/weight_tracker_controller.dart';
import 'package:plendify/database/database.dart';
import 'package:plendify/helper/custom_text_field_form.dart';
import 'package:plendify/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:plendify/model/weight/weighted_tracker_model.dart';
import 'package:plendify/view/home/weight_list.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  TextEditingController weightValueController = TextEditingController();
  bool progressCode = true;
  saveWeight()async{
    try{
      if(weightValueController.text.isNotEmpty){
        showLoaderDialog(context);
        List<WeightedTrackerModel> listCurrentWeight = [];
        String documentId = generateRandom().toString();
        listCurrentWeight = await  WeightTrackerController(documentId: documentId).saveWeightValue(weightValueController.text);
        if(listCurrentWeight.isNotEmpty){
          setState((){
            weightValueController.clear();
          });
          toastMessage("Weight added successfully");


        }
        Navigator.pop(context);
      }else{
        toastMessage("Enter weight");
      }
    }catch(e){
      Navigator.pop(context);
      print(e.toString());
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<WeightedTrackerModel>>.value(
      initialData:[] ,
      value: DatabaseService().weightedTracker ,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: kHomeBackgroundColor,
          body: Container(
            padding: EdgeInsets.only(top: 6.h, bottom: 2.h, left: 2.h, right: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     sText(
                      'Welcome to Weight Tracker,',
                      size: 12,
                       ),
                     IconButton(onPressed: ()async{
                       showLogoutDialog(message: "Are you sure you want to sign out?",context: context,);
                     }, icon: Icon(Icons.logout))
                   ],
                 ),
                sText(
                  "User Login Token:",
                  size: 17,
                  weight: FontWeight.w600
                ),
                sText(userDataModel!.uid,size: 17,weight: FontWeight.w600,color: kAccessmentButtonColor),
                const SizedBox(height: 20.5),
                Form(
                  key:_formKey ,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: CustomTextField(
                            title: "",
                            textInputType: const TextInputType.numberWithOptions(decimal: true),
                            controller: weightValueController,
                            hintText: "Enter weight value",
                            labelText: "Enter weight value",
                            radius: 0,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: ()async{
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate() == false){
                              return ;
                            }else{
                              saveWeight();
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                              child: sText("Submit",color: Colors.white),

                            decoration: BoxDecoration(
                              color: kAccessmentButtonColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
                const WeightListData()


              ],
            ),
          ),
        ),
      ),
    );
  }
}
