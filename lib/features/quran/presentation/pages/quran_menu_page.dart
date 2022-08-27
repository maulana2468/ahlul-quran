import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../injection_container.dart';
import '../bloc/quran_bloc.dart';
import '../widgets/list_surah.dart';
import '../widgets/curve_clipper.dart';

class QuranMenuPage extends StatelessWidget {
  const QuranMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranBloc>()..add(const OnGetData()),
      child: const QuranMenuPageContent(),
    );
  }
}

class QuranMenuPageContent extends StatelessWidget {
  const QuranMenuPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF5),
        body: Column(
          children: [
            SizedBox(
              height: MyFunction.getHeight(context, 48),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MyFunction.getWidth(context, 24),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Future.delayed(const Duration(milliseconds: 25), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Image.asset(
                      "assets/vector/back.png",
                      width: MyFunction.getWidth(context, 24.62),
                      height: MyFunction.getHeight(context, 24),
                    ),
                  ),
                  SizedBox(
                    width: MyFunction.getWidth(context, 18),
                  ),
                  const Text(
                    "Al Quran",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDA8856),
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/vector/ascdesc.png",
                    width: MyFunction.getWidth(context, 24),
                    height: MyFunction.getHeight(context, 24),
                  ),
                  SizedBox(
                    width: MyFunction.getWidth(context, 18),
                  ),
                  Image.asset(
                    "assets/vector/list.png",
                    width: MyFunction.getWidth(context, 24.63),
                    height: MyFunction.getHeight(context, 24),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyFunction.getHeight(context, 24),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MyFunction.getWidth(context, 24),
              ),
              child: SizedBox(
                height: MyFunction.getHeight(context, 131),
                child: Stack(
                  children: [
                    Container(
                      height: MyFunction.getHeight(context, 131),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE6DEC7),
                      ),
                    ),
                    ClipPath(
                      clipper: CurveClipper(),
                      child: Container(
                        width: MyFunction.getWidth(context, 210),
                        height: MyFunction.getHeight(context, 131),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Color(0xFFDA8856),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MyFunction.getWidth(context, 18),
                        right: MyFunction.getWidth(context, 12),
                        top: MyFunction.getHeight(context, 18),
                        bottom: MyFunction.getHeight(context, 18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/vector/small_book.png",
                                    width: MyFunction.getWidth(context, 20),
                                    height: MyFunction.getHeight(context, 20),
                                  ),
                                  SizedBox(
                                    width: MyFunction.getWidth(context, 8),
                                  ),
                                  const Text(
                                    "Terakhir Dibaca",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Text(
                                "Al-Fatihah",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Ayat No: 1",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Image.asset(
                              "assets/vector/logo.png",
                              width: MyFunction.getWidth(context, 107),
                              height: MyFunction.getHeight(context, 90),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MyFunction.getHeight(context, 24),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MyFunction.getWidth(context, 24),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MyFunction.getWidth(context, 16),
                vertical: MyFunction.getHeight(context, 8),
              ),
              height: MyFunction.getHeight(context, 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                    color: const Color(0xFFDA8856).withOpacity(0.1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (val) {
                        context.read<QuranBloc>().add(OnSearch(val));
                      },
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFDA8856),
                      ),
                      cursorColor: const Color(0xFFDA8856),
                      decoration: const InputDecoration.collapsed(
                        hintText: "Cari",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFDA8856),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/vector/search_mini.png",
                    width: MyFunction.getWidth(context, 24.62),
                    height: MyFunction.getHeight(context, 24),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MyFunction.getHeight(context, 24),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MyFunction.getWidth(context, 24),
              ),
              child: TabBar(
                indicator: CircleTabIndicator(
                  color: const Color(0xFFDA8856),
                  size: MyFunction.getWidth(context, 101),
                ),
                tabs: const [
                  Tab(
                    child: Text(
                      "Surah",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xFFDA8856),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Juz",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xFFDA8856),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Target",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xFFDA8856),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<QuranBloc, QuranState>(
                    builder: (context, state) {
                      if (state.loadStatus == LoadStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFDA8856),
                          ),
                        );
                      } else if (state.loadStatus == LoadStatus.loaded) {
                        return ListView.builder(
                          itemCount: state.listSurahNew.length,
                          itemBuilder: (context, index) {
                            return ListSurah(
                              quranData: state.listSurahNew[index],
                            );
                          },
                        );
                      } else if (state.loadStatus == LoadStatus.error) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        return const Center(
                          child: Text("Initialize"),
                        );
                      }
                    },
                  ),
                  Text("B"),
                  Text("C"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double size})
      : _painter = _CirclePainter(color, size);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double size;

  _CirclePainter(Color color, this.size)
      : _paint = Paint()
          ..color = color
          ..strokeWidth = 2
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    canvas.drawLine(
      offset + Offset(5, cfg.size!.height),
      offset + Offset(size + 5, cfg.size!.height),
      _paint,
    );
    // RRect fullRect = RRect.fromRectAndRadius(
    //   Rect.fromCenter(
    //     center: offset + Offset(65, cfg.size!.height),
    //     width: 50,
    //     height: 15,
    //   ),
    //   const Radius.circular(10),
    // );
    // canvas.drawRRect(fullRect, _paint);
  }
}
