import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/widgets/home_widgets.dart';


class OtherUserScreen extends StatefulWidget {
  final int cardOwner;
  final String userName;
  const OtherUserScreen ({ Key key, @required this.cardOwner, @required this.userName}): super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}


class _UserScreenState extends State<OtherUserScreen> {
  List<CardModel> _profileCard = [];
  String _listUrl = ApiUrl.listUrl;
  bool _isLoading = false;
  int _preLoadingTime = 0;

  @override
  void initState() {
    print(widget.cardOwner);
    super.initState();
    loadingNetData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.customWhite,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollNotification notification) {
          ScrollMetrics scrollMetrics = notification.metrics;
          double pixels = scrollMetrics.pixels;
          double maxPixels = scrollMetrics.maxScrollExtent;
          if (pixels >= maxPixels / 3 * 2) {
            loadMore();
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () {
            return onRefresh();
          },
          child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: <Widget>[
                      Container(height: size.height*0.4609, color: Palette.purpleBackground),
                      Container(
                        height: size.height*0.4609,  // 절대 크기, 상대 크기
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Palette.customWhite,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(75)
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_back,size: 33,),
                                  color: Palette.mainPurple,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            // 카드 생성
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '프로필',
                                style: TextStyle(fontSize: 30, color: Palette.mainPurple), // 절대 크기
                              ),
                            ),
                            // 텍스트
                            Container(
                              width: size.width*0.3055, // 절대 크기, 상대 크기
                              height: size.height*0.1580,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/avatar0.jpg'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Palette.secondPurple, // 두번째 색
                                    blurRadius: 40,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            // 유저 아이콘 이미지
                            Text(
                              widget.userName,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w700, color: Palette.mainPurple),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Stack(
                    children: <Widget>[
                      Container(height: size.height*0.0421, color: Palette.customWhite),
                      Container(
                        padding: EdgeInsets.only(top: 25),
                        height: size.height*0.0421,
                        decoration: BoxDecoration(
                          color: Palette.purpleBackground,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                            bottomRight: Radius.circular(75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Stack(
                    children: <Widget>[
                      Container(height: size.height*0.0974, color: Palette.purpleBackground),
                      Container(
                        height: size.height*0.0974,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Palette.customWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final CardModel pCard = _profileCard[index];
                    return MiniProfileContainer(pCard: pCard, detailDialog: (){},);
                  },
                    childCount: _profileCard.length,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  void loadingNetData() async {
    Map<String, dynamic> map = {
      "owner__id": widget.cardOwner,
    };
    ResponseInfo responseInfo = await DioUtils.instance.getRequest(
        url: _listUrl,
        queryParameters: map
    );
    _isLoading = false;
    if (responseInfo.success) {
      _listUrl = responseInfo.data['next'];
      List resList = responseInfo.data['results'];
      resList.forEach((element) {
        _profileCard.add(CardModel.fromMap(element));
      });
      setState(() {});
      // 상태 변화 반영
    } else {
      ToastUtils.showToast("요청실패");
    }
  }

  void loadMore() {
    if (_listUrl == null) {
      ToastUtils.showToast("끝페이지");
    }

    if (!_isLoading && _listUrl != null) {
      _isLoading = true;
      loadingNetData();
    }
  }

  Future<bool> onRefresh() async {
    _listUrl = ApiUrl.listUrl;
    // 첨부터

    _preLoadingTime = DateTime.now().microsecond;
    _profileCard = [];
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
