import 'dart:async';
import 'package:flutter/material.dart';

class PendingVerificationPageWeb extends StatefulWidget {
  const PendingVerificationPageWeb({super.key});

  @override
  _PendingVerificationPageWebState createState() =>
      _PendingVerificationPageWebState();
}

class _PendingVerificationPageWebState
    extends State<PendingVerificationPageWeb> {
  Timer? _timer;
  // final SessionService _sessionService = serviceLocator<SessionService>();

  @override
  void initState() {
    super.initState();
    _checkAccountStatus(); // Check status when page loads
    _startPolling(); // Start periodic status checks
  }

  // Fetch user's latest account status from API
  Future<void> _checkAccountStatus() async {
    // try {
    //   final updatedUser =
    //       await _sessionService.getCurrentUser(); // Fetch latest user data

    //   if (!mounted) return;

    //   final globalSessionBloc = context.read<GlobalSessionBloc>();
    //   globalSessionBloc
    //       .add(SessionStarted(updatedUser)); // Update session state

    //   if (updatedUser.accountStatus == AccountStatus.active) {
    //     // Redirect to home if verified
    //     GoRouter.of(context).go('/main/home');
    //   } else if (updatedUser.accountStatus == AccountStatus.inactive) {
    //     // Redirect to activation page if still inactive
    //     GoRouter.of(context).go('/auth/activation');
    //   }
    // } catch (e) {
    //   print('Error checking account status: $e');
    // }
  }

  // Start a periodic check every 2 minutes
  void _startPolling() {
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _checkAccountStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop polling when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your account is under review.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Our team is verifying your account details. You will be notified once the process is complete.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAccountStatus, // Manually trigger a status check
              child: const Text("Check Status"),
            ),
          ],
        ),
      ),
    );
  }
}
