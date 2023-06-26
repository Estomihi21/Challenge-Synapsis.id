import 'package:challengev2/views/bonus_page.dart';
import 'package:flutter/material.dart';
import 'PageA.dart';
import 'PageB.dart';
import 'PageC.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PageA(appBarTitle: 'Page A',),
    PageB(),
    PageC(),
    //BonusPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'A',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'C',
          ),
         // BottomNavigationBarItem(
          //  icon: Icon(Icons.bolt),
          //  label: 'Bonus',
        //  ),
        ],
      ),
    );
  }
}

