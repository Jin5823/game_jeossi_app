import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/widgets/chat_widgets.dart';


class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}


class _MatchScreenState extends State<MatchScreen> {
  @override
  void initState() {
    super.initState();
    loadingNetData();
  }

  List<MatchModel> _matchCard = [];
  int _requestId;

  String _listUrl = ApiUrl.matchUrl;
  int _preLoadingTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return onRefresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.light,
              backgroundColor: Palette.customBackground,
              title: Text(
                '매칭 목록 & 쪽지',
                style: const TextStyle(
                  color: Palette.mainPurple,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              floating: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final MatchModel match = _matchCard[index];
                return ChatContainer(
                  match: match,
                  requestId: _requestId,
                  detailDialog: () {showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: Text('작업'),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: Text('언매칭'),
                          onPressed: () => unMatch (match.userId, context, index),
                        ),
                      ],
                    ),
                  );},
                );
              },
                childCount: _matchCard.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void unMatch (int userId, BuildContext context, int idx) async{
    Map<String, dynamic> map = {
      "user_id": userId,
    };
    // 매핑

    ResponseInfo responseInfo = await DioUtils.instance.putRequest(
      url: ApiUrl.unmatchUrl,
      formDataMap: map,
    );

    if (responseInfo.success) {
      Navigator.pop(context);
      setState(() {_matchCard.removeAt(idx);});
    }
    else {
      ToastUtils.showToast("요청 실패");
    }
  }

  void loadingNetData() async {
    ResponseInfo responseInfo = await DioUtils.instance.getRequest(
        url: _listUrl);
    if (responseInfo.success) {
      List resList = responseInfo.data['results'];
      _requestId = responseInfo.data['requestId'];
      resList.forEach((element) {
        _matchCard.add(MatchModel.fromMap(element));
      });
      setState(() {});
    } else {
      ToastUtils.showToast("요청실패");
    }
  }

  Future<bool> onRefresh() async {
    _preLoadingTime = DateTime.now().microsecond;

    _matchCard = [];
    loadingNetData();
    int current = DateTime.now().microsecond;

    int flagTime = current - _preLoadingTime;

    if (flagTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - flagTime));
    }

    ToastUtils.showToast("새로고침 완료");
    return true;
  }
}