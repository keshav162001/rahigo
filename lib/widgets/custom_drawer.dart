import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;

  const CustomDrawer({Key? key, this.userName, this.userEmail}) : super(key: key);

  Widget _buildUserHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Hello, ${userName ?? 'Rahi'}!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          userEmail ?? "Guest",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: _buildUserHeader(context),
          ),
          ExpansionTile(
            title: Text("Explore", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              ListTile(title: Text("Nearby"), onTap: () {}),
              ListTile(
                title: Text("Top Rated"),
                onTap: () => Navigator.pushNamed(context, '/top-rated'),
              ),
              ListTile(title: Text("Hidden Gems"), onTap: () {}),
            ],
          ),
          ExpansionTile(
            title: Text("Season", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              ListTile(title: Text("Winter"), onTap: () {}),
              ListTile(title: Text("Summer"), onTap: () {}),
              ListTile(title: Text("Monsoon"), onTap: () {}),
            ],
          ),
          ListTile(
            title: Text("Past Trips", style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          ExpansionTile(
            title: Text("Category: Utility", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              ListTile(title: Text("Emergency"), onTap: () {}),
              ListTile(title: Text("Language Assist"), onTap: () {}),
              ListTile(title: Text("Contact"), onTap: () {}),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
