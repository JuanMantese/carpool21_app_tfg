import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  
  final BuildContext context;
  String title;
  String? content;
  IconData icon;
  Function() onPressedSend;
  String textSendBtn;
  String textCancelBtn;

  CustomDialog({
    super.key,
    required this.context, 
    required this.title,
    this.content = '',
    required this.icon,
    required this.onPressedSend,
    required this.textSendBtn,
    required this.textCancelBtn,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.black54,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      
      content: Text(
        content!
      ),
      
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  context.pop();
                  onPressedSend();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A98F),
                  side: const BorderSide(color: Color(0xFF00A98F)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  textSendBtn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  context.pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00A98F)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Text(
                  textCancelBtn,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}