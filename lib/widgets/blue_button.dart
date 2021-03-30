import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;

  const BlueButton({Key key, @required this.onPressed, this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            this.buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
