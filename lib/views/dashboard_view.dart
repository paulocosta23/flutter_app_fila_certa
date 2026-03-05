import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Ajuste este import para o caminho real do seu projeto
import 'package:flutter_app_fila_certa/views/home_view.dart';

/// DASHBOARD COM BOTTOM NAVIGATION + CONTROLE DE TEXTO/IDIOMA/TEMA
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  // Preferências vindas da tela de Configurações
  double _textScale = 1.0;     // 0.9 ~ 1.4
  String _language = 'pt_BR';  // pt_BR, en_US, es_ES (visual por enquanto)
  bool _darkMode = false;
  bool _highContrast = false;

  // Abre a SettingsView e aplica as mudanças ao voltar
  Future<void> _openSettings() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsView(
          currentLanguage: _language,
          currentTextScale: _textScale,
          currentDarkMode: _darkMode,
          currentHighContrast: _highContrast,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _language = (result['language'] as String?) ?? _language;
        _textScale = (result['textScale'] as double?) ?? _textScale;
        _darkMode = (result['darkMode'] as bool?) ?? _darkMode;
        _highContrast = (result['highContrast'] as bool?) ?? _highContrast;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configurações atualizadas!')),
        );
      }
    }
  }

  ThemeData _buildTheme() {
    // Base conforme modo claro/escuro
    final base = _darkMode
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    if (_highContrast) {
      // Usa esquemas de alto contraste nativos do Material
      final cs = _darkMode
          ? const ColorScheme.highContrastDark()
          : const ColorScheme.highContrastLight();

      return base.copyWith(
        colorScheme: cs,
        scaffoldBackgroundColor: cs.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: 2,
        ),
        textTheme: base.textTheme.apply(
          bodyColor: cs.onSurface,
          displayColor: cs.onSurface,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            side: BorderSide(color: cs.onPrimary, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _darkMode ? cs.surface : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.onSurface, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.onSurface, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 3),
          ),
        ),
      );
    }

    // Tema normal (não alto contraste), mas respeitando claro/escuro
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0EA5E9),
      brightness: _darkMode ? Brightness.dark : Brightness.light,
    );

    return base.copyWith(
      colorScheme: cs,
      scaffoldBackgroundColor:
          _darkMode ? cs.surface : const Color(0xFFF5F7FA),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkMode ? cs.surface : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // As tabs recebem callbacks/valores, então não são const
    final pages = [
      HomeTab(onOpenSettings: _openSettings),
      PerfilTab(textScale: _textScale),
      NotificacaoTab(textScale: _textScale), // estilo A
      HistoricoTab(textScale: _textScale), // estilo A
    ];

    final media = MediaQuery.of(context);
    final theme = _buildTheme();

    return Theme(
      data: theme,
      child: Scaffold(
        body: MediaQuery(
          data: media.copyWith(textScaleFactor: _textScale),
          child: pages[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          currentIndex: _currentIndex,
          // Cores serão herdadas do Theme (colorScheme) — sem hardcode
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificação',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histórico',
            ),
          ],
        ),
      ),
    );
  }
}

/// TELA INÍCIO — ícone de configurações no canto esquerdo
class HomeTab extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const HomeTab({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Configurações',
          icon: const Icon(Icons.settings),
          onPressed: onOpenSettings,
        ),
        title: const Text("FILA CERTA"),
      ),
      body: Column(
        children: [
          // Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar...",
                prefixIcon: const Icon(Icons.search),
                // filled/cores já são controladas pelo Theme
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Bem-vindo ao Fila Certa 👋 ',
              style: TextStyle(fontSize: 22, color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

/// TELA DE PERFIL (Stateful) — sem “Idiomas”
class PerfilTab extends StatefulWidget {
  final double textScale;

  const PerfilTab({
    super.key,
    required this.textScale,
  });

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  File? _image;

  // Dados editáveis do usuário (exemplo inicial)
  String _name = "Paulo Henrique";
  String _email = "paulosilvacosta23@gmail.com";
  String _phone = "(91) 984970815";

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileView(
          name: _name,
          email: _email,
          phone: _phone,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
        _phone = result['phone'] ?? _phone;
      });
    }
  }

  void _logout() {
    // Volta para a HomeView ('/') e remove TODAS as rotas anteriores
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeView.routeName, // '/'
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: MediaQuery(
        data: media.copyWith(textScaleFactor: widget.textScale),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar + botão alterar foto
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: cs.surfaceContainerHighest, // Material 3 helper
                    backgroundImage:
                        _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: cs.outline,
                          )
                        : null,
                  ),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text("Alterar foto"),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Informações do usuário
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_name),
                  subtitle: const Text("Nome completo"),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(_email),
                  subtitle: const Text("Email"),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(_phone),
                  subtitle: const Text("Telefone"),
                ),
              ),

              const SizedBox(height: 20),

              // Botão Editar Perfil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _goToEditProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text("Editar Perfil"),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Botão Sair
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.surface,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Sair"),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// EDIT PROFILE VIEW (mesmo conteúdo, mas usando Theme)
class EditProfileView extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const EditProfileView({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop<Map<String, String>>(context, {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Salvar',
            onPressed: _save,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe seu email';
                  }
                  final ok =
                      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                  return ok ? null : 'Email inválido';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe seu telefone' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/// =====================
/// MODELOS (Notificações)
/// =====================
enum NotificationType { system, alert, queue, promo }

class NotificationItem {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dateTime;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });
}

/// =================
/// MODELOS (Histórico)
/// =================
enum HistoryStatus { done, canceled, info, queued }

class HistoryItem {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dateTime;
  final HistoryStatus status;

  HistoryItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dateTime,
    required this.status,
  });
}

/// =======================
/// MOCKS (dados de exemplo)
/// =======================
List<NotificationItem> sampleNotifications() {
  final now = DateTime.now();
  return [
    NotificationItem(
      id: 'n1',
      title: 'Sua vez está chegando!',
      subtitle: 'Fila: UPA • 4 pessoas à frente',
      dateTime: now.subtract(const Duration(minutes: 10)),
      type: NotificationType.queue,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Documento pendente',
      subtitle: 'Atualize seus dados no perfil.',
      dateTime: now.subtract(const Duration(hours: 3)),
      type: NotificationType.alert,
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Manutenção concluída',
      subtitle: 'Serviços normalizados.',
      dateTime: now.subtract(const Duration(days: 1, hours: 2)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Nova unidade adicionada',
      subtitle: 'Cartório Centro já disponível.',
      dateTime: now.subtract(const Duration(days: 2, hours: 5)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Desconto exclusivo',
      subtitle: 'Agende hoje e ganhe prioridade.',
      dateTime: now.subtract(const Duration(days: 6)),
      type: NotificationType.promo,
      isRead: true,
    ),
  ];
}

List<HistoryItem> sampleHistory() {
  final now = DateTime.now();
  return [
    HistoryItem(
      id: 'h1',
      title: 'Atendimento concluído',
      subtitle: 'UPA • Guichê 03',
      dateTime: now.subtract(const Duration(hours: 1)),
      status: HistoryStatus.done,
    ),
    HistoryItem(
      id: 'h2',
      title: 'Cancelou entrada na fila',
      subtitle: 'Unidade Saúde - Umarizal',
      dateTime: now.subtract(const Duration(days: 1, hours: 2)),
      status: HistoryStatus.canceled,
    ),
    HistoryItem(
      id: 'h3',
      title: 'Dados do perfil atualizados',
      subtitle: 'E-mail e telefone',
      dateTime: now.subtract(const Duration(days: 2, hours: 3)),
      status: HistoryStatus.info,
    ),
    HistoryItem(
      id: 'h4',
      title: 'Entrou na fila',
      subtitle: 'Cartório Belém • senha C-142',
      dateTime: now.subtract(const Duration(days: 3, hours: 5)),
      status: HistoryStatus.queued,
    ),
  ];
}

/// =======================
/// HELPERS (compartilhados)
/// =======================
String _groupLabel(DateTime now, DateTime dt) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(dt.year, dt.month, dt.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  if (diff < 7) return 'Nesta semana';
  return 'Anteriores';
}

String _formatHour(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

Map<String, List<T>> groupByDate<T>(
  List<T> items,
  DateTime Function(T) getDate,
) {
  final now = DateTime.now();
  final sorted = [...items]..sort((a, b) => getDate(b).compareTo(getDate(a)));
  final Map<String, List<T>> grouped = {};
  for (final item in sorted) {
    final label = _groupLabel(now, getDate(item));
    grouped.putIfAbsent(label, () => []).add(item);
  }
  return grouped;
}

IconData notificationIcon(NotificationType t) {
  switch (t) {
    case NotificationType.system:
      return Icons.settings;
    case NotificationType.alert:
      return Icons.warning_amber_rounded;
    case NotificationType.queue:
      return Icons.notifications_active;
    case NotificationType.promo:
      return Icons.card_giftcard;
  }
}

Color notificationColor(BuildContext ctx, NotificationType t) {
  final cs = Theme.of(ctx).colorScheme;
  switch (t) {
    case NotificationType.system:
      return cs.secondary;
    case NotificationType.alert:
      return cs.error;
    case NotificationType.queue:
      return cs.primary;
    case NotificationType.promo:
      return Colors.purpleAccent;
  }
}

IconData historyIcon(HistoryStatus s) {
  switch (s) {
    case HistoryStatus.done:
      return Icons.check_circle;
    case HistoryStatus.canceled:
      return Icons.cancel;
    case HistoryStatus.info:
      return Icons.info;
    case HistoryStatus.queued:
      return Icons.description;
  }
}

Color historyColor(BuildContext ctx, HistoryStatus s) {
  final cs = Theme.of(ctx).colorScheme;
  switch (s) {
    case HistoryStatus.done:
      return Colors.green;
    case HistoryStatus.canceled:
      return cs.error;
    case HistoryStatus.info:
      return cs.secondary;
    case HistoryStatus.queued:
      return cs.primary;
  }
}

/// =============================
/// WIDGET: Cabeçalho de seção
/// =============================
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: cs.primary,
      ),
    );
  }
}

/// =======================================
/// TELA: Notificações — Estilo (A) Corporativo
/// =======================================
class NotificacaoTab extends StatefulWidget {
  final double textScale;
  const NotificacaoTab({super.key, required this.textScale});

  @override
  State<NotificacaoTab> createState() => _NotificacaoTabState();
}

class _NotificacaoTabState extends State<NotificacaoTab> {
  late List<NotificationItem> _items;
  NotificationType? _filter; // filtro opcional

  @override
  void initState() {
    super.initState();
    _items = sampleNotifications();
  }

  void _markAllRead() {
    setState(() {
      for (final n in _items) {
        n.isRead = true;
      }
    });
  }

  void _clearAll() {
    setState(() => _items.clear());
  }

  String _labelType(NotificationType t) {
    switch (t) {
      case NotificationType.system:
        return 'Sistema';
      case NotificationType.alert:
        return 'Alertas';
      case NotificationType.queue:
        return 'Fila';
      case NotificationType.promo:
        return 'Promoções';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Respeita o textScale que vem das Configurações
    return MediaQuery(
      data: media.copyWith(textScaleFactor: widget.textScale),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notificações'),
          actions: [
            IconButton(
              tooltip: 'Marcar tudo como lido',
              onPressed: _items.isEmpty ? null : _markAllRead,
              icon: const Icon(Icons.done_all),
            ),
            IconButton(
              tooltip: 'Limpar todas',
              onPressed: _items.isEmpty ? null : _clearAll,
              icon: const Icon(Icons.delete_sweep),
            ),
          ],
        ),
        body: _buildCorporate(context),
      ),
    );
  }

  Widget _buildCorporate(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Filtro por tipo (discreto, corporativo)
    final filtered = _filter == null
        ? _items
        : _items.where((n) => n.type == _filter).toList();

    final grouped = groupByDate<NotificationItem>(filtered, (n) => n.dateTime);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Filtros simples
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              const SizedBox(width: 6),
              ...NotificationType.values.map((t) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(_labelType(t)),
                    selected: _filter == t,
                    onSelected: (_) => setState(() => _filter = t),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Grupos por data
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(text: entry.key),
              const SizedBox(height: 8),

              ...entry.value.map((n) {
                final subtleBg = !n.isRead
                    ? (cs.primary.withOpacity(0.06))
                    : Colors.transparent;

                return Container(
                  decoration: BoxDecoration(
                    color: subtleBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      notificationIcon(n.type),
                      color: notificationColor(context, n.type),
                    ),
                    title: Text(n.title),
                    subtitle: n.subtitle != null ? Text(n.subtitle!) : null,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatHour(n.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!n.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => setState(() => n.isRead = true),
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),
            ],
          );
        }).toList(),

        if (grouped.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: Text('Sem notificações')),
          ),
      ],
    );
  }
}

