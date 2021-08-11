import 'package:file/local.dart';
import 'package:file_picker_test/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LiveTestWidgetsFlutterBinding();

  final tFile = const LocalFileSystem().file('assets/flutter_image1.jpg');

  const MethodChannel(
    'miguelruivo.flutter.plugins.filepicker',
    JSONMethodCodec(),
  ).setMockMethodCallHandler(
    (MethodCall methodCall) async {
      if (methodCall.method == 'custom') {
        final size = await tFile.length();
        final path = tFile.path;
        final map = {
          'path': path,
          'size': size,
          'bytes': null,
          'name': 'test',
        };
        return [
          map,
        ];
      }
    },
  );
  testWidgets('Basic test', (tester) async {
    await _createWidget(tester: tester);
    await expectLater(
      find.byType(ListView),
      findsOneWidget,
    );
  });

  testWidgets(
    'Upload file',
    (tester) async {
      await _createWidget(tester: tester);

      final button = find.text('Upload files');

      expect(button, findsOneWidget);

      await tester.tap(button);

      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Text &&
            widget.key == const Key('Text') &&
            widget.data == '1'),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Text &&
            widget.key == const Key('Text0') &&
            widget.data == 'flutter_image1.jpg'),
        findsOneWidget,
      );
    },
  );
}

Future<void> _createWidget({
  required WidgetTester tester,
}) async {
  await tester.pumpWidget(
    const MyApp(),
  );
  await tester.pump();
}
