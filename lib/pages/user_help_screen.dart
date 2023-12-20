import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
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

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({Key? key}) : super(key: key);

  @override
  ChatbotWidgetState createState() => ChatbotWidgetState();
}

class ChatbotWidgetState extends State<ChatbotWidget> {
  final TextFieldController messageController =
      TextFieldController('Type a message...');
  List<Message>? messages;

  late final OpenAI openAI;

  @override
  void initState() {
    openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true,
    );
    initMessages();

    super.initState();
  }

  void initMessages() async {
    messages = await MessageRepository.messagesAsFuture;
    setState(() {});
  }

  Future<String> genResponse(String text) async {
    final request = CompleteText(
      prompt: text,
      maxTokens: 100,
      model: TextDavinci3Model(),
    );

    CompleteResponse? response;
    try {
      response = await openAI.onCompletion(request: request);
    } catch (e, s) {
      Logging.logDetails('Error while generating response', e, s);
      return 'Frag mich nicht du Hurensohn';
    }
    return response?.choices.first.text ?? 'Ich habe dich nicht verstanden';
  }

  void _sendMessage(String message) async {
    messages ??= [];
    var finalMessage = Message(text: message, isUser: true);
    messages!.add(finalMessage);
    // do it in parallel for faster response
    MessageRepository.uploadMessage(finalMessage);
    setState(() {});

    messageController.clear();

    String response = await genResponse(message);
    var finalResponse = Message(text: response, isUser: false);
    messages!.add(finalResponse);
    // do it in parallel for faster response
    MessageRepository.uploadMessage(finalResponse);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (messages == null)
          const Expanded(
            child: LoadingWidget(),
          )
        else if (messages!.isEmpty)
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
              itemCount: messages!.length,
              itemBuilder: (context, index) {
                // schreibe den Sender über die Nachricht, wenn die vorherige Nachricht nicht vom selben Sender war
                if (index > 0 &&
                    messages![index].isUser != messages![index - 1].isUser) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(messages![index].isUser ? 'User:' : 'Hurensohn:'),
                      const SizedBox(height: 5),
                      ListTileWidget(
                        title: messages![index].text,
                      ),
                    ],
                  );
                } else {
                  return ListTileWidget(
                    title: messages![index].text,
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
                controller: messageController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage(messageController.text);
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
