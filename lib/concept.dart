import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flixax_app/foryou.dart';
import 'package:flixax_app/homepage.dart';
import 'package:flixax_app/mylist.dart';
import 'package:flixax_app/profile.dart';
import 'package:flixax_app/rewards.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Homepage(),
    MainVideoFeed(),
    Mylist(),
    Profile(),
    Rewards()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.transparent, // overridden
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: [
          _buildGradientNavItem(
            'assets/Icons/home_selected.svg',
            "Home",
            0,
            selectedIconPath: 'assets/Icons/home.svg',
            selectedLabel: "Home",
          ),
          _buildGradientNavItem(
            'assets/Icons/for_you.svg',
            "For You",
            1,
            selectedIconPath: 'assets/Icons/for_you_selected.svg',
          ),
          _buildGradientNavItem(
            'assets/Icons/my_list.svg',
            "My List",
            2,
            selectedIconPath: 'assets/Icons/my_list_selected.svg',
          ),
          _buildGradientNavItem(
            'assets/Icons/user.svg',
            "Profile",
            3,
            selectedIconPath: 'assets/Icons/user_selected.svg',
          ),
          _buildGradientNavItem(
            'assets/Icons/rewards.svg',
            "Rewards",
            4,
            selectedIconPath: 'assets/Icons/rewards_selected.svg',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildGradientNavItem(
    String iconPath,
    String label,
    int index, {
    String? selectedIconPath,
    String? selectedLabel,
  }) {
    bool isSelected = _selectedIndex == index;

    final gradient = const LinearGradient(
      colors: [
        Color.fromRGBO(255, 190, 0, 1),
        Color.fromRGBO(255, 85, 253, 1),
        Color.fromRGBO(127, 187, 255, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

//    final gradient = const LinearGradient(
//   colors: [
//     Color.fromRGBO(255, 190, 0, 1),
//     Color.fromRGBO(255, 85, 253, 1),
//     Color.fromRGBO(127, 187, 255, 1),
//   ],
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
// );

Widget icon = isSelected
    ? ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: SvgPicture.asset(
          selectedIconPath ?? iconPath,
          width: 34,
          height: 34,
          color: Colors.white, // Required for ShaderMask to apply
        ),
      )
    : SvgPicture.asset(
        iconPath,
        width: 34,
        height: 34,
        color: Colors.grey,
      );

    String displayLabel = isSelected && selectedLabel != null ? selectedLabel : label;

    Widget labelWidget = isSelected
        ? ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              displayLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.white, // Needed for ShaderMask
              ),
            ),
          )
        : Text(
            displayLabel,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          );

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 4),
          labelWidget,
        ],
      ),
      label: '',
    );
  }
}
