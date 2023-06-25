abstract class DatabaseModel<T> {
  const DatabaseModel();

  static S create<S>() {
    throw UnimplementedError();
  }

  static S update<S>() {
    throw UnimplementedError();
  }

  static S delete<S>() {
    throw UnimplementedError();
  }

  static S fetch<S>() {
    throw UnimplementedError();
  }

  static S fromJson<S>(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
