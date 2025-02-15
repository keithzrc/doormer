import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/entities/user_candidate_entity.dart';
import 'package:doormer/src/shared/user/entities/user_employer_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/core/services/sessions/session_service.dart';

class MockSessionService extends Mock implements SessionService {}

class FakeEmployer extends Fake implements Employer {}

class FakeCandidate extends Fake implements Candidate {}

void main() {
  late GlobalSessionBloc globalSessionBloc;
  late MockSessionService mockSessionService;

  setUpAll(() {
    registerFallbackValue(FakeEmployer());
    registerFallbackValue(FakeCandidate());
  });

  setUp(() {
    mockSessionService = MockSessionService();
    globalSessionBloc = GlobalSessionBloc(sessionService: mockSessionService);
  });

  tearDown(() {
    globalSessionBloc.close();
  });

  group('GlobalSessionBloc Tests', () {
    blocTest<GlobalSessionBloc, GlobalSessionState>(
      'emits [SessionExpiredState] when ExpireSession is added',
      build: () => globalSessionBloc,
      act: (bloc) => bloc.add(ExpireSession()),
      expect: () => [SessionExpiredState()],
    );

    blocTest<GlobalSessionBloc, GlobalSessionState>(
      'emits [SessionLoadingState, SessionActiveState] when RefreshSession is successful',
      build: () {
        when(() => mockSessionService.refreshToken()).thenAnswer((_) async {});
        return globalSessionBloc;
      },
      act: (bloc) => bloc.add(RefreshSession(FakeEmployer())),
      expect: () => [
        SessionLoadingState(),
        isA<SessionActiveState>(),
      ],
    );

    blocTest<GlobalSessionBloc, GlobalSessionState>(
      'emits [SessionLoadingState, SessionExpiredState] when RefreshSession fails',
      build: () {
        when(() => mockSessionService.refreshToken())
            .thenThrow(Exception('Error'));
        return globalSessionBloc;
      },
      act: (bloc) => bloc.add(RefreshSession(FakeCandidate())),
      expect: () => [
        SessionLoadingState(),
        SessionExpiredState(),
      ],
    );

    blocTest<GlobalSessionBloc, GlobalSessionState>(
      'emits [SessionActiveState] when SessionStarted is added',
      build: () => globalSessionBloc,
      act: (bloc) => bloc.add(SessionStarted(FakeEmployer())),
      expect: () => [isA<SessionActiveState>()],
    );

    blocTest<GlobalSessionBloc, GlobalSessionState>(
      'emits updated SessionActiveState when UserInfoUpdated is added with an active session',
      build: () => globalSessionBloc,
      seed: () => SessionActiveState(FakeCandidate()),
      act: (bloc) => bloc.add(UserInfoUpdated(FakeEmployer())),
      expect: () => [isA<SessionActiveState>()],
    );

    test('getUser returns user when session is active', () {
      final user = FakeEmployer();
      globalSessionBloc.emit(SessionActiveState(user));
      expect(globalSessionBloc.getUser(), equals(user));
    });

    test('getUser throws exception when session is not active', () {
      globalSessionBloc.emit(SessionExpiredState());
      expect(() => globalSessionBloc.getUser(), throwsException);
    });
  });
}
