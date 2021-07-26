import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_jeossi_app/models/models.dart';
import 'package:game_jeossi_app/config/palette.dart';
import 'package:game_jeossi_app/config/api_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:game_jeossi_app/utils/dio_utils.dart';
import 'package:game_jeossi_app/utils/toast_utils.dart';


class UploadScreen extends StatefulWidget {
  final CardModel pCard;
  final bool isUpload;

  const UploadScreen ({
    Key key,
    this.pCard,
    @required this.isUpload,
  }): super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}


class _UploadScreenState extends State<UploadScreen> {
  FocusNode _gameNameFocusNode = FocusNode();
  FocusNode _gamerNameFocusNode = FocusNode();
  FocusNode _streamerFocusNode = FocusNode();
  FocusNode _communityFocusNode = FocusNode();
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _contentsFocusNode = FocusNode();

  TextEditingController _gameNameEditController = TextEditingController();
  TextEditingController _gamerNameEditController = TextEditingController();
  TextEditingController _streamerEditController = TextEditingController();
  TextEditingController _communityEditController = TextEditingController();
  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _contentsEditController = TextEditingController();
  // 텍스트

  List<int>_week = [1,1,1,1,0,0,0]; // 금-토-일
  PickedFile _image;
  double _styleValue = 5;

  final _startTime = List.generate(25, (i) => i);
  final _endTime = List.generate(25, (i) => i);
  int _startResult = 9;
  int _endResult = 20;

  var _nbCheckBox = CheckBoxModal(title: '뉴비 여부');

  @override
  void initState() {
    if (!widget.isUpload) {
      _styleValue = widget.pCard.playStyle.toDouble();
      _startResult = widget.pCard.gameHoursS;
      _endResult = widget.pCard.gameHoursE;
      _week = widget.pCard.gameDay.split('').map(int.parse).toList();
      _nbCheckBox = CheckBoxModal(title: '뉴비 여부', value: widget.pCard.isNoob);
      _gameNameEditController = TextEditingController(text: widget.pCard.playerGame);
      _gamerNameEditController = TextEditingController(text: widget.pCard.gamerName);

      _streamerEditController = TextEditingController(text: widget.pCard.playerStreamer.join(','));
      _communityEditController = TextEditingController(text: widget.pCard.playerCommunity.join(','));
      _titleEditController = TextEditingController(text: widget.pCard.postTitle);
      _contentsEditController = TextEditingController(text: widget.pCard.postContents);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    void uploadProfile() async{
      if (_image == null) {
        ToastUtils.showToast("사진을 추가 해줘잉");
        return;
      }

      String fileName = basename(_image.path);
      String gameDay = _week.join("");
      String gameName = _gameNameEditController.text;
      // 띄어쓰기 제거는 서버쪽에서 해줌

      String gamerName = _gamerNameEditController.text;
      String streamer = _streamerEditController.text;
      String community = _communityEditController.text;
      List<String> communityList;
      List<String> streamerList;
      // 띄어쓰기는 서버쪽에서 제거

      String title = _titleEditController.text;
      String contents = _contentsEditController.text;
      String isNoob = _nbCheckBox.value.toString().replaceAll("t", "T").replaceAll("f", "F");
      int playStyle = _styleValue.toInt();
      int gameHoursS = _startResult;
      int gameHoursE = _endResult;

      if (gameName.trim().length < 1) {
        ToastUtils.showToast("게임이름을 입력 해줘잉");
        return;
      }
      if (gameName.contains(',')) {
        ToastUtils.showToast("게임이름을 하나만 입력해줘잉");
        return;
      }
      if (gamerName.trim().length < 1) {
        ToastUtils.showToast("게임아이디를 입력 해줘잉");
        return;
      }
      if (title.trim().length < 1) {
        ToastUtils.showToast("제목을 입력 해줘잉");
        return;
      }
      if (contents.trim().length < 1) {
        ToastUtils.showToast("내용을 입력 해줘잉");
        return;
      }
      if (streamer.trim().length > 1) {
        streamerList = streamer.split(',');
      }
      if (community.trim().length > 1) {
        communityList = community.split(',');
      }

      Map<String, dynamic> map = {
        "gamer_name": gamerName,
        "title": title,
        "contents": contents,
        "game_day": gameDay,
        "game_hours_s": gameHoursS,
        "game_hours_e": gameHoursE,
        "is_noob":isNoob,
        "play_style":playStyle,
        "game_name": gameName,
        "images": [await MultipartFile.fromFile(_image.path,filename: fileName)],
        "streamer": streamerList,
        "community": communityList,
      };


      ResponseInfo responseInfo;
      if (!widget.isUpload) {
        // 삭제하고 다시 생성하는 방식으로 수정
        Map<String, dynamic> delMap = {
          "card_id": widget.pCard.cardId,
        };

        // delete 삭제 요청 로그인
        ResponseInfo delResponseInfo = await DioUtils.instance.deleteRequest(
          url: ApiUrl.deleteUrl,
          formDataMap: delMap,
        );

        if (delResponseInfo.success) {
          responseInfo = await DioUtils.instance.postRequest(
            url: ApiUrl.createUrl,
            formDataMap: map,
          );
        }
        else {
          ToastUtils.showToast("요청 실패");
        }
      } else {
        // post 요청 로그인
        responseInfo = await DioUtils.instance.postRequest(
          url: ApiUrl.createUrl,
          formDataMap: map,
        );
      }

      if (responseInfo.success) {
        ToastUtils.showToast("생성 완료");
        Navigator.pop(context);
      }
      else {
        ToastUtils.showToast("생성 실패");
      }
    }
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Palette.customWhite,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
                onTap: () {
                  _gameNameFocusNode.unfocus();
                  _gamerNameFocusNode.unfocus();
                  _streamerFocusNode.unfocus();
                  _communityFocusNode.unfocus();
                  _titleFocusNode.unfocus();
                  _contentsFocusNode.unfocus();
                  },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back),
                          color: Palette.customBlack,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height*0.0395),
                    // 화살표

