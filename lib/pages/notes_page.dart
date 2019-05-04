import 'package:flutter/material.dart';
import 'package:fish/obj/product.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fish/obj/product_detail.dart';
import 'package:fish/main.dart';
import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotesEdit extends StatefulWidget {
  final String token; //存储过来的token
  final String name;
  final String uid;
  String type;
  NotesItem notes;

  NotesEdit({Key key, this.token, this.name, this.uid, this.type, this.notes})
      : super(key: key);
  createState() => new NotesEditPage();
}

//笔记详情页面
class NotesEditPage extends State<NotesEdit> {
TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String text = "";
  String value;
  var color = Colors.red;
  var focus=false;
  @override
  void initState() {
    _focusNode.addListener(_focusNodeListener);
    _focusNode2.addListener(_focusNode2Listener);
    titleController.text=(widget.notes.title==null)?"":widget.notes.title;
    contentController.text=(widget.notes.content==null)?"":widget.notes.content;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose(){
    _focusNode.removeListener(_focusNodeListener);  // 页面消失时必须取消这个listener！！
    _focusNode2.removeListener(_focusNodeListener);  // 页面消失时必须取消这个listener！！
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {  // 用async的方式实现这个listener
    print(12);
    if (_focusNode.hasFocus){
      this.focus=true;
    } else {
      this.focus=false;
    }
    setState(() {

    });
  }
  Future<Null> _focusNode2Listener() async {  // 用async的方式实现这个listener
    print(123);
    if (_focusNode2.hasFocus){
      this.focus=true;
    } else {
      this.focus=false;
    }
    setState(() {

    });
  }

  showPickerIcons(BuildContext context) {
    new Picker(
      selecteds: [int.parse(widget.type)-1],
      adapter: PickerDataAdapter(
          data: [
        new PickerItem(
            text: Container(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(IconData(0xe605, fontFamily: 'appIconFonts'),
                          color: Colors.green, size: 25),
                      Text("      便利贴", style: TextStyle(fontSize: 20))
                    ])),
            value:1),
        new PickerItem(
            text: Container(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.access_alarm,
                          color: Colors.redAccent, size: 25),
                      Text("      日程", style: TextStyle(fontSize: 20))
                    ])),
            value: 2),
        new PickerItem(
            text: Container(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(IconData(0xe622, fontFamily: 'appIconFonts'),
                          color: Colors.lightBlue, size: 25),
                      Text("      备忘录", style: TextStyle(fontSize: 20))
                    ])),
            value: 3),
        new PickerItem(
            text: Container(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(IconData(0xe624, fontFamily: 'appIconFonts'),
                          color: Colors.orangeAccent, size: 25),
                      Text("      时间胶囊", style: TextStyle(fontSize: 20))
                    ])),
            value: 4),
      ]),
      title: new Text("笔记分类"),
      onSelect: (Picker picker, int i, List value) {
        print(value[0]);
        widget.type = (value[0]+1).toString();
        if (!mounted) return;
        setState(() {});
      },
      onConfirm: (Picker picker, List value) {
        print(value[0]);
        widget.type = (value[0]+1).toString();
        if (!mounted) return;
        setState(() {});
      },
    ).show(_scaffoldKey.currentState);
  }

  saveNotes() async{
    print(widget.uid+"as1d6sa5d4");
      if(widget.uid=="0"||widget.uid==""){  //匿名
        print("保存");
        if(titleController.text==""||titleController.text==null||contentController.text==null||contentController.text==""){
          Fluttertoast.showToast(
              msg: "标题和正文不能为空！",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              //backgroundColor: Colors.grey,
              textColor: Colors.black
          );
          return;
        }
        Directory documentDic = await getApplicationDocumentsDirectory();

        String path = documentDic.path+"/fish.db";
        // 创建数据库

        Database database = await openDatabase(path, version: 3);
        List<Map> notesLTemp=await database.rawQuery('SELECT *  FROM notes where id = '+widget.notes.id);

        if(notesLTemp.length>0)
        {
          await database.rawUpdate(
              'Update `notes` SET title="${titleController
                  .text}",content="${contentController.text}",type="${widget
                  .type}",timestamp="${(new DateTime.now()
                  .millisecondsSinceEpoch~/1000)}" WHERE id=${widget.notes.id}');
        }else{ await database.rawInsert(
              'INSERT INTO notes(uid,type,title,content,timestamp,param0,param1) VALUES("${widget.uid}", "${widget.type}","${titleController.text}","${contentController.text}","${(new DateTime.now()
                  .millisecondsSinceEpoch~/1000)}","1",""  )');
        }
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (context) =>
                new Main(token: widget.token, name:widget.name,id :widget.uid)),
                (route) => route == null);

    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.notes==null){
      widget.notes=new NotesItem(id:"-1",uid:widget.uid,type:widget.type,timestamp:"",title: "",content: "",param0: "",param1: "");
    }// TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('登录确认'),
            actions:[
        new Container(

        child:Row(children:<Widget>[
          FlatButton(
            child:Row(children:<Widget>[
              Icon(Icons.report
                ,color: Colors.white,),
            ]),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                     // title: new Text("提示"),
                      content: new Text("便利贴：最简洁的记录形式，您可以附加您喜欢的涂鸦或是是图片记录\n"
                          "日程：与日历同步记录，用于标记一个你已经做过或是将要去做的事情\n"
                          "备忘录：最常见的记录形式，用于记录长文本\n"
                          "界面将会有所不同"),
                      actions:<Widget>[
                        new FlatButton(child:new Text("确定"), onPressed: (){
                          Navigator.of(context).pop();
                        },),
                      ]
                  ));
              //_getPopupMenu(context);
            },),
        FlatButton(
        child:Row(children:<Widget>[
        Icon(Icons.save,color: Colors.white,),
        SizedBox(width: 5)
        ,Text("保存",style:TextStyle(color:Colors.white,fontSize: 18))

        ]),
    onPressed: (){
    saveNotes();
    //_getPopupMenu(context);
    },),

        ])

    )]
        ),
        body:  GestureDetector(behavior: HitTestBehavior.opaque,
            onTap: (){
              _focusNode.unfocus();
            },
            child:Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Offstage(
              offstage:(focus),child:Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showPickerIcons(context);
                    },
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text("类型：",style:TextStyle(fontSize: 25)),
                      widget.notes.getTypeIconBig(widget.type),
                      Text(widget.notes.getTypeText(widget.type),style:TextStyle(fontSize: 25))
                    ]),
                  ))),
              Padding(
                  padding: EdgeInsets.fromLTRB(30,20,30,0),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border:UnderlineInputBorder() ,
                      hintText: '请输入标题',
                      labelText: '标题',
                      prefixIcon: Icon(Icons.title),
                    ),
                    focusNode: _focusNode2,
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(30,0,30,0),
                  child:  Container(
                      height:200,child:ListView(children:<Widget>[
                    TextField(
                      maxLines: 20,
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: '文本',
                      ),
                    focusNode: _focusNode,
                    )]))
              )
  ])));
  }
}
