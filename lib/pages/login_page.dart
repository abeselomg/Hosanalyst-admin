import 'all_games.dart';
import 'package:flutter/material.dart';
import '../widgets/login_form_widgets.dart';
import '../helpers/utils.dart';
import '../helpers/api_services.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _isLoading = false;
  String phone = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF298939),
                    Color(0xFF185a9d),
                  ],
                ))),
            const TopSginin(),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.10,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: whiteshade,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09),
                        child: Image.asset("assets/images/HosanalystLogo.png"),
                      ),
                      InputField(
                        headerText: "Phone Number",
                        hintTexti: "Use +251 extenion",
                        onphonechanged: (String value) {
                          phone = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFieldPassword(
                        headerText: "Password",
                        hintTexti: "At least 8 Charecter",
                        onpasswordchanged: (String value) {
                          password = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  login(phone, password).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AllGames(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      showSnackBar(context,
                                          "Incorrect Phone Number or Password");
                                    }
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: const BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF298939),
                                          Color(0xFF298939),
                                        ],
                                      )),
                                  child: Center(
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                          color: whiteshade),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
