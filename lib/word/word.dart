class Word {
  String t;
  String pronounce;
  String type;
  String description;
  String example;

  Word({
    required this.t,
    required this.pronounce,
    required this.type,
    required this.description,
    required this.example,
  });

  factory Word.fromJson(Map<String, dynamic> json){
    Map<String, dynamic> h = json['h'][0];
    Map<String, dynamic> d = h['d'][0];
    return Word(
      t: json['t'] as String,
      pronounce: (h['T'] == null)
        ? 'no pronounce'
        : h['T'],
      type: (d['type'] == null)
          ? 'no type'
          : d['type'],
      description: (d['f'] == null)
          ? 'no description'
          : d['f'],
      example: (d['e'] == null)
          ? 'no example'
          : d['e'][0],
    );
  }

  factory Word.notExist(){
    return Word(
      t: 'notExist',
      pronounce: 'null',
      type: 'null',
      description: 'null',
      example: 'null',
    );
  }
}
