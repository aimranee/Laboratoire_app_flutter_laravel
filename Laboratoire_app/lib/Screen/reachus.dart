import 'package:get/get.dart';
import 'package:laboratoire_app/Service/DrProfileService.dart';
import 'package:laboratoire_app/utilities/color.dart';
import 'package:laboratoire_app/utilities/decoration.dart';
import 'package:laboratoire_app/utilities/style.dart';
import 'package:laboratoire_app/widgets/appbarsWidget.dart';
import 'package:laboratoire_app/widgets/custom_drawer.dart';
import 'package:laboratoire_app/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReachUS extends StatefulWidget {
  ReachUS({Key key}) : super(key: key);

  @override
  _ReachUSState createState() => _ReachUSState();
}

class _ReachUSState extends State<ReachUS> {
  bool isConn = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer : CustomDrawer(isConn: isConn),
      body: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          CAppBarWidget(title: "Reach us", isConn: isConn),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: IBoxDecoration.upperBoxDecoration(),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    // child: Container(
                    //     color: Colors.grey,
                    //     child: Center(child: Text("Your asset"))),
                    //delete the just above code [ child container ] and uncomment the below code and set your assets
                    child: Image.asset(
                      'assets/images/map3.png',
                      fit: BoxFit.cover,
                    ))),
          ),
          Positioned(
            bottom: -4,
            left: 5,
            right: 5,
            child: Container(
                height: 160,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "We are here...",
                          style: kPageTitleStyle,
                        ),
                        FutureBuilder(
                            // future: DrProfileService
                            //     .getData(), //fetch doctors profile details like name, profileImage, description etc
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.length.isEmpty
                                    ? const Text("")
                                    : Text(snapshot.data[0].address,
                                        style: const TextStyle(
                                          fontFamily: 'OpenSans-SemiBold',
                                          fontSize: 12.0,
                                        ));
                              } else if (snapshot.hasError) {
                                return const Text(
                                    "");
                              } else {
                                return LoadingIndicatorWidget();
                              }
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: btnColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            child: const Center(
                                child: Text("Contact Us",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/ContactUsPage');
                            })
                      ],
                    ),
                  ),
                )),
          ),
          Positioned(
            right: 25,
            bottom: 125,
            child: GestureDetector(
              onTap: () async {
                final latitude =
                    "22.884102903166873"; // take clinic latitude from google map
                final longitude =
                    " 87.78462257438564"; //take clinic longitude from google map
                final _url =
                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                await canLaunch(_url)
                    ? await launch(_url)
                    : throw 'Could not launch $_url'; //launch google map
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: btnColor,
                child: Icon(
                  Icons.near_me,
                  color: appBarIconColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
