import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Analysis.dart';
import 'HomePage.dart';
import 'Settings.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOption = <Widget>[
    const Settings(),
    const HomePage(),
    const Analysis(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOption.elementAt(_selectedIndex),

      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            gap: 10,
            backgroundColor: Colors.black,
            color: Colors.white,
            tabBackgroundColor: Colors.white24,
            activeColor: Colors.white,
            padding: const EdgeInsets.all(18),
            tabs: const [
              GButton(
                icon: Icons.settings,
                text: "Setting",
              ),
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                  icon: Icons.analytics,
                  text: "Analysis"
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index){
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
