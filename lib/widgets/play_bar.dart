// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chor',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           children: [
//             LibraryPage(), // Main content of the page
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   PlayBar(
//                     coverImageUrl: 'https://via.placeholder.com/150',
//                     title: 'Distance',
//                     artist: 'k?d',
//                   ),
//                   BottomNavBar(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class PlayBar extends StatefulWidget {
  final String coverImageUrl;
  final String title;
  final String artist;

  const PlayBar({
    super.key,
    required this.coverImageUrl,
    required this.title,
    required this.artist,
  });

  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {
  bool isPlaying = false; // Tracks play/pause state
  bool isLiked = false; // Tracks like state

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 80,
      decoration: BoxDecoration(
        color: Color(0x801B1A55),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Album art
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/music_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Song details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.artist,
                    style: TextStyle(
                      color: Color(0xCCEEEEEE),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Control buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined,
                    color: Color(0xFFEEEEEE),
                    size: 30,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
                SizedBox(width: 16),
                // Play/Pause button
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Color(0xFFEEEEEE),
                    size: 40,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),

                // Close button
                // if (() {} != null)
                //   IconButton(
                //     icon: Icon(
                //       Icons.close,
                //       color: Colors.grey.shade600,
                //       size: 24,
                //     ),
                //     onPressed: () {},
                //     padding: EdgeInsets.zero,
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
