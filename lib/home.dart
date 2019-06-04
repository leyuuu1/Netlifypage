import 'package:flutter_web/material.dart';
import 'package:demo/utils.dart' as tools;
import 'package:demo/partition.dart';
import 'widget/partitionBox.dart';

class _HomePageState extends State<Home> {
  final _scaffoKey = GlobalKey<ScaffoldState>();
  int _num = 0;
  final _numberInput = TextEditingController();
  Partition p1;
  int scaleRate;
  final menuItem = ["Tips", "About"];
  @override
  initState() {
    super.initState();
    PartitionManager pm = PartitionManager();
    int totalMem = 64;
    scaleRate = 500 ~/ totalMem;
    p1 = pm.addPartition(totalMem);
    //全局分配64M 假数据环节
    p1.alloc(10);
    p1.alloc(20);
    p1.alloc(15);
    p1.remove(10);
  }

  _snakeBarAlert(String) {
    _scaffoKey.currentState.showSnackBar(SnackBar(
      content: Text(String),
      duration: Duration(seconds: 1),
    ));
  }

  _simpleInputAlert(
      {String title: "", String hint: "", String suffix: ""}) async {
    var a = await showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: Text("$title"),
          content: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: _numberInput,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: InputDecoration(
                    suffix: Text("$suffix"),
                    helperText: '$hint',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                _numberInput.text = '';
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Confrim'),
              onPressed: () {
                setState(() {
                  _num = int.parse(_numberInput.text);
                });
                _numberInput.text = '';
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (a ??= false) {
      return Future.value(_num);
    } else {
      return null;
    }
  }

  _showDetailAlert({String title: "INFO", String content: ""}) {
    showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: Text("$title"),
          content: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "$content",
                  maxLines: 3,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor, //强调色
        automaticallyImplyLeading: false,
        elevation: 10.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "Partition Storage Algorithm Demo",
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => menuItem
                .map((item) => PopupMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onSelected: (v) {
              if (v == 'About') {
                _showDetailAlert(
                    content:
                        "Partition Storage Algorithm DEMO\nFlutter_web\nMIT License");
              } else if (v == "Tips") {
                _showDetailAlert(
                    title: "操作提示",
                    content: "右下+按钮分配新空间,右滑方块消除已分配空间.");
              }
            },
            child: Container(
              width: 60.0,
              child: Center(
                child: Text(
                  "···",
                  style: TextStyle(fontSize: 40.0 ,height: .8),
                ),
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme:
            TextTheme(title: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Maxsize:64M"),
          (Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                width: 1.0,
              ))),
              height: p1.size.toDouble() * scaleRate,
              child: Row(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1))),
                    child: SizedBox(
                        width: 50.0,
                        child: Stack(
                          children: p1.list.map((item) {
                            return Positioned(
                              bottom: item.start.toDouble() * scaleRate,
                              right: 10,
                              child: Text("${item.start}"),
                            );
                          }).toList(),
                        )),
                  ),
                  SizedBox(
                    width: 200.0,
                    child: Stack(
                      children: p1.list.map((item) {
                        return Positioned(
                          left: 0,
                          bottom: item.start.toDouble() * scaleRate,
                          child: GestureDetector(
                            child: PartitionBox(item.size, scaleRate),
                            onHorizontalDragEnd: (DragEndDetails d) {
                              if (d.primaryVelocity > 100) {
                                setState(() {
                                  p1.remove(item.start);
                                });
                              }
                            },
                            onTap: () {
                              _showDetailAlert(
                                  content:
                                      ' 分块占据空间${item.start}-${item.start + item.size}M\n 分区总大小${p1.size}M\n 所占空间比例${item.size * 100 ~/ p1.size}%');
                            },
                            onLongPress: () {},
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add',
        child: Center(
          child: Text(
            "+",
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
        onPressed: () {
          _addPartitionHandler();
        },
      ),
    );
  }

  void _addPartitionHandler() async {
    var a =
        await _simpleInputAlert(title: "分配内存", hint: "请输入要分配的内存数", suffix: 'M');
    if (a != null) {
      var result = p1.alloc(a);
      if (!result) {
        _snakeBarAlert("分配失败,无足够空间");
      } else {
        _snakeBarAlert("已分配内存${a}M");
      }
    }
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}
