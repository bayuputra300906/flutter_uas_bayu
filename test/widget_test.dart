import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_uas_bayu/main.dart';

void main() {
  testWidgets('TravelBuddyApp smoke test and onboarding screen render',
      (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const TravelBuddyApp());
    await tester.pump();

    // Verify Onboarding Screen renders title and button
    expect(find.textContaining('Explore Bali'), findsOneWidget);
    expect(find.text('Explore Now'), findsOneWidget);
  });
}
