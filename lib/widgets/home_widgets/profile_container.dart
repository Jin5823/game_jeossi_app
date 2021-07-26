import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileContainer extends StatelessWidget {
  final CardModel pCard;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  Row _buildGameDays() {
    List<Widget> gameDays = [];
    List<String> gameDayList = pCard.gameDay.split('');
    List<String> daysList = ['월', '화', '수', '목', '금', '토', '일'];
    for (int i = 0; i < 7; i++) {
      if (gameDayList[i] == '0'){
        gameDays.add(
          Container(
            margin: const EdgeInsets.all(5.0),
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
    if (pCard.playerStreamer.length < 1) {
      playerStreamers.add(
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
    else {
      pCard.playerStreamer.forEach((streamer) {
        playerStreamers.add(
          Container(
            margin: const EdgeInsets.all(5.0),
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
    if (pCard.playerCommunity.length < 1) {
      playerCommunities.add(
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
    else {
      pCard.playerCommunity.forEach((community) {
        playerCommunities.add(
          Container(
            margin: const EdgeInsets.all(5.0),
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


  const ProfileContainer({
    Key key,
    @required this.pCard,
    @required this.onLike,
    @required this.onDislike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.customWhite,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Container(// 유저 이미지 컨테이너
                      width: size.width*0.1273, // 상대 크기 수정
                      height: size.height*0.0658,
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
                                context: context, targPage: OtherUserScreen(
                              cardOwner: pCard.owner,
                              userName: pCard.ownerName,
                            ), isReplace: false);
                            },
                        child: CircleAvatar(// 유저 이미지 아마 필요 없을 듯
                          child: ClipOval(
                            child: Image(
                              height: size.height*0.0658, // 상대 크기
                              width: size.width*0.1273,
                              image: AssetImage('assets/images/avatar${pCard.playStyle}.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: GestureDetector(
                        child: Text(
                            pCard.postTitle,
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                            )
                        )
                    ),
                    subtitle: Text(pCard.playerGame,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                    ),

                    ),
                  ),

                  InkWell(// 이미지 컨테이너
                    onTap: () {
                      NavigatorUtils.pushPageByFade(
                          context: context, targPage: ViewDetailScreen(
                        pCard: pCard,
                      ), isReplace: false);
                    },
                    child: Container(
                      margin: EdgeInsets.all(7.0),
                      height: size.width * 0.92,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.backgroundBlack,
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(imageUrl: pCard.cardImage[0],fit: BoxFit.fill), // 이미지 여러장으로 수정
                    ),
                  ),
                  Divider(height: size.height*0.0316, thickness: 1,),

                  Container(
                    padding: EdgeInsets.only(left: 12, bottom: 2, top: 4),
                    child: Text(
                      '플레이 가능한 요일',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildGameDays()),
                  Container(
                    padding: EdgeInsets.only(left: 12, bottom: 2, top: 4),
                    child: Text(
                      '즐겨보는 스트리머',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildPlayerStreamers()),
                  Container(
                    padding: EdgeInsets.only(left: 12, bottom: 2, top: 4),
                    child: Text(
                      '즐겨보는 커뮤니티',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildPlayerCommunities()),

                  Divider(height: size.height*0.0316, thickness: 1,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row( // 하단 아이콘
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.sentiment_satisfied_alt),
                                iconSize: 35.0,
                                color: Palette.like,
                                onPressed: onLike,
                              ),
                              SizedBox(width: size.width*0.1145),
                              IconButton(
                                icon: Icon(Icons.sentiment_very_dissatisfied),
                                iconSize: 35.0,
                                color: Palette.dislike,
                                onPressed: onDislike,
                              ),
                            ]
                        ),

                        Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.read_more),
                                iconSize: 35.0,
                                onPressed: () {
                                  NavigatorUtils.pushPageByFade(
                                      context: context, targPage: ViewDetailScreen(
                                    pCard: pCard,
                                  ), isReplace: false);
                                  },
                              ),
                              Text(
                                '상세',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
