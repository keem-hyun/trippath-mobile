import 'package:flutter/material.dart';

class PlaceSearchPage extends StatelessWidget {
  const PlaceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장소 검색'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          '장소 검색 페이지',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}