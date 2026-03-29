import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart';


const version = '0.0.1';
void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'wikipedia') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https('en.wikipedia.org', 
  '/w/api.php',
  {
    'action': 'query',
    'titles': articleTitle,
    'prop': 'extracts',
    'exintro': '1',
    'format': 'json',
    'explaintext': '1',
  }
);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
}
  return 'Error: Failed to fetch article $articleTitle. Status code: ${response.statusCode}';
}
void searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print("Please provide an article title to search for.");
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print("No article title provided. Exiting.");
      return;
    }
    articleTitle = inputFromStdin;
  }
  else {
    articleTitle = arguments.join(' ');
  }
  print("Searching for article: $articleTitle. Please wait...");
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);
}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
  );
}
