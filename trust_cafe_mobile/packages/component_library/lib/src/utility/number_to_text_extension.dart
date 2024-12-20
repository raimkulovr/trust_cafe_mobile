extension NumberToTextExtension on int {
  String get toText =>
    switch(this) {
      >=1000000 => '${this~/1000000}M+',
      >=1000 => '${this~/1000}K+',
      <1000 => toString(),
      _ => '0',
    };
}