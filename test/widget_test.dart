import 'package:flutter_test/flutter_test.dart';

import 'package:company_profile/main.dart';

void main() {
  testWidgets('renders company profile content', (WidgetTester tester) async {
    await tester.pumpWidget(const CompanyProfileApp());
    await tester.pump();

    expect(find.text('oke'), findsWidgets);
    expect(
      find.text(
        'Kami hadir memberikan solusi profesional untuk kebutuhan bisnis Anda melalui strategi, teknologi, dan eksekusi yang terukur.',
      ),
      findsWidgets,
    );
    expect(find.text('Area kerja utama kami'), findsOneWidget);
    expect(find.text('Kontak'), findsOneWidget);
  });
}
