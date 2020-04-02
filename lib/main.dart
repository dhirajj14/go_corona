import 'package:flutter/material.dart';
import 'custom_icons.dart' as CustomIcons;
import 'countries.dart';
import 'world.dart';

void main() => runApp(TotalWidget());

class TotalWidget extends StatefulWidget {
  @override
  _TotalWidgetState createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<TotalWidget> {

  List<Widget> _children = [
    WorldWidget(),
    CountriesWidget(Colors.white),
  ];
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
         return new MaterialApp(
        home: new Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            title: new Text("Go Corona"),
            backgroundColor: Colors.red[800],
          ),

          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.CustomIcons.earth),
                title: Text('Gobal'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag),
                title: Text('Country'),
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.red[800],
            onTap: onTabTapped,
          ),
        ),
      );
    }
}






