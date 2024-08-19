
import 'package:fight_app2/Controller/post_controller.dart';
import 'package:fight_app2/Model/post.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  final PostController _postController = PostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(//カレンダー
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });
              },
              onFormatChanged: (format) {  
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarFormat: _calendarFormat,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postController.getPostsForDay(_selectedDay ?? DateTime.now()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("まだ投稿はありません"));
                }

                final posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      child: ListTile(
                        subtitle: Column(
                          children: [
                            post.imageUrl != null
                                ? Image.network(post.imageUrl!)
                                : Container(),
                            Row(
                              children: [
                                Text('${post.date.toDate().year}/${post.date.toDate().month}/${post.date.toDate().day}'),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    await _postController.deletePost(post.id, post.imageUrl!);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}