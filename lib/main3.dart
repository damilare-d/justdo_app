import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage3(),
  ));
}

class HomePage3 extends StatelessWidget {
  const HomePage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(),
          ),
          Expanded(
            child: SizedBox(
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.blueGrey,
                        child: ClipPath(
                            clipper: CustomClip(),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.28,
                              color: Colors.blue,
                            )),
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.yellow,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var w = size.width;
    var h = size.height;
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, h - h / 4);
    path.quadraticBezierTo(
        w - w / 20, h - ((h / 4) + (h / 20)), w - w / 10, (h / 4 + h / 10));
    path.lineTo((w - 3 * w / 20), (h / 4 + 3 * h / 20));
    path.lineTo((w / 2 + w / 8), (h / 4 + 3 * h / 20));
    path.quadraticBezierTo(
        w / 2 + w / 16, h / 4 + h / 5, w / 2 + 0, h / 4 + h / 5 + h / 20);
    path.lineTo((w / 2 - w / 20), h / 4 + h / 5 + h / 10);
    path.lineTo((w / 2 - w / 20), (h / 2 + h / 4));
    path.quadraticBezierTo((w / 2 - w / 10), (h / 2 + h / 4 + h / 20),
        (w - w / 10 - w / 20), (h / 2 + h / 4 + h / 10));
    path.lineTo((w - w / 5), (h));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
