import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon? icon;
  const HistoryTile({super.key,required this.title,required this.subtitle,this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,),
      subtitle: Text(subtitle),
      leading: icon!,
    );
  }
}
