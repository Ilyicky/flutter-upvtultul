import 'package:demo_app/global/global.dart';
import 'package:demo_app/pages/forgot_password_page.dart';
import 'package:demo_app/pages/login_page.dart';
import 'package:demo_app/pages/main_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State <RegisterPage> createState() => _RegisterPageState();
}

class  _RegisterPageState extends State<RegisterPage> {
  
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    //validate all the form fields
    if (_formKey.currentState!.validate()){
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        if(currentUser != null){
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };

          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainPage()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }


  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: (){
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
                  'Create a New Account',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Color(0xFF800000),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

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
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.white : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if(text == null || text.isEmpty){
                              return 'Name can\'t be empty';
                            }
                            if(text.length < 2){
                              return "Please enter a valid name";
                            }
                            if(text.length > 50){
                              return "Name can\'t be more than 50";
                            }
                          },
                          onChanged: (text) => setState((){
                            nameTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),

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
                            prefixIcon: Icon(Icons.email, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Email can\'t be empty';
                            }
                            if(EmailValidator.validate(text) == true){
                              return null;
                            }
                            if(text.length < 2){
                              return "Please enter a valid email";
                            }
                            if(text.length > 99){
                              return "Email can\'t be more than 100";
                            }
                          },
                          onChanged: (text) => setState((){
                            emailTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),

                        IntlPhoneField(
                          showCountryFlag: false,
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                          ),
                          decoration: InputDecoration(
                            hintText: "Phone",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.black45 : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                          ),
                          initialCountryCode: 'BD',
                          onChanged: (text) => setState((){
                            phoneTextEditingController.text = text.completeNumber;
                          }),
                        ),

                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100)
                          ],
                          decoration: InputDecoration(
                            hintText: "Address",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.black45 : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(Icons.home , color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Address can\'t be empty';
                            }
                            if(text.length < 2){
                              return "Please enter a valid address";
                            }
                            if(text.length > 99){
                              return "Address can\'t be more than 100";
                            }
                          },
                          onChanged: (text) => setState((){
                            addressTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),

                        TextFormField(
                          obscureText: !_passwordVisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.black45 : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(Icons.lock, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              onPressed: () {
                                // update the state i.e toggle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            )
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Password can\'t be empty';
                            }
                            if(text.length < 2){
                              return "Please enter a valid password";
                            }
                            if(text.length > 49){
                              return "Password can\'t be more than 50";
                            }
                            return null;
                          },
                          onChanged: (text) => setState((){
                            passwordTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),

                        TextFormField(
                          obscureText: !_passwordVisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true, 
                            fillColor: darkTheme ? Colors.black45 : Colors.white,
                            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                            ),
                            prefixIcon: Icon(Icons.lock, color: darkTheme ? Colors.amber.shade400 : Colors.grey,),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              onPressed: () {
                                // update the state i.e toggle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            )
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text){
                            if(text == null || text.isEmpty){
                              return 'Confirm Password can\'t be empty';
                            }
                            if(text != passwordTextEditingController.text){
                              return "Password do not match";
                            }
                            if(text.length < 2){
                              return "Please enter a valid password";
                            }
                            if(text.length > 49){
                              return "Password can\'t be more than 50";
                            }
                            return null;
                          },
                          onChanged: (text) => setState((){
                            confirmTextEditingController.text = text;
                          }),
                        ),

                        SizedBox(height: 20,),
                        
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTheme ? Color(0xFF014421) : Color(0xFF014421),
                            foregroundColor: darkTheme ? Colors.black : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),


                          onPressed: () {
                            _submit();
                            Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
                          }, 
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ),

                        SizedBox(height: 20,),
                        
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordPage()));
                          },
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
                              "Have an account? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(height: 29,),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
                              },
                              child: Text(
                                "Sign In",
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