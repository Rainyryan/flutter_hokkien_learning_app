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
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(target.t,
                                              style: const TextStyle(fontSize:22 ),),
                                            subtitle: Text(
                                                pronunciation.T,
                                            ),
                                            trailing: IconButton(
                                                onPressed: () async{
                                                  String ID = pronunciation.audioID;
                                                  while(ID.length < 5) {
                                                    ID = '0$ID';
                                                  }
                                                  String url = 'https://1763c5ee9859e0316ed6-db85b55a6a3fbe33f09b9245992383bd.ssl.cf1.rackcdn.com/$ID.ogg';
                                                  audioUrl = UrlSource(url);
                                                  await audioPlayer.play(audioUrl);
                                                },
                                                icon: const Icon(
                                                    Icons.audiotrack)),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 20),
                                            child:
                                            Column(
                                              children: List.generate(pronunciation.d.length,
                                                      (j) {
                                                    final type = pronunciation.d[j];
                                                    return Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(type.f),
                                                          subtitle: Text(
                                                              type.type),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
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
