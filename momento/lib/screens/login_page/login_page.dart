import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momento/constants.dart';
import 'package:momento/components/input_field.dart';
import 'package:momento/components/ugly_button.dart';
import 'components/card_divider.dart';
import 'components/bubble_indication_painter.dart';
import 'package:momento/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _auth;

  TextEditingController _signInEmailController = TextEditingController();
  TextEditingController _signInPasswordController = TextEditingController();
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _signupConfirmPasswordController =
      TextEditingController();
  TextEditingController _familyNameController = TextEditingController();

  bool _obscureTextSignIn = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    double contentWidth = MediaQuery.of(context).size.width * kWidthRatio;
    double contentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: kBackgroundDecoration,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: contentHeight / 10,
              ),
              Image(
                height: contentHeight * 3 / 10,
                image: AssetImage('assets/images/login_logo.png'),
              ),
              Container(
                height: contentHeight / 10,
                child: _buildMenuBar(contentWidth, contentHeight / 10),
              ),
              Container(
                height: contentHeight * 5 / 10,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    if (i == 0) {
                      setState(() {
                        right = Colors.white;
                        left = Colors.black;
                      });
                    } else if (i == 1) {
                      setState(() {
                        right = Colors.black;
                        left = Colors.white;
                      });
                    }
                  },
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: _buildSignIn(contentWidth, contentHeight * 5 / 10),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: _buildSignUp(contentWidth, contentHeight * 5 / 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold",
          ),
        ),
        backgroundColor: Color(0xFF9E8C81),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildMenuBar(double width, double height) {
    double barRadius = height / 3;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: barRadius / 2,
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Color(0x552B2B2B),
          borderRadius: BorderRadius.all(Radius.circular(barRadius)),
        ),
        child: CustomPaint(
          painter: TabIndicationPainter(
            pageController: _pageController,
            dxTarget: width * 0.5 - barRadius,
            radius: barRadius,
            dy: barRadius,
            dxEntry: barRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onSignInButtonPress,
                  child: Text(
                    "Existing",
                    style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold",
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onSignUpButtonPress,
                  child: Text(
                    "New",
                    style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignIn(double width, double height) {
    double buttonHeight = height / 6;
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: width,
              child: Column(
                children: <Widget>[
                  InputField(
                    controller: _signInEmailController,
                    icon: FontAwesomeIcons.solidEnvelope,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                  ),
                  CardDivider(
                    width: width * kDividerRatio,
                  ),
                  InputField(
                    controller: _signInPasswordController,
                    icon: FontAwesomeIcons.lock,
                    hintText: "Password",
                    suffix: GestureDetector(
                      onTap: _toggleSignIn,
                      child: Icon(
                        _obscureTextSignIn
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: _obscureTextSignIn,
                    bottomPadding: buttonHeight * 0.5,
                  ),
                ],
              ),
            ),
          ),
          UglyButton(
            text: "LOGIN",
            height: buttonHeight,
            transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
            onPressed: () async {
              if (_signInEmailController.text == "" ||
                  _signInEmailController.text == null ||
                  _signInPasswordController.text == "" ||
                  _signInPasswordController.text == null) {
                showInSnackBar("please enter email/password");
              } else {
                showInSnackBar("logging in");
                await _auth.signIn(
                  email: _signInEmailController.text,
                  password: _signInPasswordController.text,
                );
              }
            },
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    // _auth.sendPasswordResetEmail(email: signInEmail);
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white10, Colors.white],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        "Or",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "WorkSansMedium",
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white10,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: 100.0,
                      height: 1.0,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, right: 40.0),
                      child: GestureDetector(
                        onTap: () => showInSnackBar("Facebook button pressed"),
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: GestureDetector(
                        onTap: () => showInSnackBar("Google button pressed"),
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(double width, double height) {
    double buttonHeight = height / 6;
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 2.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: width,
              child: Column(
                children: <Widget>[
                  InputField(
                    controller: _familyNameController,
                    icon: FontAwesomeIcons.user,
                    hintText: "Family Name",
                  ),
                  CardDivider(width: width * kDividerRatio),
                  InputField(
                    controller: _signupEmailController,
                    icon: FontAwesomeIcons.solidEnvelope,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                  ),
                  CardDivider(width: width * kDividerRatio),
                  InputField(
                    controller: _signupPasswordController,
                    icon: FontAwesomeIcons.lock,
                    hintText: "Password",
                    suffix: GestureDetector(
                      onTap: _toggleSignup,
                      child: Icon(
                        _obscureTextSignup
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: _obscureTextSignup,
                  ),
                  CardDivider(width: width * kDividerRatio),
                  InputField(
                    controller: _signupConfirmPasswordController,
                    icon: FontAwesomeIcons.lock,
                    hintText: "Confirmation",
                    suffix: GestureDetector(
                      onTap: _toggleSignupConfirm,
                      child: Icon(
                        _obscureTextSignupConfirm
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    obscureText: _obscureTextSignupConfirm,
                    bottomPadding: buttonHeight * 0.5,
                  ),
                ],
              ),
            ),
          ),
          UglyButton(
            text: "SIGNUP",
            height: buttonHeight,
            transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
            onPressed: () {
              if (_familyNameController.text == "" ||
                  _signupEmailController.text == "" ||
                  _signupPasswordController.text == "" ||
                  _signupConfirmPasswordController.text == "")
                showInSnackBar("Please fill all the fields");
              else if (_signupPasswordController.text !=
                  _signupConfirmPasswordController.text)
                showInSnackBar("passwords do not match");
              else {
                showInSnackBar("signing up");
                _auth.signUp(
                  name: _familyNameController.text,
                  email: _signupEmailController.text,
                  password: _signupPasswordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(
      1,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void _toggleSignIn() {
    setState(() {
      _obscureTextSignIn = !_obscureTextSignIn;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
