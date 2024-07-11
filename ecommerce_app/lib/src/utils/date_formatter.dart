import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dateformatterProvider = Provider<DateFormat>((ref) =>

    /// Date formatter to be used in the app.
    DateFormat.MMMEd());
