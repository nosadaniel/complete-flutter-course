import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'leave_review_controller.g.dart';

@riverpod
class LeaveReviewController extends _$LeaveReviewController {
  final initial = Object();
  late var current = initial;

  bool get mounted {
    return initial == current;
  }

  @override
  FutureOr<void> build() {
    //does nothing
    //return ;
  }
  Future<void> submitReview(
      {Review? previousReview,
      required ProductID productId,
      required double rating,
      required String comment,
      required void Function() onSuccess}) async {
    // * only submit if the rating is new or it has chanaged
    if (previousReview == null ||
        rating != previousReview.rating ||
        comment != previousReview.comment) {
      final review = Review(
        rating: rating,
        comment: comment,
        date: ref.read(currentDateProvider)(),
      );
      state = const AsyncLoading();
      final newState = await AsyncValue.guard(
        () => ref
            .read(reviewsServiceProvider)
            .submitReview(productId: productId, review: review),
      );
      if (mounted) {
        // * only set the state if the controller hasn't been disposed
        state = newState;
        if (state.hasError == false) {
          onSuccess();
        }
      }
    } else {
      onSuccess();
    }
  }
}
