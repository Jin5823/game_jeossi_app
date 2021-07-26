import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';


class ChatContainer extends StatelessWidget {
  final MatchModel match;
  final int requestId;
  final VoidCallback detailDialog;

  const ChatContainer({
    Key key,
    @required this.match,
    @required this.requestId,
    @required this.detailDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => NavigatorUtils.pushPageByFade(
          context: context, targPage: ChatScreen(
        match: match, requestId: requestId,), isReplace: false),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
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
                        userName: match.userName,
                        cardOwner: match.userId,
                      ), isReplace: false);
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/avatar${match.userId % 10}.jpg'),
                ),
              ),
            ),
            Container(
              width: size.width * 0.60,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            match.userName,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.0131,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '쪽지 확인하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Palette.customBlack,
                        fontWeight: FontWeight.w100,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: InkResponse(
                onTap: detailDialog,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Palette.infoIcon,
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    size: 30.0,
                    color: Palette.customBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
