import 'dart:convert';

import 'package:fltr_pdascan/Components/cust_drawer.dart';
import 'package:fltr_pdascan/models/deliverynote_type.dart';
import 'package:fltr_pdascan/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeliverynotesPage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _DeliverynotesPageState createState() => _DeliverynotesPageState();
}

class _DeliverynotesPageState extends State<DeliverynotesPage> {
  List<DeliverynoteType> deliverynotes = [];

  @override
  void initState() {
    super.initState();
    _getAllDeliveryNotes();
  }

  Future<void> _getAllDeliveryNotes() async {
    await http.get("http://13.90.214.197:8089/delivery-notes").then((response) {
      var data = json.decode(response.body);
      print(data);
      setState(() {
        for (Map i in data) {
          deliverynotes.add(DeliverynoteType.fromJson(i));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: CustDrawer(),
        appBar: AppBar(
          title: Text(
            'اذون الصرف',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                  ],
                ),
              ),
              Container(
                child: SizedBox(
                  height: 400,
                  child: ListView.builder(
                      itemCount: deliverynotes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: HexColor(
                              deliverynotes[index].deliverynoteStatus.hexcode),
                          child: ListTile(
                              title: Text("رقم الاذن " +
                                  deliverynotes[index].serial.toString()),
                              subtitle: Text(deliverynotes[index]
                                  .deliverynoteStatus
                                  .statusArname),
                              trailing: Icon(Icons.more_vert),
                              onTap: () => Get.toNamed('deliverynote_details',
                                  arguments: deliverynotes[index])),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}