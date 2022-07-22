import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plendify/database/database.dart';
import 'package:plendify/controller/authentication/firebase_auth.dart';
import 'package:plendify/helper/hide.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:plendify/model/authentication/user_model.dart';
import 'package:plendify/model/weight/weighted_tracker_model.dart';
import 'package:plendify/view/authentication/log_in.dart';
import 'package:recase/recase.dart';

final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
UserModel? userDataModel;
 List<WeightedTrackerModel> listWeightedTrackerModel = [];
List<BoxShadow> elevation({required Color color, required int elevation}) {
  return [
    BoxShadow(
        color: color.withOpacity(0.6),
        offset: Offset(0.0, 4.0),
        blurRadius: 3.0 * elevation,
        spreadRadius: -1.0 * elevation),
    BoxShadow(
        color: color.withOpacity(0.44),
        offset: Offset(0.0, 1.0),
        blurRadius: 2.2 * elevation,
        spreadRadius: 1.5),
    BoxShadow(
        color: color.withOpacity(0.12),
        offset: Offset(0.0, 1.0),
        blurRadius: 4.6 * elevation,
        spreadRadius: 0.0),
  ];
}

const Color sBlueGray = Color(0xFFb4bbc9);
const Color solonGray200 = Color(0xFFdadcdf);
const Color solonGray300 = Color(0xFFADB5BD);
const Color solonGray400 = Color(0xFF9ea6ad);
const Color solonGray500 = Color(0xFF757b81);
const Color solonGray600 = Color(0xFF5b5f64);
const Color solonGray700 = Color(0xFF495057);

const Color darkColor = Color(0xFF253341);

Color sDarkGray = dDarkText.withOpacity(0.8);
Color sGray = dDarkText.withOpacity(0.4);
const dDarkText = Color(0xFF1D1D1D);
const Color dTurquoise = Color(0xFF0CB8B6);
const Color dPurple = Color(0xFF9F5DE2);
const Color dMiddleBlue = Color(0xFF5C86CE);
const Color dPurpleGradientLeft = Color(0xFF7A08FA);
const Color dPurpleGradientRight = Color(0xFFAD3BFC);
const Color dRedGradientRight = Color(0xFFE5366A);
const Color dRedGradientLeft = Color(0xFFFE806F);

const appLightGray = Color(0xFFE7ECF2);
const appMainLimeGreen = Color(0xFF96a038);
const appMainLimeGreen2 = Color(0xFF75bf43);
const appMainGreen = Color(0xFF00C853);
const appMainPink = Color(0xFFb81e4f);
const appMainViolet = Color(0xFF87449a);
const appMainDarkGrey = Color(0xFF253d47);
const appMainOrange = Color(0xFFba5927);
const appGray = Color(0xFFadb4b9);
const appDarkText = Color(0xFF2F2F2F);
const Color kMainAppColor = Color(0xFF);
const Color kHomeTextColor = Color(0xFFABE5E0);
const Color kAccountBackgroungColor = Color(0xFFABE5E0);
const Color kHomeAccessmentColor = Color(0xFF0367B4);
const Color kHomeBackgroundColor = Color(0xFFF6F6F6);
const Color kSecondaryTextColor = Color(0xFF707070);
const Color kAccessmentContainerColor = Color(0xFFEFEFEF);
const Color kAccessmentButtonColor = Color(0xFF00C9B9);



Widget displayLocalImage(String filePath,
    {double radius = 30.0, double? height, double? width}) {
  File file = new File(filePath);
  return radius > 20
      ? CircleAvatar(
          backgroundColor: solonGray200,
          backgroundImage: (filePath.isEmpty
              ? AssetImage('images/user_placeholder.png')
              : FileImage(file)) as ImageProvider<Object>?,
          radius: radius,
        )
      : Image(
          fit: BoxFit.fitWidth,
          height: height,
          width: width,
          image: (filePath.isEmpty
              ? AssetImage('images/user_placeholder.png')
              : FileImage(file)) as ImageProvider<Object>,
        );
}

Widget progress({double size = 30}) {
  return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
          backgroundColor: solonGray200,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFF00C9B9),
          )));
}

