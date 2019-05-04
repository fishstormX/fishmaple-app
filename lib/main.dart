import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fish/pages/blog_page.dart';
import 'package:fish/pages/notes_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'pages/main_page.dart';
import 'db/db.dart';
import 'package:path_provider/path_provider.dart';
import 'obj/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:simple_permissions/flutter_simple_permissions.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generat1or',
      home: new Welcome(),
    );
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

//入口-wait
class WelcomePage extends State<Welcome> with SingleTickerProviderStateMixin {
  Animation<double> tween;
  AnimationController controller;
  var database=null;

  @override
  void dispose(){
    controller.dispose();
    super.dispose();

  }

  startAnimtaion() {
    setState(() {
      controller.forward(from: 0.0);
    });
  }



  var click = 0.00;
  var timer;
  var data = {'chinese': "", 'english': "", 'from': ""};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    {
      widgets.add(
        new Center(
          child: new Stack(
            children: <Widget>[
              new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 32.0),
                      child: Image.asset(
                        "images/012.png",
                      ),
                    ),
                    Opacity(
                      opacity: controller.value,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                        child: Text(
                          "\r" + data['chinese'] + "\n",
                          style: new TextStyle(
                            fontFamily: "Ewert",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: controller.value,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
                        child: Text(
                          "\r" + data['english'],
                          style: new TextStyle(
                            fontFamily: "Ewert",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: controller.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 20),
                        child: Text(data['from'],
                            style: new TextStyle(
                              fontFamily: "Ewert",
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ]),
              new Positioned(
                top: 40.0,
                left: 15.0,
                child: Opacity(
                    opacity: controller.value > 0.8
                        ? (controller.value - 0.8) * 3
                        : 0,
                    child: new RaisedButton(
                      shape: new StadiumBorder(
                        side: new BorderSide(
                          //设置 界面效果
                          width: 200.0,
                          style: BorderStyle.none,
                        ),
                      ),
                      color: Colors.grey, //按钮的背景颜色
                      child: new Text('跳过'),
                      textColor: Colors.white, //文字的颜色
                      textTheme: ButtonTextTheme.normal, //按钮的主题
                      onHighlightChanged: (bool b) {
                        //水波纹高亮变化回调
                      },
                      disabledTextColor: Colors.black54, //按钮禁用时候文字的颜色
                      disabledColor: Colors.black54, //按钮被禁用的时候显示的颜色
                      highlightColor:
                          Colors.yellowAccent, //点击或者toch控件高亮的时候显示在控件上面，水波纹下面的颜色
                      colorBrightness: Brightness.light, //按钮主题高亮
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                                builder: (context) => new Login()),
                            (route) => route == null);
                      },
                    )),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  State initState() {
    super.initState();

    /*创建动画控制类对象*/
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    /*创建补间对象*/
    tween = new Tween(begin: 0.0, end: 1.0).animate(controller) //返回Animation对象
      ..addListener(() {
        //添加监听
        if (!mounted) return;
        setState(() {

        });
      });
    controller.forward();
    Future words() async {
      var httpClient = new HttpClient();
      String httpResult = "";
      var request = await httpClient
          .getUrl(Uri.parse("https://www.fishmaple.cn/api/m/words"));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonStr = await response.transform(utf8.decoder).join();
        var map = json.decode(jsonStr);
        this.data['chinese'] = map['chinese'].toString();
        this.data['english'] = map['english'].toString();
        this.data['from'] = "——" + map['from'].toString();
        if (!mounted) return;
        setState(() {
          // update the text
          this.data = data;
        });
      }
      startAnimtaion();
    }

    words();
    new Timer(const Duration(milliseconds: 4000), () {
      if (!mounted) return;
      setState(() {
        // update the text
        this.click = 0.60;
      });
    });
    timer = new Timer(const Duration(milliseconds: 10000), () {
      print("加载主页面");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new Login()),
          (route) => route == null);
    });
  }


}

//注册页面
class RegisterPage extends State<Register> {
  String text = "";
  var color = Colors.red;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController psw2Controller = TextEditingController();
  TextEditingController pswController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text('用户注册'),
      ),
      body:  new ListView(
        children: <Widget>[
          new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Image.asset(
                "images/logo-fish2.png",
                height: 50,
                width: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                  });
                },
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon:new Offstage(
                    offstage:(nameController.text==null||nameController.text==""),
                    child: IconButton(
                      //这里控制
                      icon: new Icon(Icons.clear,
                          color: Colors.black45),
                      onPressed: () {
                        nameController.clear();
                        setState(() {
                        });
                      },),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.person),
                  labelText: '用户名',
                ),
                autofocus: false,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                  });
                },
                controller: pswController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon:new Offstage(
                    offstage:(pswController.text==null||pswController.text==""),
                    child: IconButton(
                      //这里控制
                      icon: new Icon(Icons.clear,
                          color: Colors.black45),
                      onPressed: () {
                        pswController.clear();
                        setState(() {
                        });
                      },),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.vpn_key),
                  labelText: '密码',
                ),
                autofocus: false,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                  });
                },
                controller: psw2Controller,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon:new Offstage(
                    offstage:(psw2Controller.text==null||psw2Controller.text==""),
                    child: IconButton(
                      //这里控制
                      icon: new Icon(Icons.clear,
                          color: Colors.black45),
                      onPressed: () {
                        psw2Controller.clear();
                        setState(() {
                        });
                      },),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.vpn_key),
                  labelText: '确认密码',
                ),
                autofocus: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child: RaisedButton(
                  shape: new StadiumBorder(
                    side: new BorderSide(
                      //设置 界面效果
                      style: BorderStyle.none,
                    ),
                  ),
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: register,
                  elevation: 10.0,
                  child: const Text('注册')),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child: Text(
                text,
                style: new TextStyle(
                  fontFamily: "Ewert",
                  color: color,
                ),
              ),
            ),
          ],
        ),
      )
    ]),);
  }

  Future register() async {
    var httpClient = new HttpClient();
    String httpResult = "";
    if (pswController.text == "" || nameController.text == "") {
      text = "用户名或密码不能为空";
    } else if (pswController.text == psw2Controller.text) {
      try {
        var request = await httpClient
            .postUrl(Uri.parse("https://www.fishmaple.cn/api/register?from=m"));

        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");
        request.write(json
            .encode({'name': nameController.text, "pswd": pswController.text}));
        var response = await request.close();
        if (response.statusCode == HttpStatus.ok) {
          var httpResult = await response.transform(utf8.decoder).join();
          text = httpResult;
        } else {
          httpResult = '业务逻辑出现错误，请联系管理员 ${response.statusCode}';
          text = httpResult;
        }
      } catch (exception) {
        httpResult = '服务器异常，请联系管理员';
        text = httpResult;
      }
    } else {
      text = "两次输入密码不一致";
    }

    setState(() {
      // update the text
      if (text == "SUCCESS") {
        this.color = Colors.lightGreen;
        new Timer(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new Login()),
              (route) => route == null);
        });
        text = "注册成功！";
      }
      this.text = text;
    });
    if (!mounted) return;
  }
}

