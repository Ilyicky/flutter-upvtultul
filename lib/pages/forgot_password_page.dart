import 'package:demo_app/global/global.dart';
import 'package:demo_app/pages/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final emailTextEditingController = TextEditingController();

  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth.sendPasswordResetEmail(
      email: emailTextEditingController.text.trim()
    ).then((value){
      Fluttertoast.showToast(msg: "We have sent you an email to recover password, please check your email");
    }).onError((error, stackTrace){
      Fluttertoast.showToast(msg: "Error Occured: \n ${error.toString()}");
    });
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
                'UPV Tultul App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Image.asset(darkTheme ? 'images/upv.png' : 'images/upv.png'),
            SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Color(0xFF800000),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please enter your email address and we\'ll send you a new password.',
                    style: TextStyle(
                      color: darkTheme ? Colors.amber.shade400 : Colors.black,
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
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
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.black45 : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if(text == null || text.isEmpty){
                              return "Email can't be empty";
                            }
                            if(EmailValidator.validate(text) == true){
                              return null;
                            }
                            if(text.length < 2){
                              return "Please enter a valid email";
                            }
                            if(text.length > 99){
                              return "Email can't be more than 100";
                            }
                            return null;
                          },
                          onChanged: (text) => setState((){
                            emailTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTheme ? Colors.amber.shade400 : Color(0xFF014421),
                            foregroundColor: darkTheme ? Colors.black : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),


                          onPressed: () {
                            _submit();
                          }, 
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ),

                        SizedBox(height: 20,),
                        
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: darkTheme ? Colors.amber.shade400 : Color(0xFF800000),
                            )
                          )
                        ),

                        SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(width: 5,),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: darkTheme ? Colors.amber.shade400 : Color(0xFF014421),
                                ),
                              ),
                            )
                          ],
                        )


                      ]
                    ),
                  ),
                ],
              ),
            )
          ]
        )
      )
    ); 
  }
}