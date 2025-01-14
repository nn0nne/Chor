// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:chor/services/firebase.dart';

// // Events
// abstract class AuthEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class SignInRequested extends AuthEvent {
//   final String email;
//   final String password;

//   SignInRequested(this.email, this.password);

//   @override
//   List<Object> get props => [email, password];
// }

// class SignUpRequested extends AuthEvent {
//   final String email;
//   final String password;

//   SignUpRequested(this.email, this.password);

//   @override
//   List<Object> get props => [email, password];
// }

// class SignOutRequested extends AuthEvent {}

// // States
// abstract class AuthState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {
//   final String uid;

//   Authenticated(this.uid);

//   @override
//   List<Object> get props => [uid];
// }

// class Unauthenticated extends AuthState {}

// class AuthError extends AuthState {
//   final String message;

//   AuthError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // BLoC
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final FirebaseService _firebaseService;

//   AuthBloc({required FirebaseService firebaseService})
//       : _firebaseService = firebaseService,
//         super(AuthInitial()) {
//     on<SignInRequested>(_handleSignIn);
//     on<SignUpRequested>(_handleSignUp);
//     on<SignOutRequested>(_handleSignOut);
//   }

//   Future<void> _handleSignIn(
//     SignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _firebaseService.signIn(
//         event.email,
//         event.password,
//       );
//       if (user != null) {
//         emit(Authenticated(user.uid));
//       } else {
//         emit(AuthError('Sign in failed'));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   Future<void> _handleSignUp(
//     SignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _firebaseService.signUp(
//         event.email,
//         event.password,
//       );
//       if (user != null) {
//         emit(Authenticated(user.uid));
//       } else {
//         emit(AuthError('Sign up failed'));
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }

//   Future<void> _handleSignOut(
//     SignOutRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _firebaseService.signOut();
//       emit(Unauthenticated());
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
// }
