import 'package:flixax_app/concept.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
void main() {
  runApp( Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navbar(),
    );
  }
}