showLoaderDialog(BuildContext context, {String? message = "loading..."}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                message!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget sText(String? word,
    {double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = solonGray700,
    TextAlign align = TextAlign.left,
    int maxLines = 5,
    double? lHeight = 1.2,
    String family = 'Roboto',
    int shadow = 0}) {
  return Text(
    word ?? '...',
    softWrap: true,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: align,
    style: TextStyle(
      height: lHeight,
      color: color,
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      shadows:
          shadow > 0 ? elevation(color: Colors.black38, elevation: shadow) : [],
    ),
  );
}

Widget sText2(String? word,
    {double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = solonGray700,
    TextAlign align = TextAlign.left,
    int maxLines = 5,
    double? lHeight = 1.2,
    String family = 'ProximaRegular',
    int shadow = 0}) {
  return Text(
    word ?? '...',
    softWrap: true,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: align,
    style: TextStyle(
      height: lHeight,
      color: color,
      fontFamily: 'ProximaRegular',
      fontSize: size,
      fontWeight: weight,
      shadows:
          shadow > 0 ? elevation(color: Colors.black38, elevation: shadow) : [],
    ),
  );
}

Widget solonOutlineButton({
  required Widget content,
  required Function onPressed,
  textColor: Colors.white,
  double z: 16,
  double radius: 5,
  int shadowStrength: 1,
  double borderWidth: 1,
  double height: 60,
  EdgeInsetsGeometry? padding,
  Color outlineColor: const Color(0xFFf2f2f2),
  Color backgroundColor: Colors.white,
  String family = 'ProximaRegular',
}) {
  return Container(
    height: height,
    decoration: shadowStrength > 0
        ? BoxDecoration(
            boxShadow:
                elevation(color: solonGray200, elevation: shadowStrength),
            borderRadius: BorderRadius.circular(radius))
        : BoxDecoration(borderRadius: BorderRadius.circular(radius)),
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: outlineColor, width: borderWidth)),
      ),
      onPressed: () => onPressed(),
      child: content,
    ),
  );
}

Widget dPurpleGradientButton(
    {required Widget content,
    required Function onPressed,
    double radius: 5,
    double height: 50,
    EdgeInsetsGeometry? padding,
    List<Color> colors: const [dPurpleGradientLeft, dPurpleGradientRight],
    gradientDirection: 'left_right'}) {
  return SizedBox(
    height: height,
    child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: gradientDirection == 'left_right'
                ? Alignment.centerLeft
                : Alignment.topCenter,
            end: gradientDirection == 'left_right'
                ? Alignment.centerRight
                : Alignment.bottomCenter,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(radius)),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//          backgroundColor: col,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        ),
        onPressed: () => onPressed(),
        child: content,
      ),
    ),
  );
}

Future goTo(BuildContext context, Widget target,
    {bool replace = false,
    PageTransitionType anim = PageTransitionType.size,
    int millis = 200,
    bool opaque = true}) {
  if (!opaque) {
    if (!replace) {
      return Navigator.of(context).push(PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (BuildContext context, animation, secondaryAnimation) =>
              target,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          }));
    } else {
      return Navigator.of(context).pushReplacement(PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (BuildContext context, animation, secondaryAnimation) =>
              target,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          }));
    }
  }
  if (!replace) {
    return Navigator.push(
        context,
        PageTransition(
            type: anim,
            duration: Duration(milliseconds: millis),
            alignment: Alignment.bottomCenter,
            child: target));
  } else
    return Navigator.pushReplacement(
        context,
        PageTransition(
            type: anim,
            duration: Duration(milliseconds: millis),
            alignment: Alignment.bottomCenter,
            child: target));
}

TextStyle appStyle(
    {double size = 16,
    Color? col = dDarkText,
    FontWeight weight = FontWeight.w400,
    String family = "Poppins"}) {
  return TextStyle(
      fontFamily: family, fontWeight: weight, fontSize: size, color: col);
}

EdgeInsets noPadding() {
  return EdgeInsets.zero;
}

EdgeInsets appPadding(double size) {
  return EdgeInsets.all(size);
}

InputDecoration textDecor(
    {String hint = '',
    Widget? icon,
    String prefix = '',
    Widget? suffix,
    Widget? suffixIcon,
    bool enabled = true,
    Color? hintColor = solonGray500,
    double hintSize = 16,
    bool showBorder = true,
    double radius = 4,
    String label = '',
    EdgeInsetsGeometry padding =
        const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0)}) {
  return new InputDecoration(
    prefixIcon: icon,
    prefixText: prefix,
    suffix: suffix,
    suffixIcon: suffixIcon,
    hintText: hint,
    floatingLabelBehavior: (label.isNotEmpty && hint.isNotEmpty)
        ? FloatingLabelBehavior.never
        : FloatingLabelBehavior.auto,
    hintStyle: appStyle(size: hintSize, col: hintColor),
//    border: UnderlineInputBorder(
//      borderSide: BorderSide(color: theColor),
//    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
      borderRadius: BorderRadius.circular(radius),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[100]!, width: 1),
      borderRadius: BorderRadius.circular(radius),
    ),
    labelText: label,
    labelStyle: appStyle(size: hintSize, col: hintColor),
