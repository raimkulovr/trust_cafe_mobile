import 'package:flutter/material.dart';

class EntityNotFound extends StatelessWidget {
  const EntityNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child:  Column(
          children: [
            Text('404', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Text('This page was probably assimilated by some pesky Borg and is no longer "here"'),
          ],
        ),
      ),
    );
  }
}
