import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


import '../main.dart';
import '../model/script.dart';

class ScriptDetailScreen extends StatefulWidget {
  final Script script;

  const ScriptDetailScreen({super.key, required this.script});

  @override
  State<ScriptDetailScreen> createState() => _ScriptDetailScreenState();
}

class _ScriptDetailScreenState extends State<ScriptDetailScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with the first video URL from the list
    if (widget.script.videoUrls != null && widget.script.videoUrls!.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.script.videoUrls!.first)
        ..initialize().then((_) {
          setState(() {}); // Ensure the UI is updated after initialization
          _videoController!.play(); // Automatically play the video
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose of the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.script.title}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 320,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Center(
                      child: _videoController != null && _videoController!.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                          : CircularProgressIndicator(), // Show loading indicator while video initializes
                    ),
                    // decoration: BoxDecoration(
                    //
                    //   image: DecorationImage(
                    //     image: NetworkImage(
                    //       widget.script.videoUrls ?? "",
                    //     ),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // child: Center(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //   ),
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.script.title ?? "제목",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text("수정하기"),
                                    onTap: () {
                                      // int reviewScore = 0;
                                      // showDialog(
                                      //   context: context,
                                      //   // 리뷰 등록을 누르면 다른 버튼을 눌러도 나가지지 않는다.
                                      //   barrierDismissible: false,
                                      //   builder: (context) {
                                      //     TextEditingController reviewTec =
                                      //     TextEditingController();
                                      //     return StatefulBuilder(
                                      //       builder: (context, setState) {
                                      //         return AlertDialog(
                                      //           title: Text("수정하기"),
                                      //           content: Column(
                                      //             mainAxisSize:
                                      //             MainAxisSize.min,
                                      //             children: [
                                      //               TextField(
                                      //                 controller: reviewTec,
                                      //               ),
                                      //               Row(
                                      //                 children: List.generate(
                                      //                   5,
                                      //                       (index) =>
                                      //                       IconButton(
                                      //                         onPressed: () {
                                      //                           setState(() =>
                                      //                           reviewScore =
                                      //                               index);
                                      //                         },
                                      //                         icon: Icon(
                                      //                           Icons.star,
                                      //                           color: index <=
                                      //                               reviewScore
                                      //                               ? Colors
                                      //                               .orange
                                      //                               : Colors
                                      //                               .grey,
                                      //                         ),
                                      //                       ),
                                      //                 ),
                                      //               )
                                      //             ],
                                      //           ),
                                      //           actions: [
                                      //             TextButton(
                                      //               onPressed: () =>
                                      //                   Navigator.of(context)
                                      //                       .pop(),
                                      //               child: Text("취소"),
                                      //             ),
                                      //             TextButton(
                                      //               onPressed: () async {
                                      //                 //final db = FirebaseFirestore.instance;
                                      //                 //final user = db.collection("users").doc("")
                                      //                 await FirebaseFirestore
                                      //                     .instance
                                      //                     .collection(
                                      //                     "products")
                                      //                     .doc(
                                      //                     "${widget.script
                                      //                         .docId}")
                                      //                     .collection("reviews")
                                      //                     .add(
                                      //                   {
                                      //                     // "uid":
                                      //                     //     user?.user?.uid ??
                                      //                     //         "",
                                      //                     // "email": user?.user
                                      //                     //         ?.email ??
                                      //                     //     "",
                                      //                     "review": reviewTec
                                      //                         .text
                                      //                         .trim(),
                                      //                     "timestamp":
                                      //                     Timestamp.now(),
                                      //                     "score":
                                      //                     reviewScore + 1,
                                      //                   },
                                      //                 );
                                      //                 Navigator.of(context)
                                      //                     .pop();
                                      //               },
                                      //               child: Text("등록"),
                                      //             ),
                                      //           ],
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      // );
                                    },
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                        const Text("녹음 내용"),
                        Text("${widget.script.content}"),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "${widget.script.price ?? "10000"} 원",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //     Spacer(),
                        //     Icon(
                        //       Icons.star,
                        //       color: Colors.orange,
                        //     ),
                        //     Text("4.5"),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  // DefaultTabController(
                  //   length: 2,
                  //   child: Column(
                  //     children: [
                  //       const TabBar(
                  //         tabs: [
                  //           Tab(
                  //             text: "제품 상세",
                  //           ),
                  //           Tab(
                  //             text: "리뷰",
                  //           ),
                  //         ],
                  //       ),
                  //       Container(
                  //         height: 500,
                  //         child: TabBarView(
                  //           children: [
                  //             Container(
                  //               child: const Text("제품 상세"),
                  //             ),
                  //             StreamBuilder(
                  //                 stream: FirebaseFirestore.instance
                  //                     .collection("products")
                  //                     .doc("${widget.script.docId}")
                  //                     .collection("reviews")
                  //                     .snapshots(),
                  //                 builder: (context, snapshot) {
                  //                   if (snapshot.hasData) {
                  //                     final items = snapshot.data?.docs ?? [];
                  //                     return ListView.separated(
                  //                         itemBuilder: (context, index) {
                  //                           return ListTile(
                  //                             title: Text("${items[index].data()["review"]}"),
                  //                           );
                  //                         },
                  //                         separatorBuilder: (_, __) =>
                  //                             Divider(),
                  //                         itemCount: items.length);
                  //                   }
                  //                   return Center(
                  //                     child: CircularProgressIndicator(),
                  //                   );
                  //                 }),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () async {
          //     final db = FirebaseFirestore.instance;
          //     final dupItems = await db
          //         .collection("cart")
          //         .where("uid", isEqualTo: userCredential?.user?.uid ?? "")
          //         .where("product.docId", isEqualTo: widget.script.docId)
          //         .get();
          //     if (dupItems.docs.isNotEmpty) {
          //       if (context.mounted) {
          //         showDialog(
          //           context: context,
          //           builder: (context) =>
          //               AlertDialog(
          //                 content: Text("장바구니에 이미 등록되어 있는 제품입니다."),
          //               ),
          //         );
          //       }
          //       return;
          //     }
          //
          //     // w장바구니 추가
          //     // await db.collection("cart").add({
          //     //   "uid": userCredential?.user?.uid ?? "",
          //     //   "email": userCredential?.user?.email ?? "",
          //     //   "timestamp": DateTime
          //     //       .now()
          //     //       .millisecondsSinceEpoch,
          //     //   "script": widget.script.toJson(),
          //     //   "count": 1
          //     // });
          //     if (context.mounted) {
          //       showDialog(
          //         context: context,
          //         builder: (context) =>
          //             AlertDialog(
          //               content: Text("장바구니에 등록 완료"),
          //             ),
          //       );
          //     }
          //   },
          //   child: Container(
          //     height: 72,
          //     decoration: BoxDecoration(color: Colors.red[100]),
          //     child: const Center(
          //       child: Text(
          //         "장바구니",
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 24,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
