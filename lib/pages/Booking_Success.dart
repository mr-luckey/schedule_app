// import 'dart:async';
// import 'package:flutter/material.dart';

// class BookingSuccessScreen extends StatefulWidget {
//   final VoidCallback onFinish; // Callback after 5 seconds

//   const BookingSuccessScreen({super.key, required this.onFinish});

//   @override
//   State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
// }

// class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Auto navigate after 5 seconds
//     Timer(const Duration(seconds: 5), widget.onFinish);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Circle with confetti & thumbs up
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color(0xFFE8F9F1), // light green background
//                     ),
//                   ),
//                   const Icon(Icons.thumb_up, color: Colors.green, size: 60),
//                   Positioned(
//                     top: 8,
//                     child: Icon(
//                       Icons.auto_awesome,
//                       color: Colors.purple[300],
//                       size: 20,
//                     ),
//                   ),
//                   Positioned(
//                     right: 12,
//                     top: 20,
//                     child: const Icon(
//                       Icons.star,
//                       color: Colors.orange,
//                       size: 18,
//                     ),
//                   ),
//                   Positioned(
//                     left: 16,
//                     bottom: 20,
//                     child: const Icon(
//                       Icons.star,
//                       color: Colors.green,
//                       size: 16,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 8,
//                     right: 18,
//                     child: Icon(
//                       Icons.auto_awesome,
//                       color: Colors.pink[300],
//                       size: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // Title
//               const Text(
//                 "Booking Completed\nSuccessfully",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),

//               // Subtitle
//               const Text(
//                 "Your booking has been confirmed and payment\nrequest has been sent to the pet owner.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatefulWidget {
  final VoidCallback onFinish; // Callback after 5 seconds

  const BookingSuccessScreen({super.key, required this.onFinish});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  Timer? _autoCloseTimer; // Track the timer

  @override
  void initState() {
    super.initState();
    // Auto navigate after 5 seconds
    _autoCloseTimer = Timer(const Duration(seconds: 50), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle with confetti & thumbs up
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE8F9F1), // light green background
                    ),
                  ),
                  const Icon(Icons.thumb_up, color: Colors.green, size: 60),
                  Positioned(
                    top: 8,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.purple[300],
                      size: 20,
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 20,
                    child: const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 18,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 20,
                    child: const Icon(
                      Icons.star,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 18,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.pink[300],
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                "Booking Completed\nSuccessfully",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                "Your booking has been confirmed and payment\nrequest has been sent to the pet owner.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              // Manual close button
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _autoCloseTimer?.cancel(); // Cancel the auto-close timer
                  widget.onFinish();
                },
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
