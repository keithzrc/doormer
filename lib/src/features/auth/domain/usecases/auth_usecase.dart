import 'package:doormer/src/features/auth/domain/repository/auth_repository.dart';
import 'package:doormer/src/shared/user/entities/user_entity.dart';
import 'package:doormer/src/shared/user/user_type.dart';

class AuthUseCase {
  final Signup signup;
  final Login login;
  final SignInWithGoogle signInWithGoogle;
  final VerifyEmail verifyEmail;

  AuthUseCase(AuthRepository authRepository)
      : signup = Signup(authRepository),
        login = Login(authRepository),
        signInWithGoogle = SignInWithGoogle(authRepository),
        verifyEmail = VerifyEmail(authRepository);
}

class Signup {
  final AuthRepository authRepository;

  Signup(this.authRepository);

  Future<User> call({
    required String email,
    required String password,
    required UserType userType,
  }) {
    return authRepository.signup(
      email: email,
      password: password,
      userType: userType,
    );
  }
}

class Login {
  final AuthRepository authRepository;

  Login(this.authRepository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    return authRepository.login(email: email, password: password);
  }
}

class SignInWithGoogle {
  final AuthRepository authRepository;

  SignInWithGoogle(this.authRepository);

  Future<User> call(String idToken) {
    return authRepository.signInWithGoogle(idToken);
  }
}

class VerifyEmail {
  final AuthRepository authRepository;

  VerifyEmail(this.authRepository);

  Future<void> call({
    required String email,
    required String code,
  }) {
    return authRepository.verifyEmail(email: email, code: code);
  }
}
