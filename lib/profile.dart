import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      print("Sign-in error: $e");
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromRGBO(250, 82, 140, 1),
                  backgroundImage: _user?.photoURL != null ? NetworkImage(_user!.photoURL!) : null,
                  child: _user?.photoURL == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user?.displayName ?? "Visitor 3479019",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            _user?.email ?? "ID 32479019",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          if (_user != null)
                            SizedBox(width: 6),
                          if (_user != null)
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: _user!.email!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Copied to clipboard")),
                                );
                              },
                              child: Icon(
                                Icons.copy,
                                color: Colors.white54,
                                size: 15,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _user == null ? _signInWithGoogle : _signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(217, 65, 79, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                    ),
                    child: Text(
                      _user == null ? "Log In" : "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 190, 0,1),
                  Color.fromRGBO(255,85,253,1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Subscribe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Nunito'
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Unlock more episodes",
                      style: TextStyle(
                        color: Colors.white70,
                         fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Nunito'
                         ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    "Subscribe Now",
                    style: TextStyle(
                      color: Colors.white,
                       fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nunito'
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 65, 62, 62),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("My Wallet",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                          ),),
                          Icon(Icons.chevron_right,
                          color: Colors.white54,)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          color: Colors.white24,
                          thickness: 0.7,
                        ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800
                                  ),
                                ),
                                SizedBox(width: 3,),
                                Text(
                                  'Coins',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                SizedBox(width: 16,),
                                Text("0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w800
                                ),),
                                SizedBox(width: 4,),
                                Text('Coins',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                            ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(217,65,79,1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 6
                                )
                              ), 
                              child:Text(
                                "Top Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500
                                ),
                              ) )
                          ],
                        )
                    ],
                  ),
                ),
                SizedBox(height: 50,),
               Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                   color: const Color.fromARGB(255, 65, 62, 62),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  "Rewards",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito'
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                              
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              
                              child: Text(
                                "Rewards from daily tasks",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Nunito'
                                ),
                              ),)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          )
                        ]
                        ),
                        Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Divider(
                          color: Colors.white24,
                          thickness: 1,
                        ),
                        ),
                SectionHeader(name: "Feedback" ),
                 Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Divider(
                          color: Colors.white24,
                          thickness: 1,
                        ),
                        ),
                SectionHeader(name: "Language" ),
                 Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Divider(
                          color: Colors.white24,
                          thickness: 1,
                        ),
                        ),
                SectionHeader(name: "Settings" ),],
                      ),),
                 
              ],
            ),
            )
         
          
        ],
      ),
    );
  }
}
