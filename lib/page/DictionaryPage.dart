import 'package:flutter/material.dart';
import '../word/word.dart';
import '../word/word_model.dart';


class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  TextEditingController controller = TextEditingController();

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
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: ListTile(
                                      title: Text(target.t),
                                      subtitle: Text(target.pronounce),
                                      trailing: IconButton(
                                          onPressed: () {
                                          },
                                          icon: const Icon(
                                              Icons.audiotrack)),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      title: Text(target.description),
                                      subtitle: Text(target.type),
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      title: Text('例句'),
                                      subtitle: Text(target.example),
                                    ),
                                  ),
                                ],
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
