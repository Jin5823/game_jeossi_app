import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/widgets/home_widgets.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ViewDetailScreen extends StatefulWidget {
  final CardModel pCard;

  const ViewDetailScreen ({
    Key key,
    @required this.pCard,
  }): super(key: key);

  @override
  _ViewDetailScreenState createState() => _ViewDetailScreenState();
}

class _ViewDetailScreenState extends State<ViewDetailScreen> {
  Row _buildGameDays() {
    List<Widget> gameDays = [];
    List<String> gameDayList = widget.pCard.gameDay.split('');
    List<String> daysList = ['월', '화', '수', '목', '금', '토', '일'];
    for (int i = 0; i < 7; i++) {
      if (gameDayList[i] == '0'){
        gameDays.add(
          Container(
            margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Palette.infoIcon,
            ),
            child: Text(
              daysList[i],
              style: TextStyle(
                color: Palette.customBlack,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }
    if (gameDays.length == 0){
      gameDays.add(
        Container(
          margin: const EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Palette.infoIcon,
          ),
          child: Text(
            '없음',
            style: TextStyle(
              color: Palette.customBlack,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gameDays);
  }
  Row _buildPlayerStreamers() {
    List<Widget> playerStreamers = [];
    if (widget.pCard.playerStreamer.length < 1) {
      playerStreamers.add(
        Container(
          margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Palette.infoIcon,
          ),
          child: Text(
            '없음',
            style: TextStyle(
              color: Palette.customBlack,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    else {
      widget.pCard.playerStreamer.forEach((streamer) {
        playerStreamers.add(
          Container(
            margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Palette.infoIcon,
            ),
            child: Text(
              streamer,
              style: TextStyle(
                color: Palette.customBlack,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      });
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: playerStreamers);
  }
  Row _buildPlayerCommunities() {
    List<Widget> playerCommunities = [];
    if (widget.pCard.playerCommunity.length < 1) {
      playerCommunities.add(
        Container(
          margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Palette.infoIcon,
          ),
          child: Text(
            '없음',
            style: TextStyle(
              color: Palette.customBlack,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    else {
      widget.pCard.playerCommunity.forEach((community) {
        playerCommunities.add(
          Container(
            margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Palette.infoIcon,
            ),
            child: Text(
              community,
              style: TextStyle(
                color: Palette.customBlack,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      });
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: playerCommunities);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.customBackground,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                color: Palette.customWhite,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30.0,
                              color: Palette.customBlack,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Container(
                              width: size.width * 0.8,
                              child: ListTile(
                                leading: Container(
                                  width: size.width * 0.1273,
                                  height: size.height * 0.0658,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Palette.backgroundBlack,
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                  ),
                                  child:InkWell(// 이미지 컨테이너
                                    onTap: () {
                                      NavigatorUtils.pushPageByFade(
                                          context: context,
                                          targPage: OtherUserScreen(
                                              userName: widget.pCard.ownerName,
                                              cardOwner: widget.pCard.owner),
                                          isReplace: false);
                                    },
                                    child: CircleAvatar(// 유저 이미지 아마 필요 없을 듯
                                      child: ClipOval(
                                        child: Image(
                                          height: size.height * 0.0658, // 상대 크기
                                          width: size.width * 0.1273,
                                          image: AssetImage('assets/images/avatar${widget.pCard.playStyle}.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                    widget.pCard.postTitle,
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                subtitle: Text(
                                  widget.pCard.playerGame,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            height: size.width * 0.92,
                            width: double.infinity,
                            margin: EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Palette.backgroundBlack,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: CachedNetworkImage(imageUrl: widget.pCard.cardImage[0], fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(height: size.height * 0.0118),
                        Container(
                          margin: const EdgeInsets.all(7.0),
                          child: Text(
                              widget.pCard.postContents,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Palette.customBlack,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.0131),
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Palette.customWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '게임 이름',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Palette.infoIcon,
                        ),
                        child: Text(
                          widget.pCard.playerGame,
                          style: TextStyle(
                            color: Palette.customBlack,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '플레이 성향',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Palette.infoIcon,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '즐겜',
                              style: TextStyle(
                                color: Palette.customBlack,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: size.width * 0.0076,),
                            StarDisplayWidget(
                              value: widget.pCard.playStyle+1,
                              filledStar: Icon(Icons.circle, color: Palette.rangeS, size: 16),
                              unfilledStar: Icon(Icons.circle, color: Palette.rangeE, size: 16),
                            ),
                            SizedBox(width: size.width * 0.0076,),
                            Text(
                              '빡겜',
                              style: TextStyle(
                                color: Palette.customBlack,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ),
                      if (widget.pCard.isNoob)
                        Container(
                          margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Palette.infoIcon,
                          ),
                          child: Text(
                            '뉴비',
                            style: TextStyle(
                              color: Palette.customBlack,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '플레이 가능한 요일',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildGameDays()),

                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '플레이 시간',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15.0, top:3, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Palette.infoIcon,
                        ),
                        child: Text(
                          '${widget.pCard.gameHoursS}:00 ~ ${widget.pCard.gameHoursE}:00',
                          style: TextStyle(
                            color: Palette.customBlack,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '즐겨보는 스트리머',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildPlayerStreamers()),
                  Container(
                    padding: EdgeInsets.only(left: 24, bottom: 2, top: 18),
                    child: Text(
                      '즐겨보는 커뮤니티',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildPlayerCommunities()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
