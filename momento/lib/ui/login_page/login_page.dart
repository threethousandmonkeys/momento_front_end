import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momento/style/theme.dart' as Theme;
import 'package:momento/utils/bubble_indication_painter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:momento/constants.dart';
import 'input_field.dart';
import 'card_divider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _loginEmail;
  String _loginPassword;
  String _signupEmail;
  String _signupPassword;
  String _signupConfirmPassword;

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width * kWidthRatio;
    double contentHeight = MediaQuery.of(context).size.height * kWidthRatio;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.Colors.loginGradientStart,
              Theme.Colors.loginGradientEnd,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 3,
              child: Image(
                image: AssetImage('assets/images/login_logo.png'),
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildMenuBar(contentWidth, contentHeight / 10),
            ),
            Expanded(
              flex: 5,
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
    );
  }

  @override
  void dispose() {
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
    double offset = 2;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: barRadius,
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Color(0x552B2B2B),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: CustomPaint(
          painter: TabIndicationPainter(
            pageController: _pageController,
            dxTarget: width / 2 - barRadius - offset,
            radius: barRadius,
            dy: barRadius + offset,
            dxEntry: barRadius + offset,
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
    double textFieldHeight = height / 5;
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
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
                      InputTextField(
                        textFieldHeight: textFieldHeight,
                        onChange: (value) {
                          _loginEmail = value;
                        },
                        icon: FontAwesomeIcons.solidEnvelope,
                        hintText: "Email",
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      InputTextField(
                        textFieldHeight: textFieldHeight * 4 / 3,
                        onChange: (value) {
                          _loginPassword = value;
                        },
                        icon: FontAwesomeIcons.lock,
                        hintText: "Password",
                        suffix: GestureDetector(
                          onTap: _toggleLogin,
                          child: Icon(
                            _obscureTextLogin
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: textFieldHeight * 2),
                child: MaterialButton(
                  color: Color(0xFF9E8C81),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      "LOGIN",
                      style: kButtonTextStyle,
                    ),
                  ),
                  onPressed: () async {
                    if (_loginEmail == "" ||
                        _loginEmail == null ||
                        _loginPassword == "" ||
                        _loginPassword == null) {
                      showInSnackBar("please enter email/password");
                    } else {
                      showInSnackBar("logging in");
                      _login();
                    }
                  },
                ),
              ),
            ],
          ),
          FlatButton(
            onPressed: () {
              // _auth.sendPasswordResetEmail(email: loginEmail);
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
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
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
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
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
                    padding: const EdgeInsets.all(15.0),
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
                    padding: const EdgeInsets.all(15.0),
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
    );
  }

  Widget _buildSignUp(double width, double height) {
    double textFieldHeight = height / 5;
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
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
                      InputTextField(
                        textFieldHeight: textFieldHeight,
                        onChange: (value) {
                          ;
                        },
                        icon: FontAwesomeIcons.user,
                        hintText: "Name",
                      ),
                      CardDivider(width: width * kDividerRatio),
                      InputTextField(
                        textFieldHeight: textFieldHeight,
                        onChange: (value) {
                          _signupEmail = value;
                        },
                        icon: FontAwesomeIcons.solidEnvelope,
                        hintText: "Email",
                      ),
                      CardDivider(width: width * kDividerRatio),
                      InputTextField(
                        textFieldHeight: textFieldHeight,
                        onChange: (value) {
                          _signupPassword = value;
                        },
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
                      ),
                      CardDivider(width: width * kDividerRatio),
                      InputTextField(
                        textFieldHeight: textFieldHeight * 4 / 3,
                        onChange: (value) {
                          _signupPassword = value;
                        },
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: textFieldHeight * 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gradient: LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  color: Color(0xFF9E8C81),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 42.0,
                    ),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: "WorkSansBold",
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_signupPassword != _signupConfirmPassword) {
                      showInSnackBar("passwords do not match");
                    } else {
                      showInSnackBar("signing up");
                      _signup();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
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

  void _login() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: _loginEmail,
        password: _loginPassword,
      );
      if (user != null) {
        showInSnackBar("Login successful");
      }
    } catch (e) {
      print(e);
      showInSnackBar("wrong email/password");
    }
  }

  void _signup() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: _signupEmail,
        password: _signupPassword,
      );
      if (newUser != null) {
        showInSnackBar("signup successful");
      }
    } catch (e) {
      print(e);
      showInSnackBar("something wrong");
    }
  }
}



