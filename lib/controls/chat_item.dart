import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const ChatItem(
      {super.key,
      required this.message,
      required this.time,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: FractionallySizedBox(
                widthFactor: 0.75,
                child: Row(
                    mainAxisAlignment: isMe? MainAxisAlignment.end : MainAxisAlignment.start,
                    children:
                [
                  Flexible(
                      child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: isMe
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(message),
                              Text(time, style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.end,)
                            ],
                          )))
                ])))
      ],
    );
  }
}
