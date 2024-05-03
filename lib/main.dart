import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordsScreen(),
    );
  }
}

class WordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
        backgroundColor: Color(0xFF92D954),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandomWordsScreen(showNouns: false),
                  ),
                );
              },
              child: const Text('Words'),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandomWordsScreen(showNouns: true),
                  ),
                );
              },
              child: const Text('Nouns'),
            ),
          ],
        ),
      ),
    );
  }
}

class RandomWordsScreen extends StatefulWidget {
  final bool showNouns;

  const RandomWordsScreen({Key? key, required this.showNouns}) : super(key: key);

  @override
  RandomWordsScreenState createState() => RandomWordsScreenState();
}

class RandomWordsScreenState extends State<RandomWordsScreen> {
  late final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showNouns ? 'Nouns' : 'Words'),
        backgroundColor: Color(0xFF92D954),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        widget.showNouns ? pair.second : pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(15));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }
}
