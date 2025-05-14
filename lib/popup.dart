import 'package:flixax_app/rewards.dart';
import 'package:flixax_app/rewards2.dart';
import 'package:flutter/material.dart';
Widget gradientOutlineButton({required String text, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 100,
      height: 45,
      padding: EdgeInsets.all(1.5), 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255,190,0,1),
            Color.fromRGBO(255,85,253,1),
            Color.fromRGBO(127,187,255,1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black, // Button background
          borderRadius: BorderRadius.circular(30),
        ),
        child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 190, 0, 1),
                    Color.fromRGBO(255, 85, 253, 1),
                    Color.fromRGBO(127, 187, 255, 1),
                  ],
                ).createShader(bounds),
                child: Center(
                  child: Text(
                    'skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nunito'
                    ),
                  ),
                ),
              ),
      ),
    ),
  );
}

void showBonusPopup(BuildContext context, {required VoidCallback onPopupClosed}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 190, 0, 1),
                    Color.fromRGBO(255, 85, 253, 1),
                    Color.fromRGBO(127, 187, 255, 1),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'Follow us on social media',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Nunito'
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                 "assets/images/coin.png",
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                '+200 Bonus',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Nunito',
                  color: Color(0xFFFFC700),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      gradientOutlineButton(
                          text: "Skip",
                          onTap: () {
                            Navigator.pop(context);
                            onPopupClosed();
                          },
                        ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: ()async {
                      Navigator.pop(context);
                      onPopupClosed();
                      Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context)=>Rewards2()
                    ));
                   
                    },
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 190, 0, 1),
                            Color.fromRGBO(255, 85, 253, 1),
                            Color.fromRGBO(127, 187, 255, 1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Container(
                        width: 100,
                         height: 45,
                        alignment: Alignment.center,
                        child: const Text(
                          'Get reward',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