//登录页面
class LoginPage extends State<Login> {
  String text = "";
  String id="";
  String token="";
  int first=1;
  @override
  void dispose(){
    super.dispose();

  }
  @override
  void initState() {
   dbInitFirstOpen(context);
    super.initState();
    if (widget.loginState == "0") {
      text = "当次登录状态过期，请重新登录";
    }
  }
  Future<String> dbInitFirstOpen(BuildContext context) async{
    // Get a location using getDatabasesPath
    Directory documentDic = await getApplicationDocumentsDirectory();

    String path = documentDic.path+"/fish.db";
    print(path);
// 创建数据库
    Database database = await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
    /*  await db.execute(
            'DROP TABLE notes');*/
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS config(name VARCHAR(255) UNIQUE,id INTEGER PRIMARY KEY, value TEXT)');
          await db.execute(
              "CREATE TABLE IF NOT EXISTS `notes`(`id` INTEGER PRIMARY KEY,`uid` varchar(255) DEFAULT NULL,"
                  "`type` varchar(255) DEFAULT NULL,`title` varchar(255) NOT NULL,`content` text,"
                  "`timestamp` varchar(255) DEFAULT NULL,`param0` varchar(255) DEFAULT NULL,`param1` varchar(255) DEFAULT NULL) ;");
        });

    await database.execute(
        'CREATE TABLE IF NOT EXISTS config(name VARCHAR(255) UNIQUE,id INTEGER PRIMARY KEY, value TEXT)');
    await database.execute(
        "CREATE TABLE IF NOT EXISTS `notes`(`id` INTEGER PRIMARY KEY,`uid` varchar(255) DEFAULT NULL,"
            "`type` varchar(255) DEFAULT NULL,`title` varchar(255) NOT NULL,`content` text,"
            "`timestamp` varchar(255) DEFAULT NULL,`param0` varchar(255) DEFAULT NULL,`param1` varchar(255) DEFAULT NULL) ;");

      List<Map> firstOpen=await database.rawQuery('SELECT *  FROM config where name = "first_open"');
      List<Map> firstLogin=await database.rawQuery('SELECT *  FROM config where name = "first_login"');
      if(firstLogin.length>0){
        first=1;

      }else{
        first=0;
        await database.rawInsert(
            'INSERT INTO config(name, value) VALUES("first_login", 1  )');
      }

      if(firstOpen.length>0){

      }else{
        await database.rawInsert(
            'INSERT INTO notes(uid,type,title,content,timestamp,param0,param1) VALUES("${id}", "2","示例-1","示例文本","1548086603","1",""  )');
        await database.rawInsert(
            'INSERT INTO notes(uid,type,title,content,timestamp,param0,param1) VALUES("${id}", "2","示例1","示例文本2","1548086603","2",""  )');
        await database.rawInsert(
            'INSERT INTO notes(uid,type,title,content,timestamp,param0,param1) VALUES("${id}", "2","示例2","市里文本3","1548086603","3",""  )');
        await database.rawInsert(
            'INSERT INTO notes(uid,type,title,content,timestamp,param0,param1) VALUES("${id}", "2","示例3","市里文本4","1548086603","4",""  )');
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: new Text("提示"),
                content: new Text("build note v 0.9.7修订版：\n"+
                    "1.目前仅支持有账户的扫码登录和无账户的笔记记录\n"
                        "2.为某些功能添加了缓存,提供了无用户系统的笔记，支持笔记列表长按动作\n"
                        "3.优化了数据加载渲染的动画\n"
                        "4.优化了一些交互动画\n"
                        "5.写不动了，暂时搁置（仅第一次开启应用会弹出此提示）"),
                actions:<Widget>[
                  new FlatButton(child:new Text("我知道了"), onPressed: (){
                    Navigator.of(context).pop();
                  },)
                ]
            ));
        int id1 = await database.rawInsert(
            'INSERT INTO config(name, value) VALUES("first_open", 1  )');
      }

    await database.close();



  }

  TextEditingController nameController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        resizeToAvoidBottomPadding:true,
      appBar: new AppBar(
        title: new Text('登录'),
      ),
      body:
      new ListView(
      children: <Widget>[
      new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Image.asset(
                "images/logo-fish1.png",
                height: 50,
                width: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: TextField(
                onChanged: (value){
                  setState(() {
                  });
                },
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon:new Offstage(
                    offstage:(nameController.text==null||nameController.text==""),
                    child: IconButton(
                      //这里控制

                      icon: new Icon(Icons.clear,
                          color: Colors.black45),
                      onPressed: () {
                        nameController.clear();
                        setState(() {
                        });
                      },),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.person),
                  labelText: '用户名',
                ),
                autofocus: false,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: TextField(

                controller: pswController,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value){
                  setState(() {
                  });
                },
                decoration: InputDecoration(

                  suffixIcon:new Offstage(
                  offstage:(pswController.text==null||pswController.text==""),
                    child: IconButton(
                       //这里控制
                       icon: new Icon(Icons.clear,
                        color: Colors.black45),
                  onPressed: () {
                        pswController.clear();
                        setState(() {
                        });
                    },),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.vpn_key),
                  labelText: '密码',
                ),
                autofocus: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children :<Widget>[

                RaisedButton(
                  shape: new StadiumBorder(
                    side: new BorderSide(
                      //设置 界面效果
                      style: BorderStyle.none,
                    ),
                  ),
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: login,
                  elevation: 10.0,
                  child: const Text('登录')),
              RaisedButton(
                  shape: new StadiumBorder(
                    side: new BorderSide(
                      //设置 界面效果
                      style: BorderStyle.none,
                    ),
                  ),
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: anonymousLogin,
                  elevation: 10.0,
                  child: const Text('直接进入')),]
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child: Text(
                text,
                style: new TextStyle(
                  fontFamily: "Ewert",
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child: InkWell(
                child: Text("立即注册"),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Register()));
                },
              ),
            )
          ],
        ),
      ),
      ]),
    );
  }

  anonymousLogin(){
    NavigatorState navigator= context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?"+(navigator==null).toString());

    if(first==0){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text("提示"),
            content: new Text("使用匿名会无法同步线上笔记数据，您的一些操作将会引起笔记数据丢失并且无法同步,"
                +"无法使用扫码登录功能，是否继续？\n(这个提示只会出现一次)"),
            actions:<Widget>[
              new FlatButton(child:new Text("使用密码登录"), onPressed: (){
                Navigator.of(context).pop();
              },),
              new FlatButton(child:new Text("我已知悉，仍继续"), onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) =>
                        new Main(token: "0", name: "",id :"0")),
                        (route) => route == null);
              },)
            ]
        ));
    }else{
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) =>
              new Main(token: "0", name: "",id :"")),
              (route) => route == null);
    }

  }

  Future login() async {
    var httpClient = new HttpClient();
    String httpResult = "";
    var map={"msg":"","id":"","token":""};
    try {
      var request = await httpClient
          .postUrl(Uri.parse("https://www.fishmaple.cn/api/tokenSign"));
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(json
          .encode({'name': nameController.text, "pswd": pswController.text}));
      var response = await request.close();



      if (response.statusCode == HttpStatus.ok) {
        var jsonStr = await response.transform(utf8.decoder).join();
        var map = json.decode(jsonStr);
        this.text=map['msg'];
        this.id=map['id'];
        this.token=map['token'];
      } else {
        httpResult = '业务逻辑出现错误，请联系管理员 ${response.statusCode}';
        text = httpResult;
      }
    } catch (exception) {
      httpResult = '服务器异常，请联系管理员';
      text = httpResult;
    }
    if (text=="SUCCESS") {

      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) =>
              new Main(token: token, name: nameController.text,id :id)),
              (route) => route == null);
    }else {
      setState(() {

      });
    }
    if (!mounted) return;


  }
}

