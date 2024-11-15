import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dashboard_bottom_navigation_bar.dart';

class DashboardPage extends StatelessWidget {
  final Widget child; // Child widget from ShellRoute

  const DashboardPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Render the current route's child
      bottomNavigationBar: DashboardBottomNavigationBar(
        selectedIndex: _getSelectedIndex(context),
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }

  // Determine the active tab based on the current route location
  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/main/home')) return 0;
    if (location.startsWith('/main/list')) return 1;
    if (location.startsWith('/main/favourite')) return 2;
    if (location.startsWith('/main/inbox')) return 3;
    if (location.startsWith('/main/profile')) return 4;
    return 0;
  }

  // Navigate to the selected tab route
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/main/home');
        break;
      case 1:
        context.go('/main/list');
        break;
      case 2:
        context.go('/main/favourite');
        break;
      case 3:
        context.go('/main/inbox');
        break;
      case 4:
        context.go('/main/profile');
        break;
    }
  }
}
