import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';

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
    registerFallbackValue(const AsyncLoading<void>());
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

      const data = AsyncData<void>(null);

      final listener = MockListener<AsyncValue<void>>();

      container.listen(leaveReviewControllerProvider, listener.call,
          fireImmediately: true);

//verify initial in build method
      verify(() => listener(null, data));

      final controller = container.read(leaveReviewControllerProvider.notifier);
      //run
      await controller.submitReview(
          productId: productId,
          rating: review.rating,
          comment: review.comment,
          onSuccess: () {});

      //verify order
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(any(that: isA<AsyncLoading<void>>()), data),
      ]);
      verifyNoMoreInteractions(listener);
    });
    test('submitReview, failure', () async {
      final container = makeContainer();
      when(() =>
              reviewsService.submitReview(productId: productId, review: review))
          .thenThrow((_) => Exception('Connect issue'));
      const data = AsyncData<void>(null);
      final listener = MockListener<AsyncValue<void>>();
      container.listen(leaveReviewControllerProvider, listener.call,
          fireImmediately: true);
      //verify initial value in method build
      verify(() => listener(null, data));
      final controller = container.read(leaveReviewControllerProvider.notifier);
      //run
      await controller.submitReview(
          productId: productId,
          rating: review.rating,
          comment: review.comment,
          onSuccess: () {});
      //verify in order
      verifyInOrder([
        () => listener(
              data,
              any(that: isA<AsyncLoading<void>>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading<void>>()),
              any(that: isA<AsyncError>()),
            )
      ]);
      verifyNoMoreInteractions(listener);
    });
  });
}
