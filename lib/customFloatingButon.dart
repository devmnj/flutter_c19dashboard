import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MButon extends StatelessWidget {
  MButon({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.deepOrange,
      splashColor: Colors.orange,
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.help,
              color: Colors.amber,
            ),
            SizedBox(
              width: 8,
            ),
             Text(
              'About',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
