import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/profile/domain/entity/candidate_profile.dart';
import 'package:doormer/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:doormer/src/features/profile/presentation/widget/profile_dropdown_menu.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateProfilePage extends StatefulWidget {
  const CandidateProfilePage({super.key});

  @override
  CandidateProfilePageState createState() => CandidateProfilePageState();
}

class CandidateProfilePageState extends State<CandidateProfilePage> {
  // Holds the currently selected industries for the three choices.
  final List<String?> _selectedIndustries = [null, null, null];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) {
        final profileBloc = serviceLocator<ProfileBloc>();
        final userId = serviceLocator<GlobalSessionBloc>().getUser().id;
        profileBloc.add(FetchProfileWithOptions(userId: userId));
        return profileBloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Candidate Profile")),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is ProfileLoaded) {
              final profile = state.profile as CandidateProfile;
              final options = state.options;

              // Get the actual industry options from the JSON using the correct key.
              final List<String> industryOptions =
                  List<String>.from(options!["Industry"] ?? []);

              // Initialize the three choices from the profile if available.
              for (int i = 0; i < 3; i++) {
                if (_selectedIndustries[i] == null &&
                    profile.industries.length > i) {
                  final industry = profile.industries[i];
                  if (industryOptions.contains(industry)) {
                    _selectedIndustries[i] = industry;
                  } else {
                    _selectedIndustries[i] = null;
                    AppLogger.info(
                      "Profile's industry choice ${i + 1} '$industry' not in industryOptions.",
                    );
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileDropdownMenu(
                      label: "Industry (1st choice)",
                      options: industryOptions,
                      currentValue: _selectedIndustries[0],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedIndustries[0] = newValue;
                        });
                        AppLogger.info("Selected 1st Industry: $newValue");
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ProfileDropdownMenu(
                      label: "Industry (2nd choice)",
                      options: industryOptions,
                      currentValue: _selectedIndustries[1],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedIndustries[1] = newValue;
                        });
                        AppLogger.info("Selected 2nd Industry: $newValue");
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ProfileDropdownMenu(
                      label: "Industry (3rd choice)",
                      options: industryOptions,
                      currentValue: _selectedIndustries[2],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedIndustries[2] = newValue;
                        });
                        AppLogger.info("Selected 3rd Industry: $newValue");
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
