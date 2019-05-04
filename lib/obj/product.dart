import 'package:flutter/material.dart';
import 'product_detail.dart';

class NotesItem {
  Icon getTypeIcon(String i){
    var icon=null;
    var typeTemp;
    if(i!=null){
      typeTemp=i;
    }else{
      typeTemp=this.type;
    }
    switch(typeTemp)
    {
      case '1':
        icon=  Icon(IconData(0xe605,fontFamily:'appIconFonts'),color: Colors.green, size: 20);break;
      case '2':
        icon= Icon(Icons.access_alarm,color:Colors.redAccent, size: 23);break;
      case '3':
        icon= Icon(IconData(0xe622,fontFamily:'appIconFonts'),color: Colors.lightBlue, size: 19);break;
      case '4':
        icon= Icon(IconData(0xe624,fontFamily:'appIconFonts'),color: Colors.orangeAccent, size: 21);break;
      default:
        icon= Icon(Icons.accessibility);break;
    }
    return icon;
  }

  Icon getTypeIconBig(String i){
    var icon=null;
    var typeTemp;
    if(i!=null){
      typeTemp=i;
    }else{
      typeTemp=this.type;
    }
    switch(typeTemp)
    {
      case '1':
        icon=  Icon(IconData(0xe605,fontFamily:'appIconFonts'),color: Colors.green, size: 27);break;
      case '2':
        icon= Icon(Icons.access_alarm,color:Colors.redAccent, size: 27);break;
      case '3':
        icon= Icon(IconData(0xe622,fontFamily:'appIconFonts'),color: Colors.lightBlue, size: 27);break;
      case '4':
        icon= Icon(IconData(0xe624,fontFamily:'appIconFonts'),color: Colors.orangeAccent, size: 27);break;
      default:
        icon= Icon(Icons.accessibility);break;
    }
    return icon;
  }

  String getTypeText(String i){
    var text=null;
    var typeTemp;
    if(i!=null){
      typeTemp=i;
    }else{
      typeTemp=this.type;
    }
    switch(typeTemp)
    {
      case '1':
        text="便利贴";break;
      case '2':
        text="日程";break;
      case '3':
        text="备忘录";break;
      case '4':
        text="时间胶囊";break;
      default:
        text="便利贴";break;
    }
    return text;
  }

  NotesItem.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'],
        content = json['content'],
        type = json['type'],
        timestamp = json['timestamp'],
        param0 = json['param0'],
        param1 = json['param1'],
        uid = json['uid']
  ;

  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'title': title,
        'content': content,
        'uid': uid,
        'type': type,
        'timestamp': timestamp,
        'param0': param0,
        'param1':param1
      };

   String id;
   String uid;
   String title;
   String content;
   String type;
  String timestamp;
   String param0;
   String param1;


  NotesItem({
    this.id,
    this.uid,
    this.title,
    this.content,
    this.type,
    this.timestamp,
    this.param0,
    this.param1,
  });
}


class BlogItem {

  BlogItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        author = json['author'],
        cover = json['cover'],
        timeline = json['timeline'].toString(),
        todo = json['todo'],
        isOriginal = json['isOriginal']
  ;

  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'title': title,
        'content': content,
        'author': author,
        'cover': cover,
        'timeline':timeline,
        'todo':todo,
        'isOriginal':isOriginal
      };

  final String id;
  final String title;
  final String content;
  final String timeline;
  final String author;
  final String cover;
  final int todo;
  final int isOriginal;


  BlogItem({
    this.id,
    this.title,
    this.content,
    this.timeline,
    this.author,
    this.cover,
    this.todo,
    this.isOriginal
  });
}
/*
final List<NotesItem> notesItems = [
  ProductItem(
      name: 'Bueno Chocolate',
      tag: '1',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Bueno Chocolate',
      tag: '1',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Chocolate with berries',
      tag: '2',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Trumoo Candies',
      tag: '3',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Choco-coko',
      tag: '4',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Chocolate tree',
      tag: '5',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
  ProductItem(
      name: 'Chocolate',
      tag: '6',
      asset: 'images/012.png',
      stock: 1,
      price: 71.0),
];
*/
/*class ProductListPage extends StatefulWidget {
  final String title;

  const ProductListPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductListState();
}

class _ProductListState extends State<ProductListPage> {
  Widget _buildSearch() {
    return Hero(
        tag: 'search',
        child: Card(
          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            height: 45.0,
            child: Center(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black26,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search category',
                            hintStyle: TextStyle(color: Colors.black26)),
                        cursorColor: Theme.of(this.context).accentColor,
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildProduct(ProductItem product) {
    var width = MediaQuery.of(context).size.width;
    return Hero(
      tag: product.tag,
      child: Container(
        height: 120.0,
        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            Positioned(
                left: 20.0,
                child: Card(
                  child: Container(
                    width: width - 15.0 * 2 - 20.0 - 50.0,
                    margin: EdgeInsets.only(left: 50.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.title,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${product.stock} Unit',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60.0,
                          width: 1.0,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '\$${product.price}',
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'PRICE',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ),
                              MaterialButton(
                                height: 30.0,
                                child: Text('BUY'),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                        pageBuilder: (context, _, __) {
                                          return ProductDetailPage(
                                            product: product,
                                          );
                                        },
                                        transitionDuration:
                                        const Duration(milliseconds: 500),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: FadeTransition(
                                              opacity:
                                              Tween(begin: 0.5, end: 1.0)
                                                  .animate(animation),
                                              child: child,
                                            ),
                                          );
                                        }),
                                  );
                                },
                                color: Colors.deepPurpleAccent,
                                textColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            ClipRRect(
              child: SizedBox(
                width: 70.0,
                height: 70.0,
                child: Image.asset(
                  product.asset,
                  fit: BoxFit.cover,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
         // _buildSearch(),
          Expanded(
            child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildProduct(products[index]);
                }),
          )
        ],
      ),
    );
  }
}*/