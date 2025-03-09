import 'package:cimso_heckathon/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PaymentFinishedPage extends StatefulWidget {
  const PaymentFinishedPage({super.key});

  @override
  _PaymentFinishedPageState createState() => _PaymentFinishedPageState();
}

class _PaymentFinishedPageState extends State<PaymentFinishedPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  late AnimationController _slideUpController;
  late Animation<Offset> _slideUpAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeIn,
    );

    // Slide-up animation
    _slideUpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts off-screen below
      end: Offset.zero, // Ends at the default position
    ).animate(
      CurvedAnimation(
        parent: _slideUpController,
        curve: Curves.easeOut,
      ),
    );

    // Start animations
    _fadeInController.forward();
    _slideUpController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _slideUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Successful"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideUpAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your payment was successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  ),
                  child: const Text(
                    'Go to Home',
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
