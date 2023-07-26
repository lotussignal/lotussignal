import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/pages/user/home_page.dart';
import 'package:signalbyt/pages/learn/learn_page.dart';
import 'package:signalbyt/pages/signals/signals_init_page.dart';
import 'package:signalbyt/pages/user/notifications_page.dart';

import '../../../models_providers/navbar_provider.dart';
import '../constants/app_colors.dart';
import 'user/my_account_page.dart';

class AppNavbarPage extends StatefulWidget {
  const AppNavbarPage({Key? key}) : super(key: key);

  @override
  _AppNavbarPageState createState() => _AppNavbarPageState();
}

class _AppNavbarPageState extends State<AppNavbarPage> {
  late PageController _pageController;

  @override
  void initState() {
    final appProvider = Provider.of<NavbarProvider>(context, listen: false);
    _pageController = PageController(initialPage: appProvider.selectedPageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<NavbarProvider>(context, listen: false);
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          duration: const Duration(milliseconds: 300),
          child: pages.elementAt(appProvider.selectedPageIndex)),
      bottomNavigationBar: CustomNavigationBar(
        blurEffect: false,
        onTap: (v) {
          appProvider.selectedPageIndex = v;
          if (_pageController.hasClients) _pageController.animateToPage(v, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        // iconSize: 20.0,
        selectedColor: Colors.white,
        strokeColor: Colors.white,
        backgroundColor: isLightTheme ? Colors.grey.shade300 : Color(0xFF35383F).withOpacity(.8),
        borderRadius: Radius.circular(20.0),
        opacity: 1,
        elevation: 0,
        currentIndex: appProvider.selectedPageIndex,
        isFloating: true,
        items: [
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home.svg',
                colorFilter: ColorFilter.mode(getIconColor(0), BlendMode.srcIn), height: getIconHeight(0), width: getIconHeight(0)),
            title: Text('Home', style: TextStyle(color: getIconColor(0), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/learn.svg',
                colorFilter: ColorFilter.mode(getIconColor(1), BlendMode.srcIn), height: getIconHeight(1), width: getIconHeight(1)),
            title: Text('Learn', style: TextStyle(color: getIconColor(1), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/go-long.svg',
                colorFilter: ColorFilter.mode(getIconColor(2), BlendMode.srcIn), height: getIconHeight(2), width: getIconHeight(2)),
            title: Text('Signals', style: TextStyle(color: getIconColor(2), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/notification.svg',
                colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn), height: getIconHeight(3), width: getIconHeight(3)),
            title: Text('Alerts', style: TextStyle(color: getIconColor(3), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/user.svg',
                colorFilter: ColorFilter.mode(getIconColor(4), BlendMode.srcIn), height: getIconHeight(4), width: getIconHeight(4)),
            title: Text('Profile', style: TextStyle(color: getIconColor(4), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  double getIconHeight(int index) {
    final appProvider = Provider.of<NavbarProvider>(context);
    final selectedIndex = appProvider.selectedPageIndex;
    return selectedIndex == index ? 24 : 20;
  }

  Color getIconColor(int index) {
    final appProvider = Provider.of<NavbarProvider>(context);
    final selectedIndex = appProvider.selectedPageIndex;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color color = isLightTheme ? Colors.black26 : Colors.white24;
    if (selectedIndex == index) return isLightTheme ? appColorBlue : appColorYellow;
    return color;
  }

/* ----------------------------- NOTE UserPages ----------------------------- */

  List<Widget> pages = [
    HomePage(),
    LearnPage(),
    SignalsInitPage(type: 'long', key: ObjectKey('long')),
    NotificationsPage(),
    MyAccountPage(),
  ];
}
