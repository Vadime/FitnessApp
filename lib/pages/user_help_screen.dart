import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserHelpScreen extends StatelessWidget {
  const UserHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWidget(
      title: 'Hilfe Center',
      body: ChatbotWidget(),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  const Message({
    required this.text,
    required this.isUser,
  });
}

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({Key? key}) : super(key: key);

  @override
  ChatbotWidgetState createState() => ChatbotWidgetState();
}

class ChatbotWidgetState extends State<ChatbotWidget> {
  final TextFieldController _textEditingController =
      TextFieldController('Type a message...');
  List<Message>? _messages;

  @override
  void initState() {
    _messages = [
      const Message(text: 'Du Hurensohn', isUser: true),
      const Message(text: 'Antworte mal', isUser: true),
      const Message(text: 'Bitte nur fragen zu Fitness Themen', isUser: false),
      const Message(
        text: 'Wie berechnet ihr den Kaloriengebrauch',
        isUser: true,
      ),
      const Message(
        text:
            'Durch die Yarak-Formel.\n\n Kcal = Gewicht * Alter * Hässlichkeit',
        isUser: false,
      ),
      const Message(text: 'Ok danke', isUser: true),
      const Message(text: 'Kein Problem', isUser: false),
    ];

    super.initState();
  }

  void _sendMessage(String message) {
    setState(() {
      _messages ??= [];
      _messages!.add(Message(text: message, isUser: true));
    });
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_messages == null)
          const Expanded(
            child: LoadingWidget(),
          )
        else if (_messages!.isEmpty)
          const Expanded(
            child: InfoWidget('Das ist Hurensohn 👋\nDein Chatbot für Fitness'),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: context.config.padding,
                right: context.config.padding,
                top: context.config.padding + context.topInset,
                bottom: context.config.padding + context.bottomInset,
              ),
              itemCount: _messages!.length,
              itemBuilder: (context, index) {
                // schreibe den Sender über die Nachricht, wenn die vorherige Nachricht nicht vom selben Sender war
                if (index > 0 &&
                    _messages![index].isUser != _messages![index - 1].isUser) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(_messages![index].isUser ? 'User:' : 'Hurensohn:'),
                      const SizedBox(height: 5),
                      ListTileWidget(
                        title: _messages![index].text,
                      ),
                    ],
                  );
                } else {
                  return ListTileWidget(
                    title: _messages![index].text,
                  );
                }
              },
            ),
          ),
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: TextFieldWidget(
                controller: _textEditingController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage(_textEditingController.text);
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SafeArea(
          top: false,
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String text;
  const InfoWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(
        text,
        style: context.textTheme.bodyLarge,
        align: TextAlign.center,
      ),
    );
  }
}
