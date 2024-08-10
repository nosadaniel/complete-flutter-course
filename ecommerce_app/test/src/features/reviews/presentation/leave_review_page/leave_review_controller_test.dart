import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_page/leave_review_controller.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const productId = '1';
  final dateTime = DateTime(2024, 8, 10);
  final review = Review(rating: 5.0, comment: '', date: dateTime);
  late MockReviewsService reviewsService;

  setUp(() {
    reviewsService = MockReviewsService();
  });
  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        reviewsServiceProvider.overrideWithValue(reviewsService),
        currentDateProvider.overrideWithValue(() => dateTime),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Leave review controller', () {
    test('submitReview, success', () async {
      final container = makeContainer();
      when(() =>
              reviewsService.submitReview(productId: productId, review: review))
          .thenAnswer((_) => Future.value());
      final controller = container.read(leaveReviewControllerProvider.notifier);
      //run && verify
      expectLater(
        controller.stream,
        emitsInOrder([const AsyncLoading<void>(), const AsyncData<void>(null)]),
      );
      await controller.submitReview(
          productId: productId,
          rating: review.rating,
          comment: review.comment,
          onSuccess: () {});
    });
    test('submitReview, failure', () async {
      final container = makeContainer();
      when(() =>
              reviewsService.submitReview(productId: productId, review: review))
          .thenThrow((_) => Exception('Connect issue'));
      final controller = container.read(leaveReviewControllerProvider.notifier);
      //run && verify
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          })
        ]),
      );
      await controller.submitReview(
          productId: productId,
          rating: review.rating,
          comment: review.comment,
          onSuccess: () {});
    });
  });
}
