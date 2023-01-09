class Example{
  String taiwanese;
  String taiwanese_pronunciation;
  String chinese;

  Example({
    required this.taiwanese,
    required this.taiwanese_pronunciation,
    required this.chinese,
  });

  factory Example.fromJson(String str){
    str = str.replaceAll(RegExp(r'([\ufff9~`])'), '');
    return Example(
      taiwanese: str.split('\ufffa')[0],
      taiwanese_pronunciation:  str.split('\ufffa')[1].split('\ufffb')[0],
      chinese: str.split('\ufffa')[1].split('\ufffb')[1],
    );
  }
}


class Type{
  String type;
  String f;
  List<Example> e;

  Type({
    required this.type,
    required this.f,
    required this.e,
  });

  factory Type.fromJson(Map<String, dynamic> json){
    return Type(
      type: (json['type'] == null)
          ? 'no type'
          :json['type'].replaceAll(RegExp(r'([~`])'), '') as String,
      f: (json['f'] == null)
          ? 'no f'
          :json['f'].replaceAll(RegExp(r'([~`])'), '') as String,
      e: (json['e'] == null)
          ? []
          : List<Example>.from(
          json["e"].map((x) => Example.fromJson(x))),
    );
  }
}

class Pronunciation{
  String T;
  String audioID;
  List<Type> d;

  Pronunciation({
    required this.T,
    required this.d,
    required this.audioID,
  });

  factory Pronunciation.fromJson(Map<String, dynamic> json){
    return Pronunciation(
      T: (json['T'] == null)
        ? 'no pronounce'
        : json['T'].replaceAll(RegExp(r'([~`])'), '') as String,
      audioID: (json['T'] == null)
          ? '00000'
          : json['_'] as String,
      d: (json['d'] == null)
          ? []
          : List<Type>.from(
            json["d"].map((x) => Type.fromJson(x))),

    );
  }
}

class Word {
  String t;
  List<Pronunciation> h;

  Word({
    required this.t,
    required this.h,
  });

  factory Word.fromJson(Map<String, dynamic> json){
    return Word(
      t: (json['t'] == null)
          ? 'no t'
          :json['t'].replaceAll(RegExp(r'([~`])'), '') as String,
      h: (json['h'] == null)
          ? []
          :List<Pronunciation>.from(
            json["h"].map((x) => Pronunciation.fromJson(x))),
    );
  }

  factory Word.notExist(){
    return Word(
      t: 'notExist', h: [],
    );
  }
}