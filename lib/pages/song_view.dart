import 'package:flutter/material.dart';

class SongView extends StatelessWidget {
  const SongView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F2B), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF070F2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Album Art Placeholder
            SizedBox(height: 30),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(height: 30),
            // Song Title and Artist
            Column(
              children: const [
                Text(
                  "Distance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "k?d",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Progress Bar
            Column(
              children: [
                Slider(
                  value: 0.1, // Example value
                  onChanged: (value) {},
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "00:00",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        "03:20",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Player Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {},
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color(0xFF1B1A55),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 30),
            // Player Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle, color: Colors.white),
                  onPressed: () {},
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.repeat, color: Colors.white),
                  onPressed: () {},
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
