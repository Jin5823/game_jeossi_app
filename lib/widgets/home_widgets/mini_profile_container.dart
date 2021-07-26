import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MiniProfileContainer extends StatelessWidget {
  final CardModel pCard;
  final VoidCallback detailDialog;

  const MiniProfileContainer({
    Key key,
    @required this.pCard,
    @required this.detailDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.1053,
      child: Center(
        child: ListTile(
          leading: Container(
            width: size.width*0.1273,
            height: size.height*0.0658,
            child: InkWell(
              onTap: () {
                NavigatorUtils.pushPageByFade(
                    context: context, targPage: ViewDetailScreen(
                  pCard: pCard,
                ), isReplace: false);
                },
              child: CachedNetworkImage(imageUrl: pCard.cardImage[0]),
            )
          ),
          title: Text(
            pCard.playerGame,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            pCard.gamerName,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: InkResponse(
            onTap: detailDialog,
            child: Container(
              width: size.width*0.1273,
              height: size.height*0.0658,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Palette.infoIcon,
              ),
              child: Icon(
                Icons.more_horiz,
                size: 25.0,
                color: Palette.customBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
