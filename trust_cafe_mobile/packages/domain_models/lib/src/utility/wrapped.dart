/// A utility class used to assist in copying nullable fields.
///
///```dart
/// class Person {
//   final String? name;
//
//   Person(this.name);
//
//   Person copyWith({Wrapped<String?>? name}) =>
//       Person(name != null ? name.value : this.name);
// }
//
// class Wrapped<T> {
//   final T value;
//   const Wrapped.value(this.value);
// }
//
// void main() {
//   final person = Person('John');
//   print(person.name); // Prints John
//
//   final person2 = person.copyWith();
//   print(person2.name); // Prints John
//
//   final person3 = person.copyWith(name: Wrapped.value('Cena'));
//   print(person3.name); // Prints Cena
//
//   final person4 = person.copyWith(name: Wrapped.value(null));
//   print(person4.name); // Prints null
// }
// ```
class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}