//读取当前问好
String readTimestamp() {
  var date = new DateTime.now().millisecondsSinceEpoch / 1000 + 28800;
  if (date % 86400 < 28800 && date % 86400 > 18000) {
    return "早上好";
  } else if (date % 86400 > 28800 && date % 86400 < 39600) {
    return "上午好";
  } else if (date % 86400 > 39600 && date % 86400 < 46800) {
    return "中午好";
  } else if (date % 86400 > 46800 && date % 86400 < 59400) {
    return "下午好";
  } else if (date % 86400 > 59400 && date % 86400 < 82800) {
    return "晚上好";
  } else {
    return "早些休息";
  }
}

//主程序
class _MyScanState extends State<Main> {
  String barcode = "";
  String token = null;
  String name = "";
  int page = 0;
  String id="";
  var on = Colors.lightBlue;
  var off = Colors.grey;
  var _bodys = [];

  @override
  void initState() {
    this.token = widget.token;
    this.name = widget.name;
    this.id = widget.id;
    _bodys=[
      new Note(token: token, name: name,id:id),
      new Blog(),
      new Qr(token: token, name: name),
      new User()]
    ;
    super.initState();
  }

  /*var c = new NotificationListener<ScrollNotification>(
  onNotification: _handleScrollNotification,
  child: new ListView.builder(
  controller: scrollController,
  itemBuilder: (BuildContext ctx, int index) {
  return new BookItemView(
  book: _items[index],
  searchKey: _searchText,
  words: _words,
  );
  },
  itemCount: _items?.length ?? 0,
  ))
*/


