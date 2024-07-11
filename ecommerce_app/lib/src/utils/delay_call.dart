Future<void> delay(delay, {int milliseconds = 2000}) async {
  if (delay) {
    await Future.delayed(Duration(milliseconds: milliseconds));
  } else {
    Future.value();
  }
}
