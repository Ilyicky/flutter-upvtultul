import 'package:demo_app/global/global.dart';
import 'package:demo_app/pages/forgot_password_page.dart';
import 'package:demo_app/pages/home_management.dart';
import 'package:demo_app/pages/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;
        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeManagement()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              height: 90,
              color: Color(0xFF800000),
              padding: EdgeInsets.only(left: 15, top: 35),
              alignment: Alignment.centerLeft,
              child: Text(
                'UPV Tultul App Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Image.asset(darkTheme ? 'images/upv.png' : 'images/upv.png'),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true, 
                            fillColor: Colors.white,
                            border: OutlineInputBorder( // Applies to all states
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(
                              Icons.person, 
                              color: darkTheme ? Color(0xFF800000) : Colors.grey,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) return 'Email can\'t be empty';
                            if (!EmailValidator.validate(text)) return 'Please enter a valid email';
                            if (text.length > 99) return "Email can\'t be more than 100";
                            return null;
                          },
                          onChanged: (text) => setState(() {
                            emailTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20),

                        TextFormField(
                          obscureText: !_passwordVisible,
                          inputFormatters: [LengthLimitingTextInputFormatter(50)],
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder( // Applies to all states
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(
                              Icons.lock, 
                              color: darkTheme ? Color(0xFF800000) : Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) return 'Password can\'t be empty';
                            if (text.length < 2) return "Please enter a valid password";
                            if (text.length > 49) return "Password can\'t be more than 50";
                            return null;
                          },
                          onChanged: (text) => setState(() {
                            passwordTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTheme ? Color(0xFF800000) : Color(0xFF014421),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: _submit,

                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        SizedBox(height: 20),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordPage()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: darkTheme ? Colors.amber.shade400 : Color(0xFF800000),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Doesn't have an account? ",
                              style: TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterPage()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: darkTheme ? Colors.amber.shade400 : Color(0xFF014421),
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
            ),
          ],
        ),
      ),
    );
  }
}