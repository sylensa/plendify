import 'package:plendify/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:plendify/model/authentication/user_model.dart';
import 'package:plendify/view/authentication/log_in.dart';
import 'package:plendify/view/home/weight_page.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  checkIfUserLogin(){
    UserModel? userModel = Provider.of<UserModel?>(context);
    userDataModel = userModel;
    print("userDataModel:$userModel");
    if(userModel != null){
      print('User is signed in!,$userModel');
      return MainHomePage();
    }else{
      return LogInPage();
    }
  }
  @override
  void initState(){
   super.initState();
  }
  @override
  Widget build(BuildContext context) {

   return  checkIfUserLogin();
  }
}