  _getPopupMenu(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return
      showMenu(context: context,
          position: RelativeRect.fromLTRB(width-40, 80, 0, 0),
          items:
      <PopupMenuEntry<String>>[
      new PopupMenuItem(
        value:"1",
        child:
        new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(IconData(0xe605,fontFamily:'appIconFonts'),color: Colors.green, size: 20),
            new Text('  便利贴'),
          ],
        ),),
      new PopupMenuItem(
        value:"2",
        child:
        new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(Icons.access_alarm,color:Colors.redAccent, size: 23),
            new Text('  日程'),
          ],
        ),),
      new PopupMenuItem(
        value:"3",
        child:
        new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(IconData(0xe622,fontFamily:'appIconFonts'),color: Colors.lightBlue, size: 19),
            new Text('  备忘录'),
          ],
        ),),
      new PopupMenuItem(
        value:"4",
        child:
        new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(IconData(0xe624,fontFamily:'appIconFonts'),color: Colors.orangeAccent, size: 21),
            new Text('  时间胶囊'),
          ],
        ),)
    ]).then<void>((String newValue) {
      if (!mounted) return null;

    Navigator.push(context, new MaterialPageRoute(
    builder: (context) => new NotesEdit(token:token,name:name,uid:id,type:newValue,notes:new NotesItem(id:"-1",uid:id,type:"1",timestamp:"",title: "",content: "",param0: "",param1: ""))));

    });
  }


  appbar(int part){

    if(page==1){
      return null;
    }
    if(page==0){
      return new AppBar(
        title: new Text('笔记'),

        actions:[
         new Container(
           child:IconButton(
               icon:Icon(Icons.add),
             onPressed: (){
                _getPopupMenu(context);
             },
           )
         )
          /*
          new PopupMenuButton(
              onSelected: (String value) {
                print('onSelected'+value);
                Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new NotesEdit(token:token,name:name,uid:id,type:value)));
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(

                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('增加'),
                      new Icon(Icons.add_circle)
                    ],
                  ),
                  value: '这是增加',
                ),
                PopupMenuItem(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text('增加'),
                      new Icon(Icons.remove_circle)
                    ],
                  ),
                  value: '这是删除',
                )
              ])
          ,*/

        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        appBar: appbar(0),
        body: _bodys[page],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: .0),
          child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
            items: [
              new BottomNavigationBarItem(
                icon: getTabIcon(0),
                title: getTabTitle(0),
                backgroundColor: Colors.white,
              ),
              new BottomNavigationBarItem(
                icon: getTabIcon(1),
                title: getTabTitle(1),
                backgroundColor: Colors.white,
              ),
              new BottomNavigationBarItem(
                icon: getTabIcon(2),
                title: getTabTitle(2),
                backgroundColor: Colors.white,
              ),
              new BottomNavigationBarItem(
                icon: getTabIcon(3),
                title: getTabTitle(3),
                backgroundColor: Colors.white,
              ),
            ],
            //onTap: null,
            currentIndex: page,
            onTap: (index) {
              setState(() {
                page = index;
              });
            },
          ),
        ));
  }

  var tabImages = [
    [
      Icon(IconData(0xe691,fontFamily:'appIconFonts'),color: const Color(0xff888888), size: 20),
      //Icon(Icons.book, color: Colors.lightBlue, size: 23),
      Icon(IconData(0xe606,fontFamily:'appIconFonts'),color: Colors.lightBlue, size: 20)
    ],
    [
      Icon(IconData(0xe70b,fontFamily:'appIconFonts'), color: const Color(0xff888888), size: 23),
      Icon(IconData(0xe6ab,fontFamily:'appIconFonts'), color: Colors.lightBlue, size: 23)
    ],
    [
      Icon(Icons.center_focus_weak, color: const Color(0xff888888), size: 23),
      Icon(Icons.center_focus_strong, color: Colors.lightBlue, size: 23)
    ],
    [
      Icon(Icons.perm_identity, color: const Color(0xff888888), size: 23),
      Icon(Icons.person, color: Colors.lightBlue, size: 23)
    ]
  ];
  var appBarTitles = ['笔小记','博客', '扫码登录', '我的'];
  Text getTabTitle(int curIndex) {
    if (curIndex == page) {
      //活动颜色
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: Colors.blue));
    } else {
      return new Text(appBarTitles[curIndex]);
    }
  }

  Icon getTabIcon(int curIndex) {
    if (curIndex == page) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

}

//登陆成功-wait
class TransPage extends State<Trans> {
  var timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Image.asset(
                "images/success.gif",
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
              child: Text("登录成功！",
                  style: new TextStyle(
                    fontFamily: "Ewert",
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  @override
  State initState() {
    timer = new Timer(const Duration(milliseconds: 2500), () {
      print("成功返回");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) =>
                  new Main(name: widget.name, token: widget.token)),
          (route) => route == null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}

class Welcome extends StatefulWidget {
  @override
  createState() => new WelcomePage();
}

class Login extends StatefulWidget {
  final String loginState;

  Login({Key key, this.loginState}) : super(key: key);

  createState() => new LoginPage();
}

class Main extends StatefulWidget {
  final String token; //存储过来的token
  final String name;
  final String id;
  Main({Key key, this.token, this.name,this.id}) : super(key: key);
  createState() => new _MyScanState();
}

class Trans extends StatefulWidget {
  final String token; //存储过来的token
  final String name;
  Trans({Key key, this.token, this.name}) : super(key: key);
  createState() => new TransPage();
}

class Register extends StatefulWidget {
  createState() => new RegisterPage();
}

