import 'package:flutter/material.dart';
import '../word/word.dart';
import '../word/word_model.dart';
import 'package:audioplayers/audioplayers.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}


class _DictionaryPageState extends State<DictionaryPage> {
  TextEditingController controller = TextEditingController();
  final audioPlayer = AudioPlayer();
  late Source audioUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              label: Text('Search Query'),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ///FutureBuilder
                  controller.text.isEmpty
                      ? const SizedBox(child: Text('Search for something'))
                      : FutureBuilder(
                      future: WordModel.getWord(controller.text),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final target = snapshot.data as Word;
                          if(target.t == 'notExist'){
                            return const SizedBox(child: Text('no match'));
                          }else{
                            return Expanded(
                              child: ListView(
                                children: List.generate(target.h.length,
                                        (i) {
                                      final pronunciation = target.h[i];
                                      return Container(
                                        child:
                                        Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                target.t,
                                                textAlign: TextAlign.left,

                                                style: const TextStyle(fontSize:32 ),),
                                              subtitle: Text(
                                                pronunciation.T,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(fontSize:18 ),
                                              ),
                                              trailing: IconButton(
                                                  onPressed: () async{
                                                    String ID = pronunciation.audioID;
                                                    while(ID.length < 5) {
                                                      ID = '0$ID';
                                                    }
                                                    String url = 'https://1763c5ee9859e0316ed6-db85b55a6a3fbe33f09b9245992383bd.ssl.cf1.rackcdn.com/$ID.ogg';
                                                    print(url);
                                                    audioUrl = UrlSource(url);
                                                    await audioPlayer.play(audioUrl);
                                                  },
                                                  icon: const Icon(
                                                      Icons.audiotrack)),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(30,10,0,0),
                                              child:Column(
                                                  children: List.generate(pronunciation.d.length,
                                                          (j) {
                                                        final type = pronunciation.d[j];
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  type.type,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: Colors.white,
                                                                      background: Paint()
                                                                        ..strokeWidth = 16.0
                                                                        ..color = Colors.blueAccent
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeJoin = StrokeJoin.round
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10,15,0,0),
                                                                    child:
                                                                    Text(
                                                                      type.f,
                                                                      textAlign: TextAlign.left,
                                                                      style: const TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.black
                                                                      ),
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: List.generate(
                                                                  type.e.length, (k) {
                                                                final ex = type.e[k];
                                                                return Flexible(
                                                                  flex: 1,
                                                                  child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                      child:
                                                                      Container(
                                                                        width: 200,
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors
                                                                                .green,
                                                                            borderRadius:
                                                                            BorderRadius.all(
                                                                                Radius.circular(15))),
                                                                        child:
                                                                        Padding(
                                                                          padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                          child: Column(
                                                                            children: [
                                                                              ListTile(
                                                                                title: Text(
                                                                                  ex.taiwanese,
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  const TextStyle(
                                                                                    fontSize:
                                                                                    24,
                                                                                    color: Colors
                                                                                        .white,
                                                                                  ),
                                                                                ),
                                                                                subtitle: Text(
                                                                                  ex.t_sound,
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .left,
                                                                                  style:
                                                                                  const TextStyle(
                                                                                    fontSize:
                                                                                    14,
                                                                                    color: Colors
                                                                                        .black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              ex.chinese.isEmpty
                                                                                  ?const SizedBox(child: Text('',style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                1,
                                                                                color: Colors
                                                                                    .white,
                                                                              ),))
                                                                                  :Text(
                                                                                '中文翻譯:${ex.chinese}',
                                                                                textAlign:
                                                                                TextAlign
                                                                                    .left,
                                                                                style:
                                                                                const TextStyle(
                                                                                  fontSize:
                                                                                  12,
                                                                                  color: Colors
                                                                                      .white,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ),
                                                                      )),
                                                                );
                                                              }),
                                                            )
                                                          ],
                                                        );
                                                      }),
                                                ),
                                            ),

                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const SizedBox(child: Text('no match'));
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
