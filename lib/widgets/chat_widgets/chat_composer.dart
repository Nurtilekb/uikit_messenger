import 'package:flutter/material.dart';
import 'package:uikit/widgets/app_text_field.dart';

class ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: AppInputWidget(
                  controller: controller,
                  radius: 25,
                  borderColor: Colors.white,
                  hintText: 'Сообщение',
                  filledColor: const Color.fromARGB(17, 0, 0, 0),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
