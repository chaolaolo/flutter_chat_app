import 'package:chat_app/components/my_setting_tile.dart';
import 'package:chat_app/screens/blocked_users_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void confirmDeleteAccount(BuildContext context) async {

    //store user's decision in this boolean
    bool confirm = await showDialog(
          context: context,
          builder: (context) {
            bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
            return AlertDialog(
              title: Text("Confirm Delete"),
              content: Text("This will delete your account permanently, are you sure you want to continue?"),
              actions: [
                // cancel button
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
                  ),
                ),

                //confirm button
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  color: Colors.red,
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    //if the user confirmed, proceed with deletion
    if (confirm) {
      try{
        Navigator.pop(context);
        await AuthService().deleteAccount();
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueGrey.shade300,
      ),
      body: Column(
        children: [
          //change theme mode switch
          MySettingTile(
            title: "Dark mode",
            action: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
            color: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.inversePrimary,
          ),

          // blocked users (tap to go blocked users page)
          MySettingTile(
            title: "Blocked Users",
            action: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlockedUsersPage(),
                ),
              ),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            color: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.inversePrimary,
          ),

          //delete account (tap to delete account)
          MySettingTile(
            title: "Delete Account",
            action: IconButton(
              onPressed: () => confirmDeleteAccount(context),
              icon: Icon(
                Icons.delete_forever,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            color: Colors.red.shade400,
            textColor: Theme.of(context).colorScheme.inversePrimary,
          )
        ],
      ),
    );
  }
}