//    filled: true,
//    fillColor: Colors.white,
    contentPadding: padding,
  );
}

InputDecoration textDecorNoBorder(
    {String? hint,
    String prefix = '',
    Widget? suffix,
    Widget? prefixIcon,
    bool enabled = true,
    double hintSize = 16,
    Color? hintColor,
    String labelText = '',
    String family = "Poppins",
    FontWeight hintWeight: FontWeight.normal,
    Color? fill,
    Color borderColor = Colors.black,
    double radius = 4,
    EdgeInsetsGeometry padding =
        const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0)}) {
  return new InputDecoration(
    prefixText: prefix,
    suffix: suffix,
    prefixIcon: prefixIcon,
    hintText: hint,
    labelText: labelText,
    hintStyle: appStyle(
      size: hintSize,
      col: hintColor,
      weight: hintWeight,
      family: family,
    ),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(radius),

    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(radius),
    ),
    focusColor: dPurple,
    enabled: enabled,
    labelStyle: appStyle(size: hintSize,col: hintColor),
    filled: true,
    fillColor: fill,
    contentPadding: padding,
  );
}



showLogoutDialog(
    {String? message,
    BuildContext? context,
    Widget? target,
    bool replace = false}) {
  // flutter defined function
  showDialog(
    context: context!,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: sText("Alert",color: Colors.black,weight: FontWeight.bold),
        content: sText(message!),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          GestureDetector(
            onTap: ()async{
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
              margin: rightPadding(10),
              child: sText("No",color: Colors.white),

              decoration: BoxDecoration(
                  color:kAccessmentButtonColor,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),

          GestureDetector(
            onTap: ()async{
              await firebaseAuthService.signOut();
              toastMessage("Logout successfully");
              goTo(context, LogInPage(),replace: true);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
              margin: rightPadding(10),
              child: sText("Yes",color: Colors.white),

              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
        ],
      );
    },
  );
}

showDeleteDialog(
    {String? message,
      BuildContext? context,
      Widget? target,
      bool replace = false,int index = 0,bool deleteAll = false}) {
  // flutter defined function
  showDialog(
    context: context!,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: sText("Alert",color: Colors.black,weight: FontWeight.bold),
        content: sText(message!),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          GestureDetector(
            onTap: ()async{
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
              margin: rightPadding(10),
              child: sText("No",color: Colors.white),

              decoration: BoxDecoration(
                  color:kAccessmentButtonColor,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),

          GestureDetector(
            onTap: ()async{
              Navigator.pop(context);
              if(deleteAll){
                await DatabaseService().deleteAllUsersWeight();
              }else{
                await DatabaseService(documentId:listWeightedTrackerModel[index].documentId! ).deleteUserWeight();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 15),
              margin: rightPadding(10),
              child: sText("Yes",color: Colors.white),

              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          )

        ],
      );
    },
  );
}

appWidth(con) {
  return MediaQuery.of(con).size.width;
}

appHeight(con) {
  return MediaQuery.of(con).size.height;
}

List<BoxShadow> appShadow(
    Color col, double offset, double blur, double spread) {
  return [
    BoxShadow(
        blurRadius: blur,
        color: col,
        offset: Offset(0, 2.0),
        spreadRadius: spread),
  ];
}

EdgeInsets topPadding(double size) {
  return EdgeInsets.only(top: size);
}

EdgeInsets bottomPadding(double size) {
  return EdgeInsets.only(bottom: size);
}

EdgeInsets leftPadding(double size) {
  return EdgeInsets.only(left: size);
}

EdgeInsets rightPadding(double size) {
  return EdgeInsets.only(right: size);
}

EdgeInsets horizontalPadding(double size) {
  return EdgeInsets.symmetric(horizontal: size);
}

EdgeInsets verticalPadding(double size) {
  return EdgeInsets.symmetric(vertical: size);
}

properCase(String txt) {
  return txt.titleCase;
}

capCase(String txt) {
  return txt.toUpperCase();
}

sentenceCase(String txt) {
  if (txt.isEmpty) return txt;
  return txt.sentenceCase;
}

toastMessage(String text, {bool long = false}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      backgroundColor: dDarkText,
      textColor: Colors.white);
}

