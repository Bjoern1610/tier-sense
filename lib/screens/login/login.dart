import 'package:FoodSense/screens/tier/tier.dart';
import 'package:FoodSense/style/constant.dart';
import 'package:FoodSense/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  Login({Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Widget _buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: BACKGROUND_COLOR,
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'F',
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'HelloStockholm',
        fontSize: 200,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 20,
          )
        ],
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-Mail',
          style: LABEL_STYLE,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 40,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your E-Mail',
              hintStyle: HINT_STYLE,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextFieldPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: LABEL_STYLE,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 40,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: HINT_STYLE,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          // TODO
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.only(right: 0),
        child: Text(
          'Forgot Password?',
          style: LABEL_STYLE,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Tier()));
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: LOGIN_STYLE,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundColor(),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  _buildHeadline(),
                  _buildTextFieldEmail(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildTextFieldPassword(),
                  _buildForgotPassword(),
                  _buildLoginButton(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}