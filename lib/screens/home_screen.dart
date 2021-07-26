import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';
import 'package:game_jeossi_app/widgets/home_widgets.dart';


class SearchMap {
  Map<String, dynamic> mapVariable;
  SearchMap(this.mapVariable);
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardModel> _profileCard = [];
  SearchMap _args = SearchMap({});

  String _listUrl = ApiUrl.listUrl;
  bool _isLoading = false;
  int _preLoadingTime = 0;

  @override
  void initState() {
    super.initState();
    loadingNetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SliverAppBar(
                automaticallyImplyLeading: false,
                brightness: Brightness.light,
                backgroundColor: Palette.customBackground,
                title: Text(
                  '겜저씨',
                  style: const TextStyle(
                    color: Palette.mainPurple,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.2,
                  ),
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  CircleButton(
                    icon: Icons.search,
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final CardModel pCard = _profileCard[index];
                  return ProfileContainer(
                    pCard: pCard,
                    onDislike: () {showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('게시물이 맘에 안 드시나요?'),
                        content: Text('싫어요를 누를 경우 삭제됩니다.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('아니요'),
                          ),
                          TextButton(
                            onPressed: (){likePost(pCard.cardId, context, 0, index);},
                            child: Text('네'),
                          ),
                        ],
                      ),
                    );},
                    onLike: () {showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('게시물이 맘에 드시나요?'),
                        content: Text('서로 좋아요를 누를 경우 매칭됩니다.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('아니요'),
                          ),
                          TextButton(
                            onPressed: (){likePost(pCard.cardId, context, 1, index);},
                            child: Text('네'),
                          ),
                        ],
                      ),
                    );},
                  );
                  },
                  childCount: _profileCard.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void likePost(int idCard, BuildContext context, int isLike, int idx) async{
    Map<String, dynamic> map = {
      "card_id": idCard,
      "is_like": isLike,
    };
    // 매핑

    // post 요청
    ResponseInfo responseInfo = await DioUtils.instance.putRequest(
      url: ApiUrl.likeUrl,
      formDataMap: map,
    );

    if (responseInfo.success) {
      Navigator.pop(context);
      setState(() {_profileCard.removeAt(idx);});

      if (responseInfo.data['response'] == "New match!"){
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('새로운 매칭입니다!'),
            content: Text('확인해보세요.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('네'),
              ),
            ],
          ),
        );
      }

    }
    else {
      ToastUtils.showToast("요청 실패");
    }
  }

  void loadingNetData() async {
    ResponseInfo responseInfo = await DioUtils.instance.getRequest(
        url: _listUrl,
        queryParameters: _args.mapVariable
    );

    _isLoading = false;
    if (responseInfo.success) {
      _listUrl = responseInfo.data['next'];
      List resList = responseInfo.data['results'];
      resList.forEach((element) {
        _profileCard.add(CardModel.fromMap(element));
      });
      setState(() {});

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
