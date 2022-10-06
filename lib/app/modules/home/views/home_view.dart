import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/controllers/page_index_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final pageC = Get.find<PageIndexController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['name']}&background=random&color=fff&bold=true";

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 75,
                        height: 75,
                        color: Colors.grey[200],
                        // child: Center(child: Text("X")),
                        child: Image.network(
                          user["profileImg"] != null
                              ? user["profileImg"] != ""
                                  ? user["profileImg"]
                                  : defaultImage
                              : defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Icon(
                              user['position'] != null
                                  ? Icons.place
                                  : Icons.location_disabled,
                              size: 15,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Container(
                              child: Text(
                                user['address'] != null
                                    ? "${user['address']}"
                                    : "Lokasi Non Aktif",
                                textAlign: TextAlign.start,
                              ),
                              width: 200,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['job'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        user['nip'],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Masuk"),
                          Text("-"),
                        ],
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.black,
                      ),
                      Column(
                        children: [
                          Text("Keluar"),
                          Text("-"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last 5 days",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                      child: Text("See More"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamLastPresensi(),
                    builder: (context, snapshotPresence) {
                      if (snapshotPresence.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshotPresence.data?.docs.length == 0 ||
                          snapshotPresence.data == null) {
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                                "Belum ada histori absen sejak 5 hari yang lalu"),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshotPresence.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshotPresence
                              .data!.docs.reversed
                              .toList()[index]
                              .data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber,
                              child: InkWell(
                                onTap: () =>
                                    Get.toNamed(Routes.DETAIL_PRESENSI),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  // margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.amber,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Masuk",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data['masuk']!['date'] == null
                                            ? "- - -"
                                            : "${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Keluar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Text(
                                          //   "${DateFormat.yMMMEd().format(DateTime.now())}",
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                        ],
                                      ),
                                      Text(
                                        data['keluar']?['date'] == null
                                            ? "- - -"
                                            : "${DateFormat.jms().format(DateTime.parse(data['keluar']?['date']))}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat database user."),
            );
          }
        },
      ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () async {
      //       if (controller.isLoading.isFalse) {
      //         controller.isLoading.value = true;
      //         await FirebaseAuth.instance.signOut();
      //         controller.isLoading.value = false;
      //         Get.offAllNamed(Routes.LOGIN);
      //       }
      //     },
      //     child: controller.isLoading.isFalse
      //         ? Icon(Icons.logout)
      //         : CircularProgressIndicator(),
      //   ),
      // ),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Absen'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
