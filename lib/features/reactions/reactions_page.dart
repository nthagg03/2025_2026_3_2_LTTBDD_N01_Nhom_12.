import 'package:flutter/material.dart';
import 'reaction_service.dart';

class ReactionsPage extends StatefulWidget {
  const ReactionsPage({super.key});

  @override
  State<ReactionsPage> createState() => _ReactionsPageState();
}

class _ReactionsPageState extends State<ReactionsPage> {
  final ReactionService _service = ReactionService();
  late Stream<ReactionSummary> _summaryStream;
  final String _imageId = 'image_01';
  final String _currentUserName = 'Bạn';

  @override
  void initState() {
    super.initState();
    _summaryStream = _service.watchImageSummary(_imageId, _currentUserName);
  }

  Future<void> _handleReaction(String emoji) async {
    await _service.addOrUpdateReaction(_imageId, emoji, _currentUserName);
  }

  Future<void> _removeMyReaction() async {
    await _service.removeReaction(_imageId, _currentUserName);
  }

  @override
  Widget build(BuildContext context) {
    final emojis = ['😍', '🔥', '👏', '❤️', '😂'];

    return Scaffold(
      appBar: AppBar(title: const Text('Reactions')),
      body: StreamBuilder<ReactionSummary>(
        stream: _summaryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = snapshot.data!;
          final counts = summary.emojiCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

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
                          runSpacing: 8,
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
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.favorite, size: 18),
                              label: Text('Total: ${summary.totalCount}'),
                            ),
                            if (summary.currentUserReaction != null)
                              Chip(
                                avatar: const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                ),
                                label: Text(
                                  'You: ${summary.currentUserReaction}',
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (summary.currentUserReaction != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: _removeMyReaction,
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Remove my reaction'),
                            ),
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
                if (summary.userEntries.isEmpty)
                  const Text('No reactions yet')
                else
                  Column(
                    children: counts.map((entry) {
                      final usersForEmoji = summary.userEntries
                          .where((item) => item.emoji == entry.key)
                          .toList();
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${entry.value} reactions'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: usersForEmoji.map((item) {
                                  return Chip(
                                    avatar: CircleAvatar(
                                      child: Text(item.userName[0]),
                                    ),
                                    label: Text(item.userName),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
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
