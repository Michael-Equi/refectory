import 'package:flutter/material.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:refectory/services/services.dart';

import 'package:refectory/services/services.dart';
import 'package:table_calendar/table_calendar.dart';

class MealChat extends StatefulWidget {
  MealChat({Key key}) : super(key: key);

  @override
  _MealChatState createState() => _MealChatState();
}

class _MealChatState extends State<MealChat> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final ChatUser user = ChatUser(
    name: "Fayeed",
    firstName: "Fayeed",
    lastName: "Pawaskar",
    uid: "12345678",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  var i = 0;

  @override
  void initState() {
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    var documentReference = Firestore.instance
        .collection('/cafeterias/194172c0-e3ca-11ea-8674-25c24d2d1b28/messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    await Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 2, left: 5, right: 5),
        child: StreamBuilder(
            stream: Firestore.instance
                .collection(
                    '/cafeterias/194172c0-e3ca-11ea-8674-25c24d2d1b28/messages')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                List<DocumentSnapshot> items = snapshot.data.documents;
                var messages =
                    items.map((i) => ChatMessage.fromJson(i.data)).toList();
                return DashChat(
                    key: _chatViewKey,
                    inverted: false,
                    onSend: onSend,
                    sendOnEnter: true,
                    textInputAction: TextInputAction.send,
                    user: user,
                    inputDecoration: InputDecoration.collapsed(
                        hintText: "Add messsage here..."),
                    dateFormat: DateFormat('yyyy-MMM-dd'),
                    timeFormat: DateFormat('HH:mm'),
                    messages: messages,
                    showUserAvatar: false,
                    showAvatarForEveryMessage: false,
                    scrollToBottom: false,
                    onPressAvatar: (ChatUser user) {
                      print("OnPressAvatar: ${user.name}");
                    },
                    onLongPressAvatar: (ChatUser user) {
                      print("OnLongPressAvatar: ${user.name}");
                    },
                    inputMaxLines: 5,
                    messageContainerPadding:
                        EdgeInsets.only(left: 5.0, right: 5.0),
                    alwaysShowSend: false,
                    inputTextStyle: TextStyle(fontSize: 16.0),
                    inputContainerStyle: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    onQuickReply: (Reply reply) {
                      setState(() {
                        messages.add(ChatMessage(
                            text: reply.value,
                            createdAt: DateTime.now(),
                            user: user));

                        messages = [...messages];
                      });

                      Timer(Duration(milliseconds: 300), () {
                        _chatViewKey.currentState.scrollController
                          ..animateTo(
                            _chatViewKey.currentState.scrollController.position
                                .maxScrollExtent,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );

                        if (i == 0) {
                          systemMessage();
                          Timer(Duration(milliseconds: 600), () {
                            systemMessage();
                          });
                        } else {
                          systemMessage();
                        }
                      });
                    },
                    onLoadEarlier: () {
                      print("laoding...");
                    },
                    shouldShowLoadEarlier: false,
                    showTraillingBeforeSend: true);
              }
            }),
      ),
    );
  }
}
