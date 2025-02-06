import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message_outlined,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              //home tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("HOME"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              //settings tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("SETTINGS"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                  },
                ),
              ),
            ],
          ),
          //logout tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text("SIGN OUT"),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }
}
