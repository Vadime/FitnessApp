import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserHelpScreen extends StatelessWidget {
  const UserHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChatbotWidget();
  }
}

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({Key? key}) : super(key: key);

  @override
  ChatbotWidgetState createState() => ChatbotWidgetState();
}

class ChatbotWidgetState extends State<ChatbotWidget> {
  final TextFieldController messageController =
      TextFieldController('Schreibe eine Nachricht...');
  List<Message>? messages;

  late final OpenAI openAI;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    openAI = OpenAI.instance.build(
      token: const String.fromEnvironment('openai_token'),
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true,
    );
    initMessages();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void initMessages() async {
    messages = await MessageRepository.messagesAsFuture;
    setState(() {});
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
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
      return 'Es ist ein Fehler aufgetreten';
    }

    return response?.choices.first.text.trim() ??
        'Ich habe dich nicht verstanden';
  }

  void _sendMessage(String message) async {
    if (message.isEmpty) return;
    addMessage(Message(text: message, isUser: true));
    messageController.clear();
    String response = await genResponse(message);
    addMessage(Message(text: response, isUser: false));
  }

  addMessage(Message message) {
    messages ??= [];
    messages!.add(message);
    // scroll to bottom
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
    // do it in parallel for faster response
    MessageRepository.uploadMessage(message);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Hilfe Center',
      body: Stack(
        children: [
          if (messages == null)
            const Expanded(
              child: LoadingWidget(),
            )
          else if (messages!.isEmpty)
            const Expanded(
              child: InfoWidget('Das ist Bruno 👋\nDein Chatbot für Fitness'),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: context.config.padding,
                  right: context.config.padding,
                  // account for the appbar
                  top: context.topInset + 56 + 10,
                  // account for the textfield
                  bottom: context.config.padding +
                      context.mediaQuery.padding.bottom +
                      56 +
                      10,
                ),
                itemCount: messages!.length,
                itemBuilder: (context, index) {
                  // Überprüfen, ob es die erste Nachricht des Tages ist
                  bool isFirstMessageOfDay = index == 0 ||
                      messages![index].timestamp.day !=
                          messages![index - 1].timestamp.day;

                  // Überprüfen, ob es die erste Nachricht ist oder ob die vorherige Nachricht von einem anderen Benutzer stammt
                  bool shouldDisplayUser = index == 0 ||
                      messages![index].isUser != messages![index - 1].isUser;

                  // schreibe den Sender über die Nachricht, wenn die vorherige Nachricht nicht vom selben Sender war
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Datum anzeigen, wenn es die erste Nachricht des Tages ist
                      if (isFirstMessageOfDay)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            messages![index].timestamp.ddMMYYYY,
                            style: context.textTheme.labelLarge,
                          ),
                        ),
                      if (shouldDisplayUser || isFirstMessageOfDay)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Row(
                            children: [
                              TextWidget(
                                messages![index].isUser ? 'Du' : 'Bruno',
                                style: context.textTheme.labelLarge,
                                color: messages![index].isUser
                                    ? null
                                    : Colors.orange,
                              ),
                              const Expanded(child: SizedBox(width: 10)),
                              TextWidget(
                                messages![index].timestamp.hhmm,
                                style: context.textTheme.labelSmall,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ListTileWidget(
                        title: messages![index].text,
                      ),
                    ],
                  );
                },
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // blur Background
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                bottom:
                    context.config.padding + context.mediaQuery.padding.bottom,
              ),

              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFieldWidget(
                      controller: messageController,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _sendMessage(messageController.text),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
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
