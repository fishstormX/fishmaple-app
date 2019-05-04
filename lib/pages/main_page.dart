import 'package:flutter/material.dart';
import 'package:fish/obj/product.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fish/obj/product_detail.dart';
import 'package:fish/pages/blog_page.dart';
import 'package:fish/main.dart';
import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fish/pages/notes_page.dart';

class Qr extends StatefulWidget {
  final String token; //存储过来的token
  final String name;
  Qr({Key key, this.token, this.name}) : super(key: key);
  createState() => new ToQrPage();
}

class User extends StatefulWidget {
  createState() => new UserPage();
}

class Blog extends StatefulWidget {
  createState() => new BlogPage();
}

class Note extends StatefulWidget {
  final String token; //存储过来的token
  final String name;
  final String id;
  Note({Key key, this.token, this.name, this.id}) : super(key: key);
  createState() => new NotePage();
}




class BlogPage extends State<Blog> {



  String barcode = "";
  String token = null;
  String name = "";

  static BlogItem blog =
  new BlogItem(id:" ",title: "", content: " ", timeline: "1543555447",cover:"",author:" ");
  List<BlogItem> blogs= [blog];
  @override
  void initState() {
    getBlogList();
    // this.token = widget.token;
    //this.name = widget.name;
    super.initState();
  }

  Future getBlogList() async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse("https://www.fishmaple.cn/api/blog?page=1"));
    var response = await request.close();

      var jsonStr = await response.transform(utf8.decoder).join();
      List responseJson = json.decode(jsonStr);
      blogs = responseJson.map((m) => new BlogItem.fromJson(m)).toList();
    if (!mounted) return;
      setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      slivers: <Widget>[
        /* SliverAppBar(
             actions: <Widget>[
              _buildAction(),
            ],
            //title: Text('SliverAppBar'),
            backgroundColor: Theme.of(context).accentColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('images/012.png', fit: BoxFit.cover),
            ),
            floating: true,
            snap: true,
            primary: false,
            //pinned: pinned,
          ),*/
        /* SliverGrid(
         gridDelegate:
         SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 0.0,
           crossAxisSpacing: 0,

         ),
        delegate: SliverChildBuilderDelegate(

              (BuildContext context, int index) {
            return _buildItem2(context, notesItems[index]);
          },
          childCount: notesItems.length,
        ),
      ),*/
        SliverFixedExtentList(
          itemExtent: 140.0,
          delegate: SliverChildListDelegate(
            blogs.map((blogItem) {
              return _buildBlogItem(blogItem);
            }).toList(),
          ),
        ),
      ],

    );
  }

  Widget _buildBlogItem(BlogItem  blogItem) {

    var width = MediaQuery.of(context).size.width;
    if(blogItem.title==""){
      return new
      Stack
        (
          children:<Widget>[
            Container(

                child:

                Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),child:
                SpinKitPouringHourglass (
                  color: Colors.lightBlue,
                  size: 50.0,
                ),)),
            Padding(padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                child:Center(child:Text("精彩加载中",style:TextStyle(fontSize: 20)))
            )
          ]);
    }
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0, 5, 0),
      child: Stack(
        //alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Positioned(
            left: 5.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new BlogDetail(blog:blogItem)));

              },
              child: Card(
                child: /*Container(
                    margin: EdgeInsets.only(left: 10.0),
                    height: 200,
                    child:*/
                Stack(
                  //alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                Padding(
                  padding:EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child:Image.network(
                      (blogItem.cover!=null&&blogItem.cover!="")?'https://www.fishmaple.cn/'+blogItem.cover:"https://www.fishmaple.cn/ueditor_image/20190119/9911cf76e6e44728a414c83bb3473eb0.png",
                    scale: 2.0,
                    width: 80,
                      height:75
                  ),
                ),

                Positioned(


                    child:
                      Container(

                        height: 160,
                        width: width - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width:width-10,
                            child:Padding(

                              padding: EdgeInsets.fromLTRB(85, 22, 0, 0),
                              child:
                              Text(
                                blogItem.title,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),
                              ),
                            ),),
                            Padding(
                              padding: EdgeInsets.fromLTRB(width-60, 55, 0, 0),
                              child: Text(
                                blogItem.author,
                                style: TextStyle(color: Colors.black26),
                              ),
                            )
                          ],
                        ),
                      ),
                ),
                      Positioned(
                        left:width-125,
                        top:5,
                        width:400,
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              readTimestampStr(blogItem.timeline),
                              style: TextStyle(color: Colors.black26),
                            ),
                          ],

                        ),
                      ),

                      /*Container(//分割线
                        height: 50.0,
                        width: 1.0,
                        color: Colors.black12,
                      ),*/
                      /*
                      Expanded(
                       // width:300,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child:
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                      '2018年4月25日',   // style: TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                              ),
                          ],
                          ),
                        ),*/
                Positioned(
                  left:80,
                  top:70,
                  width:width-160,
                  child:
                  Text(blogItem.content.substring(0,blogItem.content.length>50?50:0)+"...")
                ),
                      Positioned(
                        left:width-80,
                        top:20,
                        child:
                        Row(
                            children :<Widget>[
                             Offstage(
                              offstage:(blogItem.isOriginal==null||blogItem.isOriginal==0),
                             child:
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 65, 0, 0),
                              child: Icon( IconData(0xe60c,fontFamily:'appIconFonts'), color: Colors.lightGreen, size: 23),
                            )
                             ),
                             Offstage(
                                 offstage:(blogItem.todo==null||blogItem.todo==0),
                                 child:
                                 Padding(
                                   padding: EdgeInsets.fromLTRB(5,62,0, 0),
                                   child: Icon(IconData(0xe63a,fontFamily:'appIconFonts'), color: Colors.deepPurpleAccent, size: 20),
                                 )
                             )
                            ]
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          /* ClipRRect(
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: Image.asset(
                product.asset,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),*/
        ],
      ),
    );
  }

}



class UserPage extends State<User> {
  String barcode = "";
  String token = null;
  String name = "";

  @override
  void initState() {
    // this.token = widget.token;
    //this.name = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(


    );
  }
}

class NotePage extends State<Note> with TickerProviderStateMixin{
  AnimationController controller;//动画控制器
   Animation<double> animation;

  String notesAni = "-1";
  Tween<double> tween;
  String barcode = "";
  String token = "";
  String name = "";
  String id = "";
  var timer=null;
  static NotesItem notes =
      new NotesItem(title: "", content: "", timestamp: "1543555447000");
  List<NotesItem> notesItems = [notes];
  var length = 0;

  @override
  void dispose(){
    if(timer!=null){
      timer.dispose();
    }
    if(controller!=null){
      controller.dispose();
    }

    super.dispose();

  }
  startAnimtaion(NotesItem notes) {
    print(controller.value);
    if(notesAni==notes.id){
      controller.reverse();
      timer = new Timer(const Duration(milliseconds: 500), () {
        setState(() {
          notesAni="-1";
          // update the text
        });
      });
    }else {
      notesAni = notes.id;
      controller.forward(from: 0.0);
    }

  }
  stopAnimtaion(NotesItem notes) {
    print(controller.value);
    //notesAni = notes.id;
    controller.reverse();
    timer = new Timer(const Duration(milliseconds: 500), () {
      setState(() {
        notesAni="-1";
        // update the text
      });
    });

  }
/*
  Future getUserMessage() async{
    var httpClient = new HttpClient();
    String httpResult = "";
    try {
      var request = await httpClient
          .getUrl(Uri.parse("https://www.fishmaple.cn/api/m/who"));
      request.headers.contentType =
      new ContentType("application", "json", charset: "utf-8");
      request.write(json.encode({"token": token}));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonStr = await response.transform(utf8.decoder).join();
        var map = json.decode(jsonStr);
        this.user['name'] = map['name'].toString();
        this.user['id'] = map['id'].toString();
      } else {
        httpResult = '业务逻辑出现错误，请联系管理员 ${response.statusCode}';
      }
    } catch (exception) {
      httpResult = '服务器异常，请联系管理员';
    }
  }
*/

  Future<String> dbInitgetNotes(BuildContext context) async{
    // Get a location using getfsPath
    Directory documentDic = await getApplicationDocumentsDirectory();
    String path = documentDic.path+"/fish.db";
    // 创建数据库
    Database database = await openDatabase(path, version: 3);
    List<Map> notesLTemp=await database.rawQuery('SELECT *  FROM notes where uid = "'+id+'"');
    notesItems = notesLTemp.map((m) => new NotesItem.fromJson(m)).toList();

    setState(() {});
    print("------------------------------------------------------------------------------");

  }


  Future getUserNotes() async {

    var httpClient = new HttpClient();
    String httpResult = "";

    var request = await httpClient.getUrl(Uri.parse(
        "https://www.fishmaple.cn/api/m/notes?uid=" + id + "&token=" + token));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var jsonStr = await response.transform(utf8.decoder).join();

      Map responseJson = json.decode(jsonStr);
      if (responseJson['msg'] == "SUCCESS") {
        List listJson = responseJson['data'];
        notesItems = listJson.map((m) => new NotesItem.fromJson(m)).toList();

        setState(() {});
      } else {
        httpResult = responseJson["msg"];
      }
    } else {
      httpResult = '业务逻辑出现错误，请联系管理员 ${response.statusCode}';
    }
  }

  @override
  void initState() {
    super.initState();
    /*创建动画控制类对象*/
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500 ));
    /*创建补间对象*/
   /*animation = new Tween<double>(begin: 0.0, end: 1).animate(controller)*/
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeOut)
      ..addListener(() {
        setState(() {


          // the state that has changed here is the animation object’s value
        });
      });
    this.id = widget.id;
    this.token = widget.token;

    this.name = widget.name;
    if(token!="0"){
      getUserNotes();

    } else{
      dbInitgetNotes(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
        slivers: <Widget>[
         /* SliverAppBar(
             actions: <Widget>[
              _buildAction(),
            ],
            //title: Text('SliverAppBar'),
            backgroundColor: Theme.of(context).accentColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('images/012.png', fit: BoxFit.cover),
            ),
            floating: true,
            snap: true,
            primary: false,
            //pinned: pinned,
          ),*/
          /* SliverGrid(
         gridDelegate:
         SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 0.0,
           crossAxisSpacing: 0,

         ),
        delegate: SliverChildBuilderDelegate(

              (BuildContext context, int index) {
            return _buildItem2(context, notesItems[index]);
          },
          childCount: notesItems.length,
        ),
      ),*/
          SliverFixedExtentList(
            itemExtent: 65.0,
            delegate: SliverChildListDelegate(
              notesItems.length>0?(notesItems.map((notesItem) {
                return _buildItem(notesItem);
              }).toList()):[Text("暂时没有笔记哦 赶快添加一篇吧！")],
            ),
          ),
        ],

    );
  }

 Future deleteOneNotesLocate(NotesItem notes) async{
   Directory documentDic = await getApplicationDocumentsDirectory();
   String path = documentDic.path+"/fish.db";
// 创建数据库
   Database database = await openDatabase(path, version: 3);
   await database.rawDelete('DELETE FROM notes WHERE id = "${notes.id}"');
   print(notes.id);
   dbInitgetNotes(context);
   }
  Future deleteOneNotesOnline(NotesItem notes) async{
    Directory documentDic = await getApplicationDocumentsDirectory();
    String path = documentDic.path+"/fish.db";
// 创建数据库
    Database database = await openDatabase(path, version: 3);
    var count = await database.rawDelete('DELETE FROM notes WHERE id = "${notes.id}"');
    getUserNotes();
  }



  Widget _buildItem(NotesItem notes) {
    var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    if(notes.title==""){
      return new
          Stack
        (
          children:<Widget>[
          Container(

              child:

      Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),child:
      SpinKitPouringHourglass (
        color: Colors.lightBlue,
        size: 50.0,
      ),)),
      Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
      child:Center(child:Text("精彩加载中",style:TextStyle(fontSize: 20)))
      )
      ]);
    }
    return

      new Stack(
        children:<Widget>[
          Positioned(
            left:(notes.id==notesAni)?width-180*animation.value:width,
            child:Container(
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[SizedBox(width: 50,child:
                  Container(margin:EdgeInsets.only(top:10),child:
                  RotationTransition(//旋转动画
                      turns: animation,
                      child: RaisedButton(
                    padding: EdgeInsets.all(13),
                     shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)), side: BorderSide(color: Color(0xFFFFFFFF), style: BorderStyle.solid, width: 0)),
                     color: Colors.lightBlue,
                    textColor: Colors.white,
                     splashColor: Colors.blueGrey,
                      onPressed: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new NotesEdit(token:token,name:name,uid:widget.id,type:notes.type,notes:notes))
                        );},
                      elevation: 1.0,
                      child: Icon(Icons.edit)
                  )),),),
                  SizedBox(width: 8),
                SizedBox(width: 50,child: Container(margin:EdgeInsets.only(top:10),child: RotationTransition(//旋转动画
                    turns: animation,
                    child: RaisedButton(
                      padding: EdgeInsets.all(13),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)), side: BorderSide(color: Color(0xFFFFFFFF), style: BorderStyle.solid, width: 0)),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                                title: new Text("提示"),
                                content: new Text("确定删除笔记 ${notes.title}?"),
                                actions:<Widget>[
                                  new FlatButton(child:new Text("取消",style:TextStyle(color: Colors.grey)), onPressed: (){
                                    Navigator.of(context).pop();
                                  },),
                                  new FlatButton(child:new Text("确定"), onPressed: (){
                                    if(token=="0"){ //本地
                                      deleteOneNotesLocate(notes);
                                    }else{
                                      deleteOneNotesOnline(notes);
                                    }
                                    Fluttertoast.showToast(
                                        msg: "删除成功",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        //backgroundColor: Colors.grey,
                                        textColor: Colors.black
                                    );
                                    Navigator.of(context).pop();
                                  },)
                                ]
                            ));

                      },
                      //elevation: 10.0,
                      child: Icon(Icons.delete)
                  )))),
                  SizedBox(width: 8),
                SizedBox(width: 50,child: Container(margin:EdgeInsets.only(top:10),child: RotationTransition(//旋转动画
                    turns: animation,
                    child: RaisedButton(
                      padding: EdgeInsets.all(13),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)), side: BorderSide(color: Color(0xFFFFFFFF), style: BorderStyle.solid, width: 0)),
                      color: Colors.orangeAccent,
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: (){
                        Fluttertoast.showToast(
                            msg: "暂未开放",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            //backgroundColor: Colors.grey,
                            textColor: Colors.black
                        );
                      },
                      //elevation: 10.0,
                      child: Icon(Icons.share)
                  ))))
                  ],
                )
            )
          ),
      Container(
      margin: EdgeInsets.fromLTRB(10.0, 0, (notes.id==notesAni)?10+animation.value*180:10, 0),
      child: Stack(
        //alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Positioned(
              left: 5.0,

                child: GestureDetector(
                  onLongPress: (){
                      startAnimtaion(notes);
                      },
                  onTap: () {
                    stopAnimtaion(notes);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          pageBuilder: (context, _, __) {
                            return NotesDetailPage(
                        notes: notes,
                      );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: FadeTransition(
                                opacity: Tween(begin: 0.5, end: 1.0)
                                    .animate(animation),
                                child: child,
                              ),
                            );
                          }),
                    );
                  },

                  child:
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child:
                  Card(

                  child: /*Container(
                    margin: EdgeInsets.only(left: 10.0),
                    height: 200,
                    child:*/
                  Stack(
                    //alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[

                      Container(
                        height: 100,
                        width: width - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                          child:
                          Text(
                              notes.title,
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),
                            ),
                        ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                "",
                                style: TextStyle(color: Colors.black26),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left:width-140,
                        width:400,
                        child:
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              readTimestampStr(notes.timestamp),
                              style: TextStyle(color: Colors.black26),
                            ),
                          ],

                      ),
                      ),
                      Positioned(
                        left:width-60,
                        top:35,
                        child:
                        Container(
                          child:
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: notes.getTypeIcon(null),
                              )
                        ),
                      ),
                      /*Container(//分割线
                        height: 50.0,
                        width: 1.0,
                        color: Colors.black12,
                      ),*/
                      /*
                      Expanded(
                       // width:300,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child:
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                      '2018年4月25日',   // style: TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                              ),
                          ],
                          ),
                        ),*/
                    ]),
                  ),),
                ),
              ),
          /* ClipRRect(
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: Image.asset(
                product.asset,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),*/
        ],
      ),
    ),]);
  }

  /* _getListData() {
    List<Widget> widgets = [];
    {


        widgets.add(
          new Center(
            child: new SliverAppBar(
              title: Text('SliverAppBar'),
              backgroundColor: Theme.of(context).accentColor,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('images/012.png', fit: BoxFit.cover),
              ),
              // floating: floating,
              // snap: snap,
              // pinned: pinned,
            )
            ,
          ),
        );
      }
    }
    return widgets;
  }
*/

}

class ToQrPage extends State<Qr> {
  String barcode = "";
  String token = "";
  String name = "";

  @override
  void initState() {
    this.token = widget.token;
    this.name = widget.name;
    super.initState();
  }

  Future tokenLogin() async {
    var httpClient = new HttpClient();
    String httpResult = "";
    try {
      var request = await httpClient
          .postUrl(Uri.parse("https://www.fishmaple.cn/api/tokenLogin"));
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(json.encode({'uuid': barcode, "token": token}));
      var response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        String text = await response.transform(utf8.decoder).join();

        if (text == "SUCCESS") {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) =>
                      new Trans(token: httpResult, name: name)),
              (route) => route == null);
          return;
        }
      } else {
        httpResult = '业务逻辑出现错误，请联系管理员 ${response.statusCode}';
      }
    } catch (exception) {
      httpResult = '服务器异常，请联系管理员';
    }
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new Login(loginState: "0")),
        (route) => route == null);
  }

  Future scan() async {
    print(token);
    try {
      this.barcode = await BarcodeScanner.scan();
      setState(() {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text('登录确认'),
                ),
                body: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Text("请确认登录 当前用户 $name",
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                        child: RaisedButton(
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            splashColor: Colors.blueGrey,
                            onPressed: tokenLogin,
                            elevation: 10.0,
                            child: const Text('确认登录')),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          return this.barcode = '使用此功能前需获取相机权限! ';
        });
      } else {
        setState(() {
          return this.barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() => this.barcode = 'error');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Text(readTimestamp() + '   $name',
                  style: new TextStyle(
                    fontFamily: "Ewert",
                    fontSize: 22.0,
                  ),
                  textAlign: TextAlign.center)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: RaisedButton(
                disabledColor: const Color(0xff888888),
                disabledTextColor: Colors.white,
                color: Colors.lightBlue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: (token=="0")?null:scan,
                child: Text((token=="0")?"匿名状态不可用":'扫码登录')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              "目前仅提供扫码登录功能",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

String readRealTimestampStr(String timestamp) {
  return DateUtil.getDateStrByDateTime(DateTime.fromMicrosecondsSinceEpoch((int.parse(timestamp)+28800)*1000000),format: DateFormat.ZH_NORMAL);
}

String readTimestampStr(String timestamp) {
  var date = new DateTime.now();
  var timeline = DateTime.fromMicrosecondsSinceEpoch(
          (int.parse(timestamp) + 28800) * 1000000)
      .toUtc();
  var daysnow = DateUtil.getDayOfYear(date);
  var days = DateUtil.getDayOfYear(timeline);
  //var timeline = int.parse(timestamp) ;
  //var timeline = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp)*1000)

  if (daysnow == days) {
    return "             "+DateUtil.getDateStrByDateTime(timeline,
        format: DateFormat.HOUR_MINUTE_SECOND);
  } else if (daysnow == days + 1) {
    return "        昨天 " +
        DateUtil.getDateStrByDateTime(timeline, format: DateFormat.HOUR_MINUTE);
  } else if(timeline.year==date.year) {
    return "   "+timeline.month.toString() + "月" + timeline.day.toString() + "日 " +
        DateUtil.getDateStrByDateTime(timeline, format: DateFormat.HOUR_MINUTE);
  }else {
    return timeline.year.toString()+"年"+timeline.month.toString()+"月"+timeline.day.toString()+"日 ";
  }
    return DateUtil.getDateStrByDateTime(timeline,
        format: DateFormat.ZH_MONTH_DAY_HOUR_MINUTE);
  }

  /* print( DateUtil.getDateStrByDateTime(new DateTime.now(),format: DateFormat.YEAR_MONTH_DAY));
  print( new DateTime.now().millisecondsSinceEpoch);

  print(DateTime.fromMicrosecondsSinceEpoch(1543555447132000));
  print(DateUtil.getDateStrByDateTime(DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp)*1000),format: DateFormat.ZH_NORMAL));
  return DateUtil.getDateStrByDateTime(DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp)*1000000),format: DateFormat.ZH_NORMAL);
*/

