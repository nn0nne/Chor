import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Color(0xFFEEEEEE)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          "Search",
          style: TextStyle(
              color: Color(0xFFEEEEEE),
              fontSize: 30,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Color(0xFF070F2B),
      ),
      backgroundColor: Color(0xFF070F2B),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Got anything in mind?",
                  fillColor: Color(0xFFEEEEEE),
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xFF282828)),
                  prefixIcon: Icon(Icons.search)),
            ),
            const SizedBox(height: 10),
            Row(children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Color(0x801B1A55))),
                child: Text(
                  "Songs",
                  style: TextStyle(color: Color(0xFFEEEEEE)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Color(0x801B1A55))),
                child: Text(
                  "Playlists",
                  style: TextStyle(color: Color(0xFFEEEEEE)),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: songs.length,
            //     itemBuilder: (context, index) {
            //       final song = songs[index];
            //       return Card(
            //         color: Colors.indigo[800],
            //         child: ListTile(
            //           leading: Container(
            //             width: 40,
            //             height: 40,
            //             color: Colors.white,
            //             // Placeholder for image
            //           ),
            //           title: Text(
            //             song["title"] ?? "",
            //             style: const TextStyle(color: Colors.white),
            //           ),
            //           subtitle: Text(
            //             song["artist"] ?? "",
            //             style: const TextStyle(color: Colors.white70),
            //           ),
            //           onTap: () {
            //             // Add functionality for tapping on a song
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