/// =======================================
/// TELA: Histórico — Estilo (A) Corporativo
/// =======================================
class HistoricoTab extends StatelessWidget {
  final double textScale;
  const HistoricoTab({super.key, required this.textScale});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final items = sampleHistory();
    final grouped = groupByDate<HistoryItem>(items, (h) => h.dateTime);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Scaffold(
        appBar: AppBar(title: const Text('Histórico')),
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            ...grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(text: entry.key),
                  const SizedBox(height: 8),
                  ...entry.value.map((h) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          historyIcon(h.status),
                          color: historyColor(context, h.status),
                        ),
                        title: Text(h.title),
                        subtitle: Text(
                          [
                            if (h.subtitle != null) h.subtitle!,
                            _formatHour(h.dateTime),
                          ].join('\n'),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

/// SETTINGS VIEW — Tela de Configurações
/// Idioma + Tamanho da Fonte + Modo Escuro + Alto Contraste
class SettingsView extends StatefulWidget {
  final String currentLanguage;
  final double currentTextScale;
  final bool currentDarkMode;
  final bool currentHighContrast;

  const SettingsView({
    super.key,
    required this.currentLanguage,
    required this.currentTextScale,
    required this.currentDarkMode,
    required this.currentHighContrast,
  });

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
    _language = widget.currentLanguage;
    _textScale = widget.currentTextScale;
    _darkMode = widget.currentDarkMode;
    _highContrast = widget.currentHighContrast;
  }

  void _saveAndClose() {
    Navigator.pop<Map<String, dynamic>>(context, {
      'language': _language,
      'textScale': _textScale,
      'darkMode': _darkMode,
      'highContrast': _highContrast,
    });
  }

  @override
  Widget build(BuildContext context) {
    final languages = <String, String>{
      'pt_BR': 'Português (Brasil)',
      'en_US': 'English (US)',
      'es_ES': 'Español (España)',
    };

    final media = MediaQuery.of(context);

    // Pré-visualização do textScale dentro da própria tela
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        elevation: 1,
        actions: [
          IconButton(
            tooltip: 'Salvar',
            icon: const Icon(Icons.check),
            onPressed: _saveAndClose,
          ),
        ],
      ),
      body: MediaQuery(
        data: media.copyWith(textScaleFactor: _textScale),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Idioma
            const Text(
              'Idioma',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: languages.entries.map((e) {
                  return RadioListTile<String>(
                    value: e.key,
                    groupValue: _language,
                    title: Text(e.value),
                    onChanged: (val) => setState(() => _language = val!),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Tamanho da fonte
            const Text(
              'Tamanho da fonte',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
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
                      divisions: 5, // 0.9, 1.0, 1.1, 1.2, 1.3, 1.4
                      label: _textScale.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _textScale = v),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pré-visualização',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Este é um exemplo de texto. Ajuste o controle deslizante para aumentar ou reduzir o tamanho.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Acessibilidade — Modo escuro & Alto contraste
            const Text(
              'Acessibilidade',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
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