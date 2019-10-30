/// A state update
class StateUpdate<T> {
  /// Default constructor
  StateUpdate(this.key, this.value, this.type);

  /// A detailled description of the state update
  String get description => "$type\n$key : $value";

  /// The key
  final String key;

  /// The updated value
  final dynamic value;

  /// The type of the update
  final T type;

  @override
  String toString() {
    return "$type";
  }
}
