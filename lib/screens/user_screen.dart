import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/screens/screens.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/widgets/home_widgets.dart';
import 'package:game_jeossi_app/utils/navigator_utils.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}


class _UserScreenState extends State<UserScreen> {
  List<CardModel> _profileCard = [];
  String _userName = ' ';
  String _listUrl = ApiUrl.listUrl;
  bool _isLoading = false;
  int _preLoadingTime = 0;

  @override
  void initState() {
    super.initState();
    userInfo();
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
                      Container(height: size.height*0.46, color: Palette.purpleBackground),
                      Container(
                        height: size.height*0.46,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.post_add,size: 33,),
                                    color: Palette.mainPurple,
                                    onPressed: () {
                                      NavigatorUtils.pushPageByFade(
                                          context: context, targPage: UploadScreen(isUpload: true),
                                          isReplace: false, dismissCallBack: (value) => onRefresh());
                                    }
                                )
                              ],
                            ),
                            // ?????? ??????

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '??? ?????????',
                                style: TextStyle(fontSize: 30, color: Palette.mainPurple), // ?????? ??????
                              ),
                            ),
                            // ?????????
                            Container(
                              width: size.width*0.305, // ?????? ??????, ?????? ??????
                              height: size.height*0.158,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/avatar0.jpg'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Palette.secondPurple, // ????????? ???
                                    blurRadius: 40,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            // ?????? ????????? ?????????
                            Text(
                              _userName,
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
                      Container(height: size.height*0.09746, color: Palette.purpleBackground),
                      Container(
                        height: size.height*0.09746,
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
                    return MiniProfileContainer(
                      pCard: pCard,
                      detailDialog: () {showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                          title: Text('??????'),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text('??????/??????'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  NavigatorUtils.pushPageByFade(
                                      context: context, targPage: UploadScreen(pCard: pCard, isUpload: false),
                                      isReplace: false, dismissCallBack: (value) => onRefresh());
                                }
                            ),
                            SimpleDialogOption(
                              child: Text('??????'),
                              onPressed: () => deletePost(pCard.cardId,context, index),
                            ),
                          ],
                        ),
                      );},
                    );},
                    childCount: _profileCard.length,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }

  void deletePost(int idCard, BuildContext context, int idx) async{
    Map<String, dynamic> map = {
      "card_id": idCard,
    };
    // ??????

    // delete ?????? ?????? ?????????
    ResponseInfo responseInfo = await DioUtils.instance.deleteRequest(
      url: ApiUrl.deleteUrl,
      formDataMap: map,
    );

    if (responseInfo.success) {
      Navigator.pop(context);
      setState(() {_profileCard.removeAt(idx);});
    }
    else {
      ToastUtils.showToast("?????? ??????");
    }
  }

  void userInfo() async{
    ResponseInfo responseInfo = await DioUtils.instance.getRequest(
      url: ApiUrl.infoUrl,
    );

    if (responseInfo.success) {
      setState(() {_userName = responseInfo.data['results']['username'];});
    }
    else {
      ToastUtils.showToast("?????? ??????");
    }
  }

  void loadingNetData() async {
    Map<String, dynamic> map = {
      "getUser": 1,
    };
    ResponseInfo responseInfo = await DioUtils.instance.getRequest(
        url: _listUrl,
        queryParameters: map,
    );
    _isLoading = false;
    if (responseInfo.success) {
      _listUrl = responseInfo.data['next'];
      List resList = responseInfo.data['results'];
      resList.forEach((element) {
        _profileCard.add(CardModel.fromMap(element));
      });

      setState(() {});
      // ?????? ?????? ??????
    } else {
      ToastUtils.showToast("????????????");
    }
  }

  void loadMore() {
    if (_listUrl == null) {
      ToastUtils.showToast("????????????");
    }

    if (!_isLoading && _listUrl != null) {
      _isLoading = true;
      loadingNetData();
    }
  }

  Future<bool> onRefresh() async {
    _listUrl = ApiUrl.listUrl;
    // ?????????

    _preLoadingTime = DateTime.now().microsecond;
    _profileCard = [];
    loadingNetData();

    int current = DateTime.now().microsecond;

    //?????????
    int flagTime = current - _preLoadingTime;

    if (flagTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - flagTime));
    }

    ToastUtils.showToast("???????????? ??????");
    return true;
  }
}
