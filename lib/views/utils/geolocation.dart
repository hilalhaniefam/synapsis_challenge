import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synapsis_project/views/shared/loading_btn.dart';

Widget myLocation(
    BuildContext context, String? location, Function currentLocation) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.rectangle,
        border: Border.all(width: 3.0),
        borderRadius: const BorderRadius.all(Radius.circular(10.0) //
            ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.locationDot,
              size: 45,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Your Current Location',
                style: TextStyle(color: Colors.white)),
            const SizedBox(
              height: 10,
            ),
            location!.isNotEmpty
                ? Text(
                    location,
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Click button below',
                    style: TextStyle(color: Colors.white),
                  ),
            const SizedBox(
              height: 20,
            ),
            LoadingBtn(
              loader: Container(
                padding: const EdgeInsets.all(10),
                width: 40,
                height: 40,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
              borderRadius: 10,
              height: 40,
              width: 120,
              color: Colors.white,
              child: const Text(
                'Get Location',
                style: TextStyle(color: Colors.black),
              ),
              onTap: (startLoading, stopLoading, btnState) async {
                if (btnState == ButtonState.idle) {
                  startLoading();
                  await Future.delayed(const Duration(seconds: 5));
                  currentLocation();
                  stopLoading();
                }
              },
            ),
          ],
        ),
      ));
}
