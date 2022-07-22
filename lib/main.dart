import 'package:firebase_core/firebase_core.dart';
import 'package:plendify/controller/authentication/firebase_auth.dart';
import 'package:plendify/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plendify/model/authentication/user_model.dart';
import 'package:plendify/view/authentication/authenticating_page.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (_, __, ___) =>
          StreamProvider<UserModel?>.value(
            initialData: null,
            value: FirebaseAuthService().userModel,
            child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plendify',
        theme: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: kHomeBackgroundColor,
                iconTheme: const IconThemeData(color: Colors.black),
                elevation: 0,
                centerTitle: true,
                titleTextStyle: appStyle(col: Colors.black),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(color: Colors.grey.shade400),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                ),
              )),
        home: const AuthenticationPage(),
      ),
          ),
    );
  }
}
