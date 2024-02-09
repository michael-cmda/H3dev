import 'package:flutter/material.dart';

class MyMobileBody extends StatelessWidget {
  const MyMobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 238, 232),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // comment section & recommended videos
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: HomeBody(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.circular(16.0),
  );
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.635,
        decoration: buildBoxDecoration(),
        padding: const EdgeInsets.all(20.0),
        child: const AspectRatio(
          aspectRatio: 16 / 3,
          child: Text(
            'Minimized Content :D',
            style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
