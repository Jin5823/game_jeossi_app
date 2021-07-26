import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/widgets/chat_widgets.dart';


class ChatScreen extends StatefulWidget {
  final MatchModel match;
  final int requestId;

  const ChatScreen({
    Key key,
    @required this.match,
    @required this.requestId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  Timer timer;
  String _senderUrl;
  String _receiverUrl;

  int _preLoadingTime = 0;

  List<ChatModel> _chatList = [];
  List<ChatModel> _senderChatList = [];
  List<ChatModel> _receiverChatList = [];

  FocusNode _messageFocusNode = FocusNode();
  TextEditingController _messageEditController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _senderUrl = ApiUrl.messagesUrl+'/${widget.requestId}/${widget.match.userId}';
    _receiverUrl = ApiUrl.messagesUrl+'/${widget.match.userId}/${widget.requestId}';
    loadingNetData();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      onRefresh();
    });
  }

  _sendMessageArea(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: size.height*0.0921,
      color: Palette.customWhite,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: _messageFocusNode,
              controller: _messageEditController,
              decoration: InputDecoration.collapsed(
                hintText: '쪽지 남기기...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () => sendMessage(widget.match.userId),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.scaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.dark,
        backgroundColor: Palette.secondPurple,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.match.userName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Palette.customWhite,
            onPressed: () {
              timer.cancel();
              Navigator.pop(context);
            }),
      ),
      body: GestureDetector(
        onTap: () {
          _messageFocusNode.unfocus();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                reverse: true,
                slivers: [
                  SliverPadding(
                      padding: EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          bool isSameUser = false;
                          final ChatModel chat = _chatList[index];
                          final bool isMe = chat.sender == widget.requestId;
                          if (index > 0)
                            isSameUser = _chatList[index-1].sender == chat.sender;

                          return ChatBubble(chat: chat, isMe: isMe, username: widget.match.userName, isSameUser: isSameUser);
                        },
                          childCount: _chatList.length,
                          // childCount: _listLength,
                        ),
                      ),
                  ),
                ],
              ),
            ),
            _sendMessageArea(size),
          ],
        ),
      ),
    );
  }

  void sendMessage (int userId) async{
    Map<String, dynamic> map = {
      "user_id": userId,
      "message": _messageEditController.text,
    };
    // 매핑

    ResponseInfo responseInfo = await DioUtils.instance.postRequest(
      url: ApiUrl.sendUrl,
      formDataMap: map,
    );

    if (responseInfo.success) {
      _messageEditController.text = '';
      onRefresh();
    }
    else {
      ToastUtils.showToast("전송 실패");
    }
  }

  void loadingNetData() async {
    ResponseInfo responseInfoSender = await DioUtils.instance.getRequest(
        url: _senderUrl);
    if (responseInfoSender.success) {
      List resList = responseInfoSender.data['results'];
      resList.forEach((element) {
        _senderChatList.add(ChatModel.fromMap(element));
      });
    } else {
      ToastUtils.showToast("요청실패");
    }

    ResponseInfo responseInfoReceiver = await DioUtils.instance.getRequest(
        url: _receiverUrl);
    if (responseInfoReceiver.success) {
      List resList = responseInfoReceiver.data['results'];
      resList.forEach((element) {
        _receiverChatList.add(ChatModel.fromMap(element));
      });
      _chatList = _receiverChatList + _senderChatList;
      _chatList.sort((b, a) => a.messageId.compareTo(b.messageId));
      if (mounted) {
        setState(() {});
      }

    } else {
      ToastUtils.showToast("요청실패");
    }
  }

  Future<bool> onRefresh() async {
    _preLoadingTime = DateTime.now().microsecond;

    _senderChatList = [];
    _receiverChatList = [];
    loadingNetData();
    int current = DateTime.now().microsecond;

    int flagTime = current - _preLoadingTime;

    if (flagTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - flagTime));
    }

    return true;
  }
}