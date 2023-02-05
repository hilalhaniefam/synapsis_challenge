import 'package:flutter/material.dart';
import 'package:synapsis_project/views/screens/first_screen.dart';
import 'package:synapsis_project/views/screens/second_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;

  final screens = [const FirstScreen(), const SecondScreen()];

  void signOut() async {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[300],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                signOut();
              },
            )),
        backgroundColor: Colors.grey[300],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            hintColor: Colors.white,
            canvasColor: Colors.white,
            primaryColor: Colors.grey[300],
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.navigate_before,
                  size: 28,
                  color: Colors.grey,
                ),
                label: 'First Page',
                backgroundColor: Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.navigate_next,
                  size: 28,
                  color: Colors.grey,
                ),
                label: 'Second Page',
                backgroundColor: Colors.grey,
              )
            ],
            currentIndex: _index,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ),
        body: screens[_index]);
  }
}
