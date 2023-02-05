import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textAnimation({required BuildContext context}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: DefaultTextStyle(
      textAlign: TextAlign.center,
      style: GoogleFonts.lato(
          fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
      child: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText('Synapsis'),
            FadeAnimatedText('Synapsis Sinergi'),
            FadeAnimatedText('Synapsis Sinergi Digital'),
          ],
          onTap: () {
            print("Tap Event");
          },
        ),
      ),
    ),
  );
}
