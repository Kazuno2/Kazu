import 'package:flutter_test/flutter_test.dart';
import 'package:kazu/app/kazu_app.dart';

void main() {
  testWidgets('KazuApp launches into Onboarding and completes into MainShell', (WidgetTester tester) async {
    // Build KazuApp and trigger a frame.
    await tester.pumpWidget(const KazuApp());
    await tester.pump(const Duration(milliseconds: 500));

    // 1. Verify Onboarding welcome page appears first
    expect(find.text('KAZU'), findsOneWidget);
    expect(find.text('Meet Buddy & Kazu'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Skip All'), findsOneWidget);

    // 2. Test Skip All to enter main app directly (AC-01)
    await tester.tap(find.text('Skip All'));
    await tester.pumpAndSettle();

    // 3. Verify MainShell is displayed
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Plan'), findsOneWidget);
    expect(find.text('KTrack'), findsOneWidget);
    expect(find.text('Challenges'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    // 4. Tap on Plan tab and verify
    await tester.tap(find.text('Plan'));
    await tester.pump();
    expect(find.text('DAILY TIME BUDGET'), findsOneWidget);

    // 5. Tap on KTrack tab and verify T-Pillars are listed
    await tester.tap(find.text('KTrack'));
    await tester.pump();
    expect(find.text('KTrack Daily Tracker'), findsOneWidget);
    expect(find.text('Self-Trust'), findsOneWidget);

    // 6. Tap on More tab and verify Themes & Replay Onboarding option
    await tester.tap(find.text('More'));
    await tester.pump();
    expect(find.text('Themes, Profile & Settings'), findsOneWidget);
    expect(find.text('Replay Welcome & Registration'), findsOneWidget);
  });
}
