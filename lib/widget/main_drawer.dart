import 'package:flutter/material.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import '../screens/setttings_screen.dart';
import 'package:mymeals/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:mymeals/services/auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);
  Widget buildListTile(String title, IconData icon, Function() tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
                height: 270,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                color: Theme.of(context).colorScheme.secondary,
                child: const Center(
                    child:
                        Image(image: AssetImage('assets/images/appLogo.png')))),
          ),
          const SizedBox(
            height: 20,
          ),
          buildListTile(
            'Home',
            Icons.restaurant,
            () {
              Navigator.pushNamed(
                context,
                "/",
              );
            },
          ),
          buildListTile(
            'Settings',
            Icons.settings,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          buildListTile(
            'Sign Out',
            Icons.logout,
            () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
