import 'package:chatbot/views/sign%20up%20screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import 'indecator.dart';
import 'onboard_content.dart';

class OnBoardContentArea extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  OnBoardContentArea({
    super.key,
  });

  @override
  State<OnBoardContentArea> createState() => _OnBoardContentAreaState();
}

class _OnBoardContentAreaState extends State<OnBoardContentArea> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: PageView.builder(
            itemCount: items.length,
            onPageChanged: (value) => setState(() {
              currentIndex = value;
            }),
            controller: _controller,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(items[index]["image"]),
                      CustomText(
                        content: items[index]["title"],
                        colour: colorWhite,
                        weight: FontWeight.w600,
                        size: 35,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: CustomText(
                          content: items[0]["content"],
                          colour: colorWhite,
                          align: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        // buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indicator(currentIndex),
        ),
        SizedBox(
          width: 250,
          child: ElevatedButton(
              onPressed: () {
                slide();
                if (currentIndex == 2) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                      (route) => false);
                }
              },
              child: const CustomText(
                content: "LET'S GO",
                colour: colorblack,
                weight: FontWeight.w500,
              )),
        )
      ],
    );
  }

  slide() async {
    await _controller.nextPage(
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }
}
