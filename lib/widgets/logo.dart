import 'package:flutter/material.dart';

class PestoStyle extends TextStyle {
  const PestoStyle({
    double fontSize = 12.0,
    FontWeight fontWeight,
    Color color = Colors.black87,
    double letterSpacing,
    double height,
  }) : super(
          inherit: false,
          color: color,
          fontFamily: 'Raleway',
          fontSize: fontSize,
          fontWeight: fontWeight,
          textBaseline: TextBaseline.alphabetic,
          letterSpacing: letterSpacing,
          height: height,
        );
}

class Logo extends StatefulWidget {
  final double height;
  final double t;
  const Logo({this.height, this.t});

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  // Native sizes for logo and its image/text components.
  static const double kLogoHeight = 150.0;
  static const double kLogoWidth = 220.0;
  static const double kImageHeight = 108.0;
  static const double kTextHeight = 55.0;
  final TextStyle titleStyle = const PestoStyle(
      fontSize: kTextHeight,
      fontWeight: FontWeight.w900,
      color: Colors.black,
      letterSpacing: 3.0);

  final RectTween _textRectTween = RectTween(
    begin: const Rect.fromLTWH(0.0, kLogoHeight, kLogoWidth, kTextHeight),
    end: const Rect.fromLTWH(0.0, kImageHeight, kLogoWidth, kTextHeight),
  );

  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);
  final RectTween _imageRectTween = RectTween(
    begin: const Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
    end: const Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight),
  );
  @override
  Widget build(BuildContext context) {
    return Semantics(
      namesRoute: true,
      child: Transform(
        transform: Matrix4.identity()..scale(widget.height / kLogoHeight),
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: kLogoWidth,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned.fromRect(
                rect: _imageRectTween.lerp(widget.t),
                child: Image.asset(
                  'assets/images/shop.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned.fromRect(
                rect: _textRectTween.lerp(widget.t),
                child: Opacity(
                  opacity: _textOpacity.transform(widget.t),
                  child: Text(
                    'Fashion Items',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
