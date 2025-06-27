import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/search_bar_filter.dart';
import '../widgets/category_selector.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../places/category_detail_page.dart';
import '../places/saved_places_page.dart'; // ⬅️ Import Saved Page
import '../widgets/custom_drawer.dart';
import '../widgets/monuments_carousel.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedCategory = 0;
  int selectedNavIndex = 0;
  bool _showSearchBar = false;
  String? userName;
  String? userEmail;

  final List<String> categories = [
    '🏙️ Cities',
    '⛰️ Hills',
    '🏖️ Beaches',
    '🛕 Spiritual',
    '🏰 Heritage',
    '🏞️ Wildlife',
    '🏜️ Deserts',
    '🏝️ Islands'
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  late Future<void> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _userInfoFuture = fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userName = doc['name'];
          userEmail = doc['email'];
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearchFilter() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      _showSearchBar ? _controller.forward() : _controller.reverse();
    });
  }

  void _navigateWithAnimation(BuildContext context, String categoryName) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, animation, __) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0), // Slide from right
              end: Offset.zero,
            ).animate(animation),
            child: CategoryDetailPage(categoryName: categoryName),
          ),
        );
      },
    ));
  }

  void _handleBottomNavTap(int index) {
    if (index == 1) {
      // Favorite icon tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SavedPlacesPage()),
      );
    } else {
      setState(() {
        selectedNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          drawer: CustomDrawer(userName: userName, userEmail: userEmail),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            title: Text("Hello, ${userName ?? 'Rahi'}!"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  _showSearchBar
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: _toggleSearchFilter,
              ),
            ],
          ),
          body: Column(
            children: [
              SearchBarFilter(animation: _animation),
              CategorySelector(
                categories: categories,
                selectedIndex: selectedCategory,
                onTap: (index) {
                  setState(() => selectedCategory = index);
                  _navigateWithAnimation(context, categories[index]);
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 20, bottom: 90),
                  children: [
                    MonumentsCarousel(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: CustomBottomNavBar(
            selectedIndex: selectedNavIndex,
            onTap: _handleBottomNavTap,
          ),
        );
      },
    );
  }
}
