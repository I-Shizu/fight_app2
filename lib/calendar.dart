
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
                setState(() {});
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

          StreamBuilder<QuerySnapshot>(
            stream: 
              FirebaseFirestore.instance.collection('posts').snapshots(), 
            builder: (context, snapshot){
              if(snapshot.hasData){
                final List<QueryDocumentSnapshot> documents =
                  snapshot.data!.docs;

                final List<QueryDocumentSnapshot> filterdDocuments =
                  documents.where((doc) {
                    final date = (doc['date'] as Timestamp).toDate();
                    return isSameDay(_selectedDay, date);
                  }).toList();

                filterdDocuments
                  .sort((a, b) => a['date'].compareTo(b['date']));

                return Expanded(
                  child: ListView.builder(
                    itemCount: filterdDocuments.length,
                    itemBuilder: (context, index) {
                      final document = filterdDocuments[index];
                      final date = (document['date'] as Timestamp).toDate();
                      return Card(
                        child: ListTile(
                          trailing: IconButton(
                                onPressed: () async {
                                  final imageUrl = document['imageUrl'];
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(document.id)
                                      .delete();
                                  await deleteImage(imageUrl);
                                  setState(() {
                                    filterdDocuments.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              subtitle:
                                  Column(
                                    children: [
                                      document['imageUrl'] != null ? Image.network(document['imageUrl']) : Container(),
                                      Text(document['text']),
                                      Text('${date.year}/${date.month}/${date.day}'),
                                    ],
                                  ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator(),);
            }
          ),
        ],
      ),
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      //documentのプロパティ(imageUrl)のURLからファイルを抽出する⇨RegExpやUriを用いる
      final RegExp regex = RegExp(r'\/o\/(.*)\?alt');
      final match  = regex.firstMatch(imageUrl);
      if (match != null) {
        final imageName = match.group(1);
        if(imageName != null){
          await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        }
      }
    } catch (e) {
      return null;
    }
  }
}