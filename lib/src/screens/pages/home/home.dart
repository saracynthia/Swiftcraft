import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/bottom_bar/bottom_bar.dart';
import '../../../cubit/category/category_cubit.dart';
import '../../../utils/data.dart';
import '../Products/category_products.dart';
import 'app_card.dart';
import 'recommnded_card.dart';
import '../Products/recommended_products.dart';
import '../Products/top_products.dart';
import 'category_name.dart';
import 'side_bar.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<HomePageState> homePageKey =
      GlobalKey<HomePageState>();

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: SideBar(
          controller: _controller,
          h: h,
        ),
        appBar: AppBar(
          elevation: 0,
          leading: FadeInAnimation(
              delay: 2,
              child: IconButton(
                onPressed: () {
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(
                  Iconsax.menu_1,
                  color: Colors.deepPurple,
                  size: 35,
                ),
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FadeInAnimation(
                delay: 2,
                child: SizedBox(
                  height: h * .045,
                  width: h * .045,
                  child: BlocBuilder<PageCubit, int>(
                    builder: (context, state) {
                      // const String imageKey = "HomeProfileImage";
                      return GestureDetector(
                        onTap: () {
                          //navigate to profile page
                          context.read<PageCubit>().onPageChanged(3);
                        },
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl:
                              "https://media.licdn.com/dms/image/D4D03AQGPqZiuen7qZw/profile-displayphoto-shrink_800_800/0/1698177711891?e=1711584000&v=beta&t=auvVIoYhX4u7ew-Ns22sOannnpAJLWFTzGN8cmVr590",
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FadeInAnimation(
                delay: 2,
                child: Row(
                  children: [
                    Text(
                      "Hello, ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sara",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const FadeInAnimation(
                delay: 2,
                child: Text(
                  "Find your favorite fashion",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              FadeInAnimation(
                delay: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: h * .06,
                          maxWidth: w * .75,
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: const Icon(
                          Iconsax.search_normal,
                          color: Colors.deepPurple,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.deepPurple.withOpacity(0.1),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(width: w * .02),
                    Container(
                      height: h * .06,
                      width: h * .06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple,
                      ),
                      child: const Icon(
                        Iconsax.filter,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FadeInAnimation(
                delay: 2,
                child: CarouselSlider.builder(
                  itemCount: adImageUrl.length,
                  itemBuilder: (context, index, _) {
                    return CachedNetworkImage(
                      imageUrl: adImageUrl[index].urlPath,
                      imageBuilder: (context, imageProvider) => Container(
                        height: h * .20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    );
                  },
                  options: CarouselOptions(
                    scrollPhysics: const ClampingScrollPhysics(),
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CategoryName(
                categoryName: 'Shop by Department',
                seeAll: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => CategyProducts(
                        h: h,
                        w: w,
                      ),
                    ),
                  );
                },
              ),
              HomeCategory(h: h),
              CategoryName(
                categoryName: 'Recommended',
                seeAll: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => RecommendedProducts(
                        h: h,
                        w: w,
                      ),
                    ),
                  );
                },
              ),
              RecommendedCard(
                h: h,
                w: w,
              ),
              CategoryName(
                categoryName: 'Top Products',
                seeAll: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => TopProducts(
                        h: h,
                        w: w,
                      ),
                    ),
                  );
                },
              ),
              AppCard(
                h: h,
                w: w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCategory extends StatelessWidget {
  const HomeCategory({
    super.key,
    required this.h,
  });

  final double h;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState is CategoryLoading) {
          // Display loading indicator if categories are still loading
          return const CircularProgressIndicator();
        } else if (categoryState is CategoryLoaded) {
          // Display categories once loaded
    
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              height: h * 0.06,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categoryState.categoyModel.length,
                itemBuilder: (_, index) {
                  String categoryName = categoryState
                          .categoyModel[index].categoryName ??
                      "Unknown";
                  String capitalize(String input) {
                    if (input.isEmpty) {
                      return input;
                    }
                    return input[0].toUpperCase() +
                        input.substring(1);
                  }
    
                  return FadeInAnimation(
                    delay: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple
                              .withOpacity(0.1), // Adjust as needed
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8, left: 8),
                          child: Center(
                            child: Text(
                              capitalize(categoryName),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (categoryState is CategoryError) {
          // Display an error message if fetching categories fails
          return Text("Error: ${categoryState.message}");
        } else {
          // Display a default state (e.g., initial state)
          return const Text("No data");
        }
      },
    );
  }
}
