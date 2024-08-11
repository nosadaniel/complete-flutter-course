import 'dart:ui';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant(
      {const Size(300, 600), const Size(600, 800), const Size(1000, 1000)});
  testWidgets('Golden - products list', (WidgetTester tester) async {

    final r = Robot(tester);
    //get the current size
    final currentSize = sizeVariant.currentValue!;
    //use it to set the surface size
    await r.goldenRobot.setSurfaceSize(currentSize);

    await r.goldenRobot.loadRobotoFont();
    await r.goldenRobot.loadMaterialIconFont();
    await r.pumpMyApp();
    await r.goldenRobot.precacheImages();
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile(
          //generate  different output goldens based on the width and height
          'products_list_${currentSize.width.toInt()}x${currentSize.height.toDouble()}.png'),
    );
  }, variant: sizeVariant, tags: ['golden']);
}
