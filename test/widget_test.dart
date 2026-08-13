// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:banca_app/features/auth/domain/entities/auth_session.dart';
import 'package:banca_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:banca_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:banca_app/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:banca_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.persistedSession});

  final AuthSession? persistedSession;

  @override
  Future<AuthSession?> getPersistedSession() async {
    return persistedSession;
  }

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    return AuthSession(
      uid: 'uid-1',
      userId: 1,
      username: username,
      email: username,
      accessToken: 'token',
      refreshToken: 'refresh-token',
    );
  }

  @override
  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String gender,
    required String password,
  }) async {
    return AuthSession(
      uid: 'uid-1',
      userId: 1,
      username: fullName,
      email: email,
      accessToken: 'token',
      refreshToken: 'refresh-token',
      firstName: fullName,
      gender: gender,
    );
  }

  @override
  Future<void> logout() async {}
}

void main() {
  test('restores the persisted session on startup', () async {
    const persistedSession = AuthSession(
      uid: 'uid-1',
      userId: 1,
      username: 'emilys',
      email: 'emily@dummyjson.com',
      accessToken: 'token',
      refreshToken: 'refresh-token',
      firstName: 'Emily',
    );
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _FakeAuthRepository(persistedSession: persistedSession),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(authNotifierProvider);
    await pumpEventQueue();

    final state = container.read(authNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.session, persistedSession);
  });

  testWidgets('opens login and navigates to dashboard tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DashboardView), findsNothing);
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'emilys@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'emilyspass');

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardView), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
