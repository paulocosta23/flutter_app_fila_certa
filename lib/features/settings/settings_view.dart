import 'package:flutter/material.dart';
import 'package:flutter_app_fila_certa/app/settings_scope.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late String _language;
  late double _textScale;
  late bool _darkMode;
  late bool _highContrast;

  @override
  void initState() {
    super.initState();
    final c = SettingsScope.read(context);
    _language = c.language;
    _textScale = c.textScale;
    _darkMode = c.darkMode;
    _highContrast = c.highContrast;
  }

  void _saveAndClose() {
    final c = SettingsScope.read(context);
    c.updateAll(
      language: _language,
      textScale: _textScale,
      darkMode: _darkMode,
      highContrast: _highContrast,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final languages = <String, String>{
      'pt_BR': 'Português (Brasil)',
      'en_US': 'English (US)',
      'es_ES': 'Español (España)',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        elevation: 1,
        actions: [
          IconButton(tooltip: 'Salvar', icon: const Icon(Icons.check), onPressed: _saveAndClose),
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: _textScale),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Idioma', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: languages.entries
                    .map((e) => RadioListTile<String>(
                          value: e.key,
                          groupValue: _language,
                          title: Text(e.value),
                          onChanged: (val) => setState(() => _language = val!),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Tamanho da fonte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Slider(
                      value: _textScale,
                      min: 0.9,
                      max: 1.4,
                      divisions: 5,
                      label: _textScale.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _textScale = v),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Pré-visualização', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Este é um exemplo de texto. Ajuste o controle deslizante para aumentar ou reduzir o tamanho.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Acessibilidade', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Modo escuro'),
                    subtitle: const Text('Reduz brilho da tela e usa cores escuras'),
                    value: _darkMode,
                    onChanged: (val) => setState(() => _darkMode = val),
                    secondary: const Icon(Icons.dark_mode),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Alto contraste'),
                    subtitle: const Text('Melhora a legibilidade com contrastes fortes'),
                    value: _highContrast,
                    onChanged: (val) => setState(() => _highContrast = val),
                    secondary: const Icon(Icons.contrast),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}