class Type{
  String type;
  String f;
  List<String> e;

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
          : List<String>.from(json['e'].map((x) => x.replaceAll(RegExp(r'([~`])'), '') as String)),
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
    String tempID;
    if(json['='] == null){
      if(json['_'] == null){
        tempID = '00000';
      }else{
        tempID = json['_'];
      }
    }else{
      tempID = json['='];
    }
    return Pronunciation(
      T: (json['T'] == null)
        ? 'no pronounce'
        : json['T'].replaceAll(RegExp(r'([~`])'), '') as String,
      audioID: tempID,
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