import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/settings_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

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
                    Iconsax.message_favorite5,
                    size: 60,
                    color: isDarkMode ? Colors.grey.shade500 : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              //home tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "HOME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  title: Text(
                    "SETTINGS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              title: Text(
                "SIGN OUT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.logout),
              onTap: () => logout(context),
            ),
          )
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut();

    // then navigate to initial route (AuthGate())
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
