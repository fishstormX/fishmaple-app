import 'package:flutter/material.dart';
import 'product.dart';
import 'package:fish/pages/main_page.dart';

class NotesDetailPage extends StatefulWidget {
  final NotesItem notes;

  const NotesDetailPage({Key key, this.notes}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotesDetailState();
}

class _NotesDetailState extends State<NotesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notes.title),
      ),
      body:
        _buildNotesItem(),

    );
  }

  Widget _buildNotesItem() {
    var width = MediaQuery.of(context).size.width;
    return CustomScrollView(
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
                               widget.notes.title,
                               style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),
                             ),
                           ),
                           Row(
                             children: <Widget>[
                               Expanded(child: Text(
                                   ''),
                               ),
                               Text(
                                 readRealTimestampStr(widget.notes.timestamp),
                                 style: null,
                               )
                             ],
                           ),
                           Padding(
                               padding:EdgeInsets.fromLTRB(0, 20, 0, 0),
                               child:Text(
                                 widget.notes.content,
                                 style: TextStyle(fontSize: 18,letterSpacing: 3,height: 1.2),
                               )),
                         ],
                       ))
                 ],
               )),
            //pinned: pinned,
          ),

          ]
    );
  }
}