import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_bloc.dart';
import 'package:magnumposts/features/authentication/ui/bloc/auth_state.dart';
import 'package:magnumposts/features/authentication/ui/pages/login_page.dart';

class MockAuthBloc extends MockBloc<dynamic, AuthState> implements AuthBloc {
  @override
  void add(AuthEvent event) {
    // TODO: implement add
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  void emit(AuthState state) {
    // TODO: implement emit
  }

  @override
  // TODO: implement isClosed
  bool get isClosed => throw UnimplementedError();

  @override
  void on<E extends AuthEvent>(EventHandler<E, AuthState> handler, {EventTransformer<E>? transformer}) {
    // TODO: implement on
  }

  @override
  void onChange(Change<AuthState> change) {
    // TODO: implement onChange
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
  }

  @override
  void onEvent(AuthEvent event) {
    // TODO: implement onEvent
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    // TODO: implement onTransition
  }

  @override
  // TODO: implement state
  AuthState get state => throw UnimplementedError();

  @override
  // TODO: implement stream
  Stream<AuthState> get stream => throw UnimplementedError();
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  testWidgets('LoginPage should display all required elements', (tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Assert
    expect(find.text('Magnum Posts'), findsOneWidget);
    expect(find.text('Entre com seu email e senha'), findsOneWidget);
    expect(find.byIcon(Icons.article_rounded), findsOneWidget);
    expect(find.text('Digite seu email'), findsOneWidget);
    expect(find.text('Digite sua senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Não tem uma conta?'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });

  testWidgets('LoginPage should show loading state', (tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(const AuthLoading());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoginPage should validate empty fields', (tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Try to submit without filling fields
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Email é obrigatório'), findsOneWidget);
    expect(find.text('Senha é obrigatória'), findsOneWidget);
  });

  testWidgets('LoginPage should toggle password visibility', (tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginPage(),
        ),
      ),
    );

    // Find password field
    final passwordField = find.byType(TextFormField).at(1);
    final visibilityButton = find.byIcon(Icons.visibility);

    // Initial state should hide password
    expect(tester.widget<TextFormField>(passwordField).obscureText, true);

    // Tap visibility button
    await tester.tap(visibilityButton);
    await tester.pumpAndSettle();

    // Password should now be visible
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });
}