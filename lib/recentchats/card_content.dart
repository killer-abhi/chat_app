import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String name;
  final String date;

  const CardContent({
    super.key,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  textStyle: const TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.messenger),
                  label: Text('Chat'),
                ),
              ),
              const Spacer(),
              const Text(
                '2 days ago',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
