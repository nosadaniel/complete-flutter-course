import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testUser = AppUser(uid: 'abc', email: 'abx@test.com');
  final testProductId = kTestProducts[0].id;
  final testReview =
      Review(rating: 5.0, comment: '', date: DateTime(2022, 7, 31));
  late MockFakeAuthRepository authRepository;
  late MockFakeReviewRepository reviewRepository;
  late MockProductsRepository productsRepository;
  setUp(() {
    authRepository = MockFakeAuthRepository();
    reviewRepository = MockFakeReviewRepository();
    productsRepository = MockProductsRepository();
  });
  ReviewsService makeReviewsService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(reviewsServiceProvider);
  }

  group(('submit review'), () {
    test('null user, throws', () {
      //setup
      when(() => authRepository.currentUser).thenReturn(null);
      final reviewsService = makeReviewsService();
      //run
      expect(
          () => reviewsService.submitReview(
              productId: testProductId, review: testReview),
          throwsAssertionError);
    });

    test('non null user, sets review', () async {
      //setup
      when(() => authRepository.currentUser).thenAnswer((_) => testUser);
      when(() => reviewRepository.setReview(
          productId: testProductId,
          uid: testUser.uid,
          review: testReview)).thenAnswer(
        (_) => Future.value(),
      );
      when(() => reviewRepository.fetchReviews(testProductId)).thenAnswer(
        (_) => Future.value([]),
      );
      when(() => productsRepository.getProduct(productId: testProductId))
          .thenReturn(
        kTestProducts[0],
      );
      when(() => productsRepository.setProduct(kTestProducts[0]))
          .thenAnswer((_) => Future.value());
      //todo: why does this not work
      // when(() => productsRepository.updateProductRating(
      //     productId: testProductId,
      //     avgRating: testReview.rating,
      //     numRatings: 1)).thenAnswer(
      //   (_) => Future<void>.value(),
      // );

      final reviewsService = makeReviewsService();
      //run
      await reviewsService.submitReview(
          productId: testProductId, review: testReview);
      //verify
      verify(() => authRepository.currentUser).called(1);
      verify(() => reviewRepository.setReview(
          productId: testProductId,
          uid: testUser.uid,
          review: testReview)).called(1);
    });
  });
}
