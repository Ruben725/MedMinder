import 'package:flutter/material.dart';

class NewButton extends StatelessWidget{
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const NewButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 200,
      child: ElevatedButton(
      onPressed: onPressed, 
      child: Text(text, style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 1), ),),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                         )
                        )),
    );
  }
}