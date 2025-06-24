import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    _user = FirebaseAuth.instance.currentUser ;
    if (_user != null) {
      _userName = _user?.displayName;
    }
    setState(() {});
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser  = await GoogleSignIn().signIn();
      if (googleUser  == null) return;

      final googleAuth = await googleUser .authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _user = userCredential.user;
        _userName = _user?.displayName;
      });
    } catch (e) {
      print("Sign-in error: $e");
    }
  }

  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
      _userName = null;
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromRGBO(250, 82, 140, 1),
                  backgroundImage: _user?.photoURL != null
                      ? NetworkImage(_user!.photoURL!)
                      : null,
                  child: _user?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName ?? "Guest",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      if (_user != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _user!.email ?? 'No email',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _user == null ? _signInWithGoogle : _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(217, 65, 79, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 6),
                  ),
                  child: Text(
                    _user == null ? "Log In" : "Log Out",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 190, 0, 1),
                Color.fromRGBO(255, 85, 253, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Subscribe",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito')),
                  SizedBox(height: 4),
                  Text("Unlock more episodes",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Nunito')),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text("Subscribe Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildWallet(),
        const SizedBox(height: 50),
        _buildSettingsSection(),
      ],
    );
  }

  Widget _buildWallet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 62, 62),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("My Wallet",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700)),
              Icon(Icons.chevron_right, color: Colors.white54)
            ],
          ),
          const Divider(color: Colors.white24, thickness: 0.7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text('0',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800)),
                  SizedBox(width: 3),
                  Text('Coins',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 16),
                  Text('0',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800)),
                  SizedBox(width: 4),
                  Text('Coins',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(217, 65, 79, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 6)),
                child: const Text("Top Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 62, 62),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text("Rewards",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito')),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text("Rewards from daily tasks",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Nunito')),
                  )
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 16),
            ],
          ),
          const Divider(color: Colors.white24),
          SectionHeader(name: "Feedback"),
          const Divider(color: Colors.white24),
          SectionHeader(name: "Language"),
          const Divider(color: Colors.white24),
          SectionHeader(name: "Settings"),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String name;
  const SectionHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito')),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}