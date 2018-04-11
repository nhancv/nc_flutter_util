import 'dart:async';

class April {
  //  Public by default, private by prefixing “_”
  int publicInt = 2;
  int _privateInt = 2;

  //  Collection literals
  void collectionLiterals() {
    print([1, 2, 3, 4]);
    print({1: 'one', 2: 'two', 3: 'three'});
  }

  //  Everything’s an object — no “primitives”
  //  Optional parameters, defaults;
  void nameParameters(String requiredArgument,
      [String optionalArgument = "default"]) {
    print('$requiredArgument $optionalArgument');
  }

  //  Named parameters
  void nameMoreParameters(String requiredArgument, {String namedArgument}) {
    print('$requiredArgument $namedArgument');
  }

  //  Properties — no need to write “get” methods everywhere
  get publicIntx2 => publicInt * 2;

  set publicIntx2(value) => publicInt = value / 2;

  //  Type inference with strong mode — just write “var” for locals
  //  https://www.dartlang.org/guides/language/sound-dart

  //  Named constructors, auto assignment to fields; try them
  final int x;

  April(this.x);

  April.origin() : x = 0;

  //  Cascades — everything’s a builder
  void createApril() {
    new April.origin()
      ..collectionLiterals()
      ..publicInt = 3;
  }

  //  dartfmt — worries about formatting so you don’t have to
  //  String interpolation, several types of string literal; try them
  void printString() {
    var message = 'hello';

    print('Message: $message');

    print('''
Multiline
message:
$message
''');

    print('Message length: ${message.length}');

    print(r'\s\t\r\i\n\g\ \w\i\t\h\o\u\t \e\s\c\a\p\e \c\o\d\e\s');

    print("Message: $message");

    print("""
Multiline
message:
$message
""");

    print("Message length: ${message.length}");

    print(r"\s\t\r\i\n\g\ \w\i\t\h\o\u\t \e\s\c\a\p\e \c\o\d\e\s");

    /** Output:
     *
        Message: hello
        Multiline
        message:
        hello

        Message length: 5
        \s\t\r\i\n\g\ \w\i\t\h\o\u\t \e\s\c\a\p\e \c\o\d\e\s
        Message: hello
        Multiline
        message:
        hello

        Message length: 5
        \s\t\r\i\n\g\ \w\i\t\h\o\u\t \e\s\c\a\p\e \c\o\d\e\s
     */
  }

  // Iterable
  void iterable() {
    [1, 2, 3].map((i) => i * 2).where((i) => i % 2 == 0).forEach((i) {
      print(i);
    });
  }

  // Callbacks, Futures and async/await
  Future<List<int>> getOdd() {
    return _getThenFilter((i) => i % 2 == 0).then((value) {
      value.forEach((i) {
        print(i);
      });
    });
  }

  Future<List<int>> _getThenFilter(bool cond(int element)) async {
    var unfiltered = await makeRequest();
    return unfiltered.where(cond).toList();
  }

  Future<List<int>> makeRequest() async {
    return [1, 2, 3];
  }
}
