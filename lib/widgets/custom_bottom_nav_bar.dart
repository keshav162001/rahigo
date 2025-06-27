import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navButton(context, Icons.home, 0),
          _navButton(context, Icons.favorite, 1),
          _navButton(context, Icons.book_online, 2),
          _navButton(context, Icons.settings, 3),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[600],
        size: 28,
      ),
      onPressed: () => onTap(index),
    );
  }
}
