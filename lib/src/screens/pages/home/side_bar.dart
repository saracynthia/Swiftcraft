import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/bottom_bar/bottom_bar.dart';

class SideBar extends StatelessWidget {
  final double h;

  const SideBar({
    Key? key,
    required SidebarXController controller,
    required this.h,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      delay: 1.5,
      child: SidebarX(
        controller: _controller,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 16,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.deepPurple,
            fontSize: 16,
          ),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.7),
            size: 25,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.deepPurple,
            size: 25,
          ),
        ),
        extendedTheme: const SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        footerDivider: Divider(
          color: Colors.black.withOpacity(0.7),
          thickness: 0.5,
        ),
        headerBuilder: (context, extended) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (_) => CartPage(
              //       cartItems: cartItems,
              //       h: h,
              //       w: w,
              //       onClick: (GlobalKey widgetKey, int index) {
              //         listClick(widgetKey, index);
              //       },
              //     ),
              //   ),
              // );
            },
            child: SizedBox(
              height: h * .15,
              child: BlocBuilder<PageCubit, int>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
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
                          "https://media.licdn.com/dms/image/D4D03AQE39lHM9OGPTA/profile-displayphoto-shrink_800_800/0/1709657498386?e=1726704000&v=beta&t=vHEygdAXsNG8_J5it48ItbWlLd3beYEvN9hCbV8DQ0o",
                    ),
                  );
                },
              ),
            ),
          );
        },
        items: const [
          SidebarXItem(icon: Iconsax.notification, label: 'Notifications'),
          SidebarXItem(icon: Iconsax.setting_2, label: 'Settings'),
          SidebarXItem(icon: Iconsax.message_question, label: 'FAQ'),
          SidebarXItem(icon: Iconsax.support, label: 'Help'),
        ],
      ),
    );
  }
}
