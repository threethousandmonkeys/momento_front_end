import 'package:flutter/cupertino.dart';

///This file contains all the widgets required to build the login page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momento/constants.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/screens/components/input_field.dart';
import 'package:momento/screens/components/ugly_button.dart';
import 'package:momento/services/auth_service.dart';
import 'package:momento/services/snack_bar_service.dart';
import 'components/card_divider.dart';
import 'components/bubble_indication_painter.dart';
import 'package:momento/bloc/sign_in_bloc.dart';

/// SignInPage: for user to sign in the application
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

/// _SignInPageState: state control of SignInPage
class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {
  final _snackBarService = SnackBarService();
  final _bloc =
      SignInBloc(AuthService(), FamilyRepository(), FlutterSecureStorage(), SnackBarService());

  bool _obscureTextSignIn = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  /// Basic setting for the sign in page (Size, Image, theme etc.)
  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width;
    double contentHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _bloc.scaffoldKey,
        body: Container(
          height: contentHeight,
          decoration: kLoginDecoration,
          // pale gold
          // color: Color(0xFFF2B396),
          // color: Color(0xFFF4B688),
          child: ListView(
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
                    _buildSignIn(),
                    _buildSignUp(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Before build the widget, init it. <flutter lifecycle>
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  /// After build the widget, dispose it. <flutter lifecycle>
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  /// customize the menu bar appear
  Widget _buildMenuBar(double width, double height) {
    double barRadius = height / 3;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: barRadius / 2,
        horizontal: width * (1 - kWidthRatio) * 0.5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x552B2B2B),
          borderRadius: BorderRadius.all(Radius.circular(barRadius)),
        ),
        child: CustomPaint(
          painter: TabIndicationPainter(
            pageController: _pageController,
            dxTarget: width * kWidthRatio * 0.5 - barRadius,
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

  /// customize the sign in page
  Widget _buildSignIn() {
    double width = MediaQuery.of(context).size.width * kWidthRatio;
    double buttonHeight = MediaQuery.of(context).size.height * 0.5 / 6;
    return Column(
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
                  controller: _bloc.signInEmailController,
                  icon: Icons.email,
                  hintText: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                CardDivider(
                  width: width * kDividerRatio,
                ),
                InputField(
                  controller: _bloc.signInPasswordController,
                  icon: Icons.lock,
                  hintText: "Password",
                  suffix: GestureDetector(
                    onTap: _toggleSignIn,
                    child: Icon(
                      _obscureTextSignIn ? Icons.visibility : Icons.visibility_off,
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
          color: Color(0xFF9E8C81),
          height: buttonHeight,
          transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
          onPressed: () async {
            if (_bloc.signInEmailController.text == "" ||
                _bloc.signInPasswordController.text == "") {
              _snackBarService.showInSnackBar(_bloc.scaffoldKey, "Please enter email/password");
            } else {
              _snackBarService.showInSnackBar(_bloc.scaffoldKey, "Logging In");
              final authUser = await _bloc.signIn(
                email: _bloc.signInEmailController.text.trim(),
                password: _bloc.signInPasswordController.text,
              );
              if (authUser != null) {
                Navigator.pop(context, authUser.uid);
              }
            }
          },
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
          child: Column(
            children: <Widget>[
              PlatformButton(
                /// force it to be flat button (no background color)
                androidFlat: (_) => MaterialFlatButtonData(),
                onPressed: () async {
                  final recoveryEmail = await showPlatformDialog(
                    context: context,
                    androidBarrierDismissible: false,
                    builder: (context) {
                      final descriptionController = TextEditingController();
                      return PlatformAlertDialog(
                        title: PlatformText("Enter email"),
                        content: PlatformTextField(
                          android: (_) => MaterialTextFieldData(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ios: (_) => CupertinoTextFieldData(
                              decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.0,
                              color: CupertinoColors.inactiveGray,
                              // color: Colors.black,
                            ),
                          )),
                          controller: descriptionController,
                        ),
                        actions: <Widget>[
                          PlatformDialogAction(
                            child: PlatformText("Cancel"),
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                          ),
                          PlatformDialogAction(
                            child: PlatformText("Send"),
                            onPressed: () {
                              Navigator.pop(
                                context,
                                descriptionController.text.trim(),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (recoveryEmail == null) {
                    return;
                  }
                  if (recoveryEmail != "") {
                    try {
                      await _bloc.recoverPassword(recoveryEmail);
                      showPlatformDialog(
                        context: context,
                        androidBarrierDismissible: false,
                        builder: (context) {
                          return PlatformAlertDialog(
                            title: PlatformText("Email sent"),
                            content: PlatformText("Please check your inbox."),
                            actions: <Widget>[
                              PlatformDialogAction(
                                child: PlatformText("Thanks"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      switch (e.code) {
                        case "ERROR_INVALID_EMAIL":
                          showPlatformDialog(
                            context: context,
                            androidBarrierDismissible: false,
                            builder: (context) {
                              return PlatformAlertDialog(
                                title: PlatformText("Something wrong"),
                                content: PlatformText("Wrong email format."),
                                actions: <Widget>[
                                  PlatformDialogAction(
                                    child: PlatformText("Try again"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          break;
                        case "ERROR_USER_NOT_FOUND":
                          showPlatformDialog(
                            context: context,
                            androidBarrierDismissible: false,
                            builder: (context) {
                              return PlatformAlertDialog(
                                title: PlatformText("Something wrong"),
                                content: PlatformText("User not found."),
                                actions: <Widget>[
                                  PlatformDialogAction(
                                    child: PlatformText("Try again"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          break;
                      }
                    }
                  } else {
                    showPlatformDialog(
                      context: context,
                      androidBarrierDismissible: false,
                      builder: (context) {
                        return PlatformAlertDialog(
                          title: PlatformText("Something wrong"),
                          content: PlatformText("No email input."),
                          actions: <Widget>[
                            PlatformDialogAction(
                              child: PlatformText("Try again"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
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
            ],
          ),
        ),
      ],
    );
  }

  /// customize the sign up page
  Widget _buildSignUp() {
    double width = MediaQuery.of(context).size.width * kWidthRatio;
    double buttonHeight = MediaQuery.of(context).size.height * 0.5 / 6;
    return Column(
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
                  controller: _bloc.familyNameController,
                  icon: Icons.person,
                  hintText: "Family Name",
                ),
                CardDivider(width: width * kDividerRatio),
                InputField(
                  controller: _bloc.signupEmailController,
                  icon: Icons.email,
                  hintText: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                CardDivider(width: width * kDividerRatio),
                InputField(
                  controller: _bloc.signupPasswordController,
                  icon: Icons.lock,
                  hintText: "Password",
                  suffix: GestureDetector(
                    onTap: _toggleSignup,
                    child: Icon(
                      _obscureTextSignup ? Icons.visibility : Icons.visibility_off,
                      size: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  obscureText: _obscureTextSignup,
                ),
                CardDivider(width: width * kDividerRatio),
                InputField(
                  controller: _bloc.signupConfirmPasswordController,
                  icon: Icons.lock,
                  hintText: "Confirmation",
                  suffix: GestureDetector(
                    onTap: _toggleSignupConfirm,
                    child: Icon(
                      _obscureTextSignupConfirm ? Icons.visibility : Icons.visibility_off,
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
          color: Color(0xFF9E8C81),
          transform: Matrix4.translationValues(0.0, -buttonHeight * 0.5, 0.0),
          onPressed: () async {
            if (_bloc.familyNameController.text == "" ||
                _bloc.signupEmailController.text == "" ||
                _bloc.signupPasswordController.text == "" ||
                _bloc.signupConfirmPasswordController.text == "")
              _snackBarService.showInSnackBar(_bloc.scaffoldKey, "Please fill in all the fields");
            else if (_bloc.signupPasswordController.text !=
                _bloc.signupConfirmPasswordController.text)
              _snackBarService.showInSnackBar(_bloc.scaffoldKey, "Passwords do not match");
            else {
              _snackBarService.showInSnackBar(_bloc.scaffoldKey, "Signing Up");
              final authUser = await _bloc.signUp(
                name: _bloc.familyNameController.text.trim(),
                email: _bloc.signupEmailController.text.trim(),
                password: _bloc.signupPasswordController.text,
              );
              Navigator.pop(context, authUser.uid);
            }
          },
        ),
      ],
    );
  }

  /// _onSignInButtonPress and _onSignUpButtonPress() change the widget from
  /// _buildSignUp to _buildSignIn once press the "Existing" button and
  /// vice versa if "New" button is pressed
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

  /// show / not show your passwords
  void _toggleSignIn() {
    setState(() {
      _obscureTextSignIn = !_obscureTextSignIn;
    });
  }

  /// show / not show your passwords
  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  /// show / not show your passwords
  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
