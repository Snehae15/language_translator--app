import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController outputController =
      TextEditingController(text: 'Result here...');
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();
  bool isTranslating = false;

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
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language Translator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageHeader(),
                const SizedBox(height: 20),
                _buildLanguageDropdown(
                  label: 'Select input language',
                  value: selectedInputLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedInputLanguage = value;
                      inputLanguageCode = value!.code;
                      speak(value.name);
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextInputField(),
                const SizedBox(height: 20),
                _buildLanguageDropdown(
                  label: 'Select output language',
                  value: selectedOutputLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedOutputLanguage = value;
                      outputLanguageCode = value!.code;
                      speak(value.name);
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTranslateButton(),
                const SizedBox(height: 20),
                _buildResultField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/foreign-language-translate-feature.jpg',
        height: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required String label,
    required Language? value,
    required ValueChanged<Language?> onChanged,
  }) {
    return DropdownButtonFormField<Language>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      value: value,
      onChanged: onChanged,
      items: languages.map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language.name),
        );
      }).toList(),
    );
  }

  Widget _buildTextInputField() {
    return TextField(
      controller: inputController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Enter text to translate',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildTranslateButton() {
    return isTranslating
        ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: translateText,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Translate',
              style: TextStyle(fontSize: 18),
            ),
          );
  }

  Widget _buildResultField() {
    return TextField(
      controller: outputController,
      maxLines: 4,
      enabled: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Translated text',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Future<void> translateText() async {
    if (inputController.text.isEmpty) {
      setState(() {
        outputController.text = 'Please enter text to translate.';
      });
      return;
    }

    setState(() {
      isTranslating = true;
    });

    final translated = await translator.translate(
      inputController.text,
      from: inputLanguageCode,
      to: outputLanguageCode,
    );
    setState(() {
      outputController.text = translated.text;
      isTranslating = false;
    });
    speak(translated.text);
  }

  Future<void> speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }
}

class Language {
  final String name;
  final String code;

  Language({required this.name, required this.code});
}
