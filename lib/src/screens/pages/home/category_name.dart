import 'package:flutter/material.dart';

import '../../../animations/fade_in.dart';

class CategoryName extends StatelessWidget {
  final String categoryName;
  final Function seeAll;
  const CategoryName({
    Key? key,
    required this.categoryName,
    required this.seeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      delay: 2,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                seeAll();
              },
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
