import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';


class ChatBubble extends StatelessWidget {
  final ChatModel chat;
  final String username;
  final bool isMe;
  final bool isSameUser;

  const ChatBubble({
    Key key,
    @required this.chat,
    @required this.isMe,
    @required this.username,
    @required this.isSameUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.customGrey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  color: Palette.customWhite,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                chat.timestamp.toString().substring(5, 16),
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.backgroundBlack,
                ),
              ),
              SizedBox(
                width: size.width*0.0254,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.customGrey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/images/avatar0.jpg'),
                ),
              ),
            ],
          )
              : Container(
            child: null,
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Palette.customWhite,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Palette.customGrey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  color: Palette.customBlack,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.customGrey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    NavigatorUtils.pushPageByFade(
                        context: context,
                        targPage: OtherUserScreen(
                          userName: username,
                          cardOwner: chat.sender),
                        isReplace: false);
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/avatar${chat.sender % 10}.jpg'),
                  ),
                ),
              ),
              SizedBox(
                width: size.width*0.0254,
              ),
              Text(
                chat.timestamp.toString().substring(5, 16),
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.backgroundBlack,
                ),
              ),
            ],
          )
              : Container(
            child: null,
          ),
        ],
      );
    }
  }
}
