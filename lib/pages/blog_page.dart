import 'package:flutter/material.dart';
import 'package:fish/obj/product.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fish/pages/main_page.dart';
import 'package:fish/main.dart';
import 'dart:convert';
import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';

class BlogDetail extends StatefulWidget {
  final BlogItem blog; //存储过来的token
  BlogDetail({Key key, this.blog}) : super(key: key);
  createState() => new BlogDetailPage();
}

class BlogDetailPage extends State<BlogDetail> {

  var data={"title":"","timeline":"","author":"","content":""};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlog();

  }
  TextEditingController nameController = TextEditingController();
  TextEditingController psw2Controller = TextEditingController();
  TextEditingController pswController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.blog.title),
      ),
      body:CustomScrollView(
        //tag: widget.notes.timestamp,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child:
              Container(
                  width:width-25,
                  padding: EdgeInsets.only(left: 15.0, right:0),
                  child: Row(
                    children: <Widget>[
                      /*Card(
                child: ClipRRect(
                  child: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Image.asset(
                      widget.product.asset,
                      fit: BoxFit.cover,
                    ),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),*/
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child:
                                Text(
                                  widget.blog.title,
                                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text(
                                      widget.blog.author),
                                  ),
                                  Text(
                                    readRealTimestampStr(widget.blog.timeline),
                                    style: null,
                                  )
                                ],
                              ),
                              Padding(
                                  padding:EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child:new HtmlView(
                                      data: data['content'],
                                      baseURL: "https://www.fishmaple.cn/", // optional, type String
                                      onLaunchFail: (url) { // optional, type Function
                                        print("launch $url failed");
                                      }),
                              )],
                          ))
                    ],
                  )),
              //pinned: pinned,
            ),

          ]
      )
      /*
      new ListView(
      children:<Widget>[
      new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [//new HtmlTextView(data: data['content']),

       new HtmlView(
             data: data['content'],
             baseURL: "https://www.fishmaple.cn/", // optional, type String
             onLaunchFail: (url) { // optional, type Function
            print("launch $url failed");
            }
      )
        ]
      ),
    )
    ])*/
    );
  }

  Future getBlog() async {
    var httpClient = new HttpClient();
        var request = await httpClient
            .getUrl(Uri.parse("https://www.fishmaple.cn/api/blog/detail?bid="+widget.blog.id+"&appAbled=true"));

        request.headers.contentType =
        new ContentType("application", "json", charset: "utf-8");

        var response = await request.close();

          var jsonStr = await response.transform(utf8.decoder).join();
          var map = json.decode(jsonStr);
          this.data['content'] = map['content'].toString();
          this.data['timeline'] = map['timeline'].toString();
          this.data['outLine'] = map['outLine'].toString();
          this.data['title'] = map['title'].toString();
          //this.data['content'] = data['content'].replaceAll("&nbsp;", " ");
    if (!mounted) return;
    setState(() {
      // update the text
      print("");
    });

  }
}