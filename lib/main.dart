import 'package:flutter/material.dart';
import 'features/chat/chat_page.dart';
import 'features/home_widget/home_widget_page.dart';
import 'features/notifications/notifications_page.dart';
import 'features/reactions/reactions_page.dart';

void main() {
  runApp(const LocketApp());
}

class LocketApp extends StatelessWidget {
  const LocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locket Demo',
      theme: ThemeData(useMaterial3: true),
      home: const ModuleShellPage(),
    );
  }
}

class ModuleShellPage extends StatelessWidget {
  const ModuleShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <_ModuleEntry>[
      _ModuleEntry(
        'Reactions',
        'Reaction demo',
        Icons.favorite,
        const ReactionsPage(),
      ),
      _ModuleEntry(
        'Chat',
        'Chat list and detail',
        Icons.chat_bubble,
        const ChatPage(),
      ),
      _ModuleEntry(
        'Notifications',
        'Unread state handling',
        Icons.notifications,
        const NotificationsPage(),
      ),
      _ModuleEntry(
        'Home Widget',
        'Widget preview',
        Icons.widgets,
        const HomeWidgetPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Module skeleton')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final module = modules[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(module.icon)),
              title: Text(module.title),
              subtitle: Text(module.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => module.page),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ModuleEntry {
  const _ModuleEntry(this.title, this.description, this.icon, this.page);

  final String title;
  final String description;
  final IconData icon;
  final Widget page;
}
