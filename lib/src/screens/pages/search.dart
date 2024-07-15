import 'package:flutter/material.dart';

import '../../animations/fade_in.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FadeInAnimation(delay: 1,
      child: Text('Search')),
    );
  }
}