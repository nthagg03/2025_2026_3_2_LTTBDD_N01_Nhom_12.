import 'package:flutter/material.dart';
import 'reaction_service.dart';

class ReactionsPage extends StatefulWidget {
  const ReactionsPage({super.key});

  @override
  State<ReactionsPage> createState() => _ReactionsPageState();
}

class _ReactionsPageState extends State<ReactionsPage> {
  final ReactionService _service = ReactionService();
  late Future<ReactionSummary> _futureSummary;

  @override
  void initState() {
    super.initState();
    _refreshSummary();
  }

  void _refreshSummary() {
    _futureSummary = _service.getReactionSummary('image_01', 'Bạn');
  }

  Future<void> _handleReaction(String emoji) async {
    await _service.addOrUpdateReaction('image_01', emoji, 'Bạn');
    if (!mounted) return;
    setState(() {
      _refreshSummary();
    });
  }

  Future<void> _removeMyReaction() async {
    await _service.removeReaction('image_01', 'Bạn');
    if (!mounted) return;
    setState(() {
      _refreshSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final emojis = ['😍', '🔥', '👏', '❤️', '😂'];

    return Scaffold(
      appBar: AppBar(title: const Text('Reactions')),
      body: FutureBuilder<ReactionSummary>(
        future: _futureSummary,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Photo reactions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: emojis.map((emoji) {
                            final isSelected =
                                summary.currentUserReaction == emoji;
                            return ChoiceChip(
                              label: Text(emoji),
                              selected: isSelected,
                              onSelected: (_) => _handleReaction(emoji),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Total: ${summary.totalCount}'),
                            const SizedBox(width: 12),
                            if (summary.currentUserReaction != null)
                              ElevatedButton.icon(
                                onPressed: _removeMyReaction,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Remove my reaction'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Reactions by users',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (summary.userNames.isEmpty)
                  const Text('No reactions yet')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: summary.userNames.map((name) {
                      final emoji = summary.emojiCounts.keys.firstWhere(
                        (entry) => summary.userNames.contains(name),
                        orElse: () => '',
                      );
                      return Chip(label: Text('$name: $emoji'));
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
