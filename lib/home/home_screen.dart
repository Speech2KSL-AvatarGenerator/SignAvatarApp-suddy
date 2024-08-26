import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suddy/home/record_screen.dart';
import '../model/script.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Script>> fetchSavedScripts() async {
    final dbRef = FirebaseFirestore.instance.collection("scripts");
    final productItems = await dbRef.orderBy("timestamp").get();

    List<Script> scripts = [];
    for (var element in productItems.docs) {
      final item = Script.fromJson(element.data());
      final copyItem = item.copyWith(docId: element.id);
      scripts.add(copyItem);
    }
    return scripts;
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // 로그아웃 후에는 로그인 화면으로 이동하거나 다른 동작을 수행합니다.
      context.go("/login"); // 예시로 로그인 화면으로 이동
    } catch (e) {
      // 오류 처리
      print("로그아웃 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 실패: $e')),
      );
    }
  }

  Future<void> deleteScript(String docId) async {
    try {
      final dbRef = FirebaseFirestore.instance.collection("scripts");
      await dbRef.doc(docId).delete();
      setState(() {});  // UI 업데이트를 위해 상태를 갱신합니다.
    } catch (e) {
      print("Error deleting script: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'SUDDY',
          style: TextStyle(color: Colors.white, fontFamily: 'YourSoftFont', fontSize: 24), // 부드러운 글씨체로 변경
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              color: Colors.white,
              child: FutureBuilder<List<Script>>(
                future: fetchSavedScripts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('스크립트가 없습니다.'));
                  }

                  final items = snapshot.data!;

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {
                          context.go("/script", extra: item);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16, right: 16),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(12), // 둥근 모서리
                            border: Border.all(color: Colors.lightBlue),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // 추가 텍스트 또는 내용이 필요하다면 여기에 추가
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () async {
                                  // 스크립트 삭제 처리
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('스크립트 삭제'),
                                        content: Text('정말로 이 스크립트를 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text('삭제'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirm == true) {
                                    await deleteScript(item.docId!); // Firebase에서 스크립트 삭제
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecordScreen(),
            ),
          ).then((result) {
            if (result == true) {
              setState(() {
                fetchSavedScripts();
              });
            }
          });
        },
        backgroundColor: Colors.lightBlue, // 파란색 배경
        child: const Icon(Icons.add, color: Colors.white), // 흰색 아이콘
      ),
    );
  }
}
