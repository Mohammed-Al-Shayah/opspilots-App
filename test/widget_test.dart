import 'package:flutter_test/flutter_test.dart';
import 'package:opspilots/app/app.dart';

void main() {
  testWidgets('OpsPilot app starts with splash', (tester) async {
    await tester.pumpWidget(const OpsPilotApp());

    expect(find.text('OpsPilot'), findsOneWidget);
    expect(find.text('Smart Field Operations Management'), findsOneWidget);
  });
}