Map replaceNulls(Map m) {
  for (var i in m.keys) {
    if (m[i] is String) {
      if (m[i] == "null") {
        m[i] = '';
      }
    } else if (m[i] == Null) {
      m[i] = '';
    } else {
      m[i] = jsonEncode(m[i]);
    }
  }
  return m;
}

bool appIsEmpty(value) {
  return value.toString() == '' || value == null || value == 'null';
}

Map stripNulls(dynamic v) {
  Map m = v.toMap();
  Map<String, String> finalMap = v.toMap();
  for (var i in m.keys) {
    if (m[i] == "null") {
      finalMap.remove(i);
    }
  }
  return finalMap;
}

doDelete(String urlAfterBase) async {
  var url = Uri.parse('$base$urlAfterBase');
  print("url: $url");
  var js = await http.delete(url, headers: headers);
  var decoded;
  if(js.statusCode == 200){
    try {
      decoded = jsonDecode(js.body);
    } catch (e) {
      print("decoded: ${js.body}");
      print(e);
    }
  }else{
    decoded = js.statusCode.toString();
  }
  return decoded;
}

doPost(String urlAfterBase, Map body) async {
  print('Calling $base$urlAfterBase...');
  print('body $body...');
  var url = Uri.parse('$base$urlAfterBase');
  var decoded;
  http.Response js;
  js = await http.post(
    url,
    body: replaceNulls(body),
    headers: headers,
  );
  print("js:${jsonEncode(js.statusCode)}");

  print("body: ${js.body}");
  try {
    decoded = jsonDecode(js.body);
  } catch (e) {
    print("post: $e");
  }
  return decoded;
}

doGet(String urlAfterBase) async {
  var url = Uri.parse('$base$urlAfterBase');
  print("url: $url");
  var js;
  js = await http.get(url, headers: headers);

  var decoded;
  print("decoded: ${js.body}");
  try {
    decoded = jsonDecode(js.body);
  } catch (e) {
    print(e);
  }
  return decoded;
}

navigateTo(BuildContext context, Widget target,
    {bool replace = false,
    PageTransitionType anim = PageTransitionType.fade,
    int millis = 300,
    bool opaque = false}) {
  if (!replace) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (BuildContext context, animation, secondaryAnimation) =>
            target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        }));
  } else
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.size,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.bottomCenter,
            child: target));
}

extension StringExtension on String {
  static String displayTimeAgoFromTimestamp(String timestamp) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;
    if (diffInHours < 0) {
      diffInHours = diffInHours * -1;
      if (diffInHours < 1) {
        final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
        timeValue = diffInMinutes;
        timeUnit = 'm';
      } else if (diffInHours < 24) {
        timeValue = diffInHours;
        timeUnit = 'h';
      } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
        timeValue = (diffInHours / 24).floor();
        timeUnit = 'd';
      } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
        timeValue = (diffInHours / (24 * 7)).floor();
        timeUnit = 'w';
      } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
        timeValue = (diffInHours / (24 * 30)).floor();
        timeUnit = 'm';
      } else {
        timeValue = (diffInHours / (24 * 365)).floor();
        timeUnit = 'y';
      }
      timeAgo = timeValue.toString() + ' ' + timeUnit;
      timeAgo += timeValue > 1 ? '' : '';

      return 'in ' + timeAgo;
    } else {
      if (diffInHours < 1) {
        final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
        timeValue = diffInMinutes;
        timeUnit = 'm';
      } else if (diffInHours < 24) {
        timeValue = diffInHours;
        timeUnit = 'h';
      } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
        timeValue = (diffInHours / 24).floor();
        timeUnit = 'd';
      } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
        timeValue = (diffInHours / (24 * 7)).floor();
        timeUnit = 'wk';
      } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
        timeValue = (diffInHours / (24 * 30)).floor();
        timeUnit = 'mon';
      } else {
        timeValue = (diffInHours / (24 * 365)).floor();
        timeUnit = 'yr';
      }
      timeAgo = timeValue.toString() + timeUnit;
      timeAgo += timeValue > 1 ? '' : '';

      return timeAgo;
    }
  }
}



generateRandom(){
  var rng =  Random();
  var code = rng.nextInt(4294967296) + 100000;

  return code;
}

class ListNames {
  String name;
  String id;
  ListNames({this.name = '', this.id = ''});
}
