import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Network Error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Failed to connect to the server.'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