                    if (widget.isUpload)
                      Text(
                      '프로필 카드 생성',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!widget.isUpload)
                      Text(
                        '프로필 카드 수정',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: size.height*0.0658),
                    // 안내 문구

                    TextField(
                      focusNode: _gameNameFocusNode,
                      controller: _gameNameEditController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: '게임 이름',
                        hintText: '예) 롤',
                        icon: Container(
                          width: size.width*0.1273,
                          height: size.height*0.0658,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Palette.uploadIconDecoration,
                          ),
                          child: Icon(
                            Icons.videogame_asset,
                            size: 25.0,
                            color: Palette.uploadIcon
                          ),
                        ),
                      ),
                    ),
                    Divider(height: size.height*0.0526),
                    TextField(
                      focusNode: _gamerNameFocusNode,
                      controller: _gamerNameEditController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: '게임내 아이디',
                        hintText: '예) hide on bush',
                        icon: Container(
                          width: size.width*0.1273,
                          height: size.height*0.0658,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Palette.uploadIconDecoration,
                          ),
                          child: Icon(
                            Icons.account_box,
                            size: 25.0,
                            color: Palette.uploadIcon,
                          ),
                        ),
                      ),
                    ),
                    Divider(height: size.height*0.0526),
                    TextField(
                      focusNode: _streamerFocusNode,
                      controller: _streamerEditController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: '스트리머',
                        hintText: '예) 침착맨,주펄...     (필수X)',
                        icon: Container(
                          width: size.width*0.1273,
                          height: size.height*0.0658,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Palette.uploadIconDecoration,
                          ),
                          child: Icon(
                            Icons.live_tv,
                            size: 25.0,
                            color: Palette.uploadIcon,
                          ),
                        ),
                      ),
                    ),
                    Divider(height: size.height*0.0526),
                    TextField(
                      focusNode: _communityFocusNode,
                      controller: _communityEditController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: '커뮤니티',
                        hintText: '예) 네이버카페,카연갤...     (필수X)',
                        icon: Container(
                          width: size.width*0.1273,
                          height: size.height*0.0658,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Palette.uploadIconDecoration,
                          ),
                          child: Icon(
                            Icons.accessibility_new,
                            size: 25.0,
                            color: Palette.uploadIcon,
                          ),
                        ),
                      ),
                    ),
                    Divider(height: size.height*0.0526),
                    // 카테고리 등

                    TextField(
                      minLines: 1,
                      maxLines: 1,
                      maxLength: 20,

                      focusNode: _titleFocusNode,
                      controller: _titleEditController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Palette.uploadIcon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Palette.uploadIcon),
                        ),

                        alignLabelWithHint: true,
                        labelText: '제목',
                        hintText: '예) 히오스 듀오 구함...',
                      ),
                    ),
                    TextField(
                      minLines: 10,
                      maxLines: 60,
                      maxLength: 2000,

                      focusNode: _contentsFocusNode,
                      controller: _contentsEditController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Palette.uploadIcon),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Palette.uploadIcon),
                        ),

                        alignLabelWithHint: true,
                        labelText: '내용',
                        hintText: '예) 뉴비 환영 버스 태워드림...',
                      ),
                    ),
                    SizedBox(height: size.height*0.0263),
                    // 제목 및 내용

                    Container(
                      width: size.width*0.6722,
                      height: size.height*0.0632,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(
                          Radius.circular((48 * .3)),
                        ),
                        gradient: new LinearGradient(
                            colors: [
                              Palette.uploadSliderS,
                              Palette.uploadSliderE,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(48 * .2, 2, 48 * .2, 2),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '즐겜',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48 * .3,
                                fontWeight: FontWeight.w700,
                                color: Palette.customWhite,
                              ),
                            ),
                            SizedBox(
                              width: size.width*0.0122,
                            ),
                            Expanded(
                              child: Center(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.white.withOpacity(1),
                                    inactiveTrackColor: Colors.white.withOpacity(.5),

                                    trackHeight: 4.0,
                                    thumbShape: CustomSliderThumbCircle(
                                      thumbRadius: 48 * .4,
                                      min: 0,
                                      max: 9,
                                    ),
                                    overlayColor: Colors.white.withOpacity(.4),
                                    //valueIndicatorColor: Colors.white,
                                    activeTickMarkColor: Palette.customWhite,
                                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                                  ),
                                  child: Slider(
                                      min: 0,
                                      max: 9,
                                      divisions: 9,
                                      label: '$_styleValue',
                                      value: _styleValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _styleValue = value;
                                        });
                                      }),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width*0.0122,
                            ),
                            Text(
                              '빡겜',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48 * .3,
                                fontWeight: FontWeight.w700,
                                color: Palette.customWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height*0.0395),
                    // 플레이 스타일

                    ListTile(
                      onTap: () => ckbClicked(_nbCheckBox),
                      leading: Checkbox(
                        value: _nbCheckBox.value,
                        onChanged: (value) => ckbClicked(_nbCheckBox),
                      ),
                      title: Text(
                        _nbCheckBox.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    Divider(height: size.height*0.0790),
                    // 뉴비 여부
                    Text(
                      '가능한 요일',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[0] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[0] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '월',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[0] == 0 ? _week[0] = 1 : _week[0] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[1] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[1] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '화',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[1] == 0 ? _week[1] = 1 : _week[1] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[2] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[2] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '수',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[2] == 0 ? _week[2] = 1 : _week[2] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[3] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[3] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '목',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[3] == 0 ? _week[3] = 1 : _week[3] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[4] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[4] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '금',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[4] == 0 ? _week[4] = 1 : _week[4] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[5] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[5] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '토',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[5] == 0 ? _week[5] = 1 : _week[5] = 0;
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(10, 10),
                                  padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                      color: _week[6] == 0
                                          ? Colors.transparent
                                          : Palette.uploadButtonF,
                                    ),
                                  ),
                                  backgroundColor:  _week[6] == 0 ? Palette.uploadButtonC : null,
                                ),
                                child: Text(
                                  '일',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _week[6] == 0 ? _week[6] = 1 : _week[6] = 0;
                                  });
                                },
                              ),
                            ]
                        )
                    ),

                    SizedBox(height: size.height*0.0144),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                // minSize: Size(10, 10),
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                                borderRadius: BorderRadius.circular(16.0),
                                color: Palette.uploadButtonC,
                                child: Text('플레이 시작시간',
                                    style: TextStyle(
                                      color: Palette.customBlack,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onPressed: () async {
                                  await showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      actions: [

                                        Container(
                                            height: size.height*0.3292,
                                            child: CupertinoPicker(
                                              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                background: Colors.pink.withOpacity(0.12),
                                              ),
                                              //diameterRatio: 0.7,
                                              children: _startTime.map((e) => Text(
                                                  '$e:00', style: TextStyle(
                                                fontSize: 32.0,
                                                fontWeight: FontWeight.bold,))).toList(),
                                              itemExtent: 40.0,
                                              scrollController: FixedExtentScrollController(initialItem: _startResult),
                                              onSelectedItemChanged: (int index) {
                                                setState(() {
                                                  _startResult = _startTime[index];
                                                });
                                              },
                                            )
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Text(
                                '시작 : $_startResult:00',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 16.0,
                                  )
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                // minSize: Size(10, 10),
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                                borderRadius: BorderRadius.circular(16.0),
                                color: Palette.uploadButtonC,
                                child: Text('플레이 끝난시간',
                                    style: TextStyle(
                                      color: Palette.customBlack,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onPressed: () async {
                                  await showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      actions: [

                                        Container(
                                            height: size.height*0.3292,
                                            child: CupertinoPicker(
                                              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                                                background: Colors.pink.withOpacity(0.12),
                                              ),
                                              //diameterRatio: 0.7,
                                              children: _endTime.map((e) => Text(
                                                  '$e:00', style: TextStyle(
                                                fontSize: 32.0,
                                                fontWeight: FontWeight.bold,))).toList(),
                                              itemExtent: 40.0,
                                              scrollController: FixedExtentScrollController(initialItem: _endResult),
                                              onSelectedItemChanged: (int index) {
                                                setState(() {
                                                  _endResult = _endTime[index];
                                                });
                                              },
                                            )
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Text(
                                '끝 : $_endResult:00',
                                  style: TextStyle(
                                    color: Palette.customBlack,
                                    fontSize: 16.0,
                                  )
                              ),
                            ],
                          ),
                        ]

                    ),
                    Divider(height: size.height*0.0790),
                    // 플레이 시간

                    Text(
                      '이미지 업로드',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height*0.0263),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {getImage();},
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              width: size.width*0.6365,
                              height: size.height*0.3292,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Palette.backgroundBlack,
                                    offset: Offset(0, 5),
                                    blurRadius: 8.0,
                                  ),
                                ],
                              ),
                              child: (_image!=null)?Image.file(
                                File(_image.path),
                                fit: BoxFit.fill,
                              ):Image.asset(
                                "assets/icons/image.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Divider(height: size.height*0.0790),
                    // 이미지

                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        backgroundColor: Palette.uploadIcon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        (widget.isUpload) ? '생성':'수정',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Palette.customWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {uploadProfile();},
                    ),
                  ],
                ),
            )
        )
    );
  }

  ckbClicked(CheckBoxModal ckbItem){
    setState(() {
      ckbItem.value = !ckbItem.value;
    });
  }

}


class CheckBoxModal {
  String title;
  bool value;

  CheckBoxModal({@required this.title, this.value = false});
}


class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    @required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Palette.customWhite //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
    Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min+(max-min)*value).round().toString();
  }
}
