import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/firstProvider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var fetchPro = Provider.of<FirstProviderClass>(context, listen: true);

    print("object");

    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: fetchPro.controller,
                  decoration:
                  InputDecoration(filled: true, fillColor: Colors.white),
                ),
              ),
              IconButton(
                  onPressed: () {
                    fetchPro.checkInterNet(fetchPro.controller.text,context);

                  },
                  icon: Icon(Icons.search))
            ],
          )),
      body: ListView(
        children: [
          DefaultTabController(
            length: 2,
            child: TabBar(
              controller: _tabController,
              overlayColor: MaterialStateProperty.all(Colors.blue),
              labelColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text("Profile"),
                ),
                Tab(
                  child: Text("Repository"),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(controller: _tabController, children: [
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: fetchPro.response?.data != null
                      ? ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      child: Image.network(
                          fetchPro.response!.data["avatar_url"]),
                    ),
                    title: Text(fetchPro.response!.data["login"] ?? ""),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Number of Repos:${fetchPro.response!.data["public_repos"] ?? ""}"),
                        SizedBox(
                          height: 5,
                        ),
                        Text(fetchPro.response!.data["bio"] ?? "")
                      ],
                    ),
                  )
                      :SizedBox()),
              //

              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: fetchPro.responseRepo?.data != null
                      ? Column(
                      children: fetchPro.responseRepo!.data.map((e) =>
                          ListTile(
                            focusColor: Colors.blue,
                            onTap: ()async{
                              launch(
                                e["html_url"].toString(),
                                // forceSafariVC: true,
                              );
                            },
                            title: Text("Repo Name:"+e["name"]),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "Repos Link:${e["html_url"] ?? "0"}"),

                              ],
                            ),
                          ),
                      ).toList().cast<Widget>()

                  )
                      : SizedBox()),
            ]),
          ),
        ],
      ),
    );
  }
}
