import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:modul2/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('portfolio content renders on a phone-sized screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('Alif Alfathar  ✓'), findsOneWidget);
    expect(find.text('Selected Works'), findsOneWidget);
    expect(find.text('Sonara Music'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('portfolio content fits a narrow phone-sized screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('Selected Works'), findsOneWidget);
    expect(find.text('Sonara Music'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('portfolio content renders on a desktop-sized screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('Capabilities & Craft Matrix'), findsOneWidget);
    expect(find.text('Writing & Reflections'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation scrolls and moves the selected indicator', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    Material navBackground(String label) {
      final button = find.byKey(ValueKey('nav-${label.toLowerCase()}'));
      return tester.widget<Material>(
        find.ancestor(of: button, matching: find.byType(Material)).first,
      );
    }

    expect(navBackground('Index').color, const Color(0xFF353437));
    final worksTitle = find.text('Selected Works');
    final initialTitleY = tester.getTopLeft(worksTitle).dy;

    await tester.tap(find.byKey(const ValueKey('nav-works')));
    await tester.pumpAndSettle();

    expect(navBackground('Works').color, const Color(0xFF353437));
    expect(navBackground('Index').color, Colors.transparent);
    expect(tester.getTopLeft(worksTitle).dy, lessThan(initialTitleY));
    expect(tester.takeException(), isNull);
  });
}
