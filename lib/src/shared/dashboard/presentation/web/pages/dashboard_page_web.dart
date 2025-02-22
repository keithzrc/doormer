// dashboard_page_web.dart
import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/home/candidate/presentation/bloc/candidate_home_bloc.dart';
import 'package:doormer/src/features/home/candidate/presentation/pages/candidate_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Stub implementations for Blocs.
// In your actual project, define these in separate files with full implementations.
class HomeBloc extends Cubit<int> {
  HomeBloc() : super(0);
}

class ProfileBloc extends Cubit<int> {
  ProfileBloc() : super(0);
}

class MessageBloc extends Cubit<int> {
  MessageBloc() : super(0);
}

class SettingsBloc extends Cubit<int> {
  SettingsBloc() : super(0);
}

/// Enum to represent the different dashboard pages.
enum DashboardPage { home, profile, message, settings }

/// Main dashboard widget that adapts to screen size and provides Bloc integration.
class DashboardPageWeb extends StatefulWidget {
  const DashboardPageWeb({Key? key}) : super(key: key);

  @override
  _DashboardPageWebState createState() => _DashboardPageWebState();
}

class _DashboardPageWebState extends State<DashboardPageWeb> {
  // Track the currently selected page.
  DashboardPage _selectedPage = DashboardPage.home;

  /// Change the current page and update the UI.
  void _onSelectPage(DashboardPage page) {
    setState(() {
      _selectedPage = page;
    });
  }

  /// Returns the appropriate content widget based on the selected page.
  Widget _buildContent() {
    switch (_selectedPage) {
      case DashboardPage.home:
        // Replace the stub with the actual CandidateHomePage.
        return const CandidateHomePage();
      case DashboardPage.profile:
        return Center(child: Text('Profile Page'));
      case DashboardPage.message:
        return Center(child: Text('Message Page'));
      case DashboardPage.settings:
        return Center(child: Text('Settings Page'));
      default:
        return Center(child: Text('Home Page'));
    }
  }

  /// Builds the navigation menu list.
  Widget _buildNavigationMenu(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Navigation items.
        Expanded(
          child: ListView(
            children: [
              _buildNavItem(Icons.home, 'Home', DashboardPage.home, isMobile),
              _buildNavItem(
                  Icons.person, 'Profile', DashboardPage.profile, isMobile),
              _buildNavItem(
                  Icons.message, 'Message', DashboardPage.message, isMobile),
              _buildNavItem(
                  Icons.settings, 'Settings', DashboardPage.settings, isMobile),
            ],
          ),
        ),
        // Logout button at the bottom.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: () {
              // Handle logout logic here, such as clearing tokens or navigating to login.
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ),
      ],
    );
  }

  /// Builds each navigation item.
  Widget _buildNavItem(
      IconData icon, String title, DashboardPage page, bool isMobile) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedPage == page,
      onTap: () {
        _onSelectPage(page);
        // If on mobile, close the drawer after selecting a page.
        if (isMobile) Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the device is considered mobile based on screen width.
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return MultiBlocProvider(
      providers: [
        BlocProvider<CandidateHomeBloc>(
          create: (_) => serviceLocator<CandidateHomeBloc>(),
        ),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<MessageBloc>(create: (_) => MessageBloc()),
        BlocProvider<SettingsBloc>(create: (_) => SettingsBloc()),
      ],
      child: Scaffold(
        // For mobile, show an AppBar with a hamburger menu.
        appBar: isMobile
            ? AppBar(
                title: Text('Dashboard'),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              )
            : null,
        // Drawer for mobile navigation.
        drawer: isMobile ? Drawer(child: _buildNavigationMenu(isMobile)) : null,
        // Layout: For larger screens, show a left-side menu and content side-by-side.
        body: Row(
          children: [
            if (!isMobile)
              Container(
                width: 250,
                color: Colors.grey[200],
                child: _buildNavigationMenu(isMobile),
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
