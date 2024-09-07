import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TextLanguageTraslation extends StatefulWidget {
  const TextLanguageTraslation({Key? key}) : super(key: key);

  @override
  State<TextLanguageTraslation> createState() => _TextLanguageTraslationState();
}

class _TextLanguageTraslationState extends State<TextLanguageTraslation> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController outputController =
      TextEditingController(text: 'Result here............');
  final translator = GoogleTranslator();

  String inputLanguageCode = 'en';
  String outputLanguageCode = 'fr';

  List<Language> languages = [
    Language(name: 'English', code: 'en'),
    Language(name: 'French', code: 'fr'),
    Language(name: 'Spanish', code: 'es'),
    Language(name: 'German', code: 'de'),
    Language(name: 'Italian', code: 'it'),
    Language(name: 'Portuguese', code: 'pt'),
    Language(name: 'Chinese', code: 'zh'),
    Language(name: 'Japanese', code: 'ja'),
    Language(name: 'Korean', code: 'ko'),
    Language(name: 'Arabic', code: 'ar'),
    Language(name: 'Russian', code: 'ru'),
    Language(name: 'Hindi', code: 'hi'),
    Language(name: 'Bengali', code: 'bn'),
    Language(name: 'Urdu', code: 'ur'),
    Language(name: 'Malayalam', code: 'ml'),
  ];

  Language? selectedInputLanguage;
  Language? selectedOutputLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/foreign-language-translate-feature.jpg',
                height: 200,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Language>(
                value: selectedInputLanguage,
                hint: Text('Select input language'),
                onChanged: (value) {
                  setState(() {
                    selectedInputLanguage = value;
                    inputLanguageCode = value!.code;
                  });
                },
                items: languages
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language.name),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 4,
                controller: inputController,
                decoration: InputDecoration(
                  labelText: 'Enter text to translate',
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Language>(
                value: selectedOutputLanguage,
                hint: Text('Select output language'),
                onChanged: (value) {
                  setState(() {
                    selectedOutputLanguage = value;
                    outputLanguageCode = value!.code;
                  });
                },
                items: languages
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language.name),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: translateText,
                child: Text(
                  'Translate',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 4,
                controller: outputController,
                enabled: false,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Translated text',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> translateText() async {
    // Ensure both input and output languages are selected
    if (selectedInputLanguage == null || selectedOutputLanguage == null) {
      setState(() {
        outputController.text =
            'Please select both input and output languages.';
      });
      return;
    }

    try {
      final translated = await translator.translate(
        inputController.text,
        from: inputLanguageCode,
        to: outputLanguageCode,
      );
      setState(() {
        outputController.text = translated.text;
      });
    } catch (e) {
      // Handle exception if the language is not supported
      setState(() {
        outputController.text = 'Translation failed: ${e.toString()}';
      });
    }
  }
}

class Language {
  final String name;
  final String code;

  Language({required this.name, required this.code});
}
