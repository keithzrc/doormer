import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:doormer/src/features/home/candidate/presentation/bloc/candidate_home_bloc.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/entities/user_candidate_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateHomePage extends StatelessWidget {
  const CandidateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the CandidateHomeBloc from the parent context.
    final candidateHomeBloc = BlocProvider.of<CandidateHomeBloc>(context);

    // Retrieve the GlobalSessionBloc from the parent context.
    final globalSessionBloc = BlocProvider.of<GlobalSessionBloc>(context);

    // Get the current candidate user from the global session.
    final user = globalSessionBloc.getUser() as Candidate;
    final userId = user.id; // Assuming user.id is of type UuidValue.

    // Dispatch the event to load home data.
    candidateHomeBloc.add(LoadHomeData(userId: userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Home Page'),
      ),
      body: BlocBuilder<CandidateHomeBloc, CandidateHomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is HomeLoaded) {
            final CandidateHomeDataEntity data = state.homeData;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Candidate Profile Section
                  const Text(
                    'Candidate Profile:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${data.candidateProfile.fullName}'),
                  Text('Avatar URL: ${data.candidateProfile.profileAvatarUrl}'),
                  const Divider(height: 32),

                  // Profile Instructions Section
                  const Text(
                    'Profile Instructions:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...data.instructions.map((instruction) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Completed: ${instruction.completedFields}/${instruction.totalFields} - Next: ${instruction.nextFieldTip}',
                        ),
                      )),
                  const Divider(height: 32),

                  // Company Matches Section
                  const Text(
                    'Company Matches:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...data.companyMatches.map((match) => ListTile(
                        leading: Image.network(
                          match.companyLogoUrl,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(match.companyName),
                      )),
                  const Divider(height: 32),

                  // News Section
                  const Text(
                    'News:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...data.news.map((newsItem) => ListTile(
                        title: Text(newsItem.title),
                        subtitle: Text(newsItem.content),
                        trailing: Text(
                          newsItem.publishedAt.toLocal().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      )),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
