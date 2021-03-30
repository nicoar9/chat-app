import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String routeText;
  final String primaryText;

  const Labels(
      {Key key,
      @required this.route,
      @required this.routeText,
      @required this.primaryText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          this.primaryText,
          style: TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, this.route);
          },
          child: Text(
            this.routeText,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }
}
