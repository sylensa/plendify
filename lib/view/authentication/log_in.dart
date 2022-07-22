import 'package:plendify/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:plendify/model/authentication/user_model.dart';
import 'package:plendify/view/home/weight_page.dart';



class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool progressCode = true;

  loginUser()async{
    showLoaderDialog(context,message: "Login in...");
    UserModel? userModel = await firebaseAuthService.signInSilently();
    if(userModel != null){
      print(userModel);
      userDataModel = userModel;
      Navigator.pop(context);
      toastMessage("Login Successfully");
      goTo(context, MainHomePage(),replace: true);
    }else{
      Navigator.pop(context);
      toastMessage("Login Failed, try again");
      print("Login failed");
    }
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAppColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9B9),
              Color(0xFF00A396),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Padding(
              padding: const EdgeInsets.only(left: 27.0, right: 27.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome to\n Weighted Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 76,
                  ),
                  InkWell(
                    onTap: () {
                      loginUser();
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(35),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Join Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00A89B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
