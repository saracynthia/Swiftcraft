import 'package:ecommerce_app/src/screens/pages/search.dart';
import 'package:ecommerce_app/src/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../cubit/bottom_bar/bottom_bar.dart';
import 'pages/cart/cart.dart';
import 'pages/home/home.dart';

class PageRoot extends StatelessWidget {
  const PageRoot({Key? key}) : super(key: key);

  final List<Widget> bottomBarPages = const [
    HomePage(),
    Search(),
    CartPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: context.read<PageCubit>().pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: bottomBarPages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.deepPurple.withOpacity(0.6),
            onTap: (index) {
              context.read<PageCubit>().onPageChanged(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.search_normal),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_bag),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
