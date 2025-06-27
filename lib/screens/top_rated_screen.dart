import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

class TopRatedScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1548013146-72479768bada',
    'https://images.unsplash.com/photo-1651391851072-a63e01878f75?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1621963203282-c5a32b4a13ae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1744807818861-6985efe42ae7?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1715405155995-61757307e065?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1705861145347-254fcb6685d9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',

  ];

  @override
  Widget build(BuildContext context) {
    final TCardController _controller = TCardController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated'),
        centerTitle: true,
      ),
      body: Center(
        child: TCard(
          controller: _controller,
          size: Size(MediaQuery.of(context).size.width * 0.9, 500),
          cards: imageUrls.map((url) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
            );
          }).toList(),
          onForward: (index, info) {
            print('Swiped ${info.direction}');
          },
          onEnd: () {
            print('No more cards');
          },
        ),
      ),
    );
  }
}
