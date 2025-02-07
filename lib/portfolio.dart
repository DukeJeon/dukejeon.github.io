import 'package:dukejeon_github_io/elements/values/palette.dart';
import 'package:flutter/material.dart';
import 'package:seo/io/seo_controller.dart';
import 'package:seo/io/tree/widget_tree.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  double get columnSpace => scale(150);
  double get paragraghSpace => scale(60);
  final String fontFamilly = 'NotoSansKR'; 

  double get width =>MediaQuery.of(context).size.width;
  double get dotSize => scale(50);
  double get horizontalPadding => MediaQuery.of(context).size.width / 12 ;

  TextStyle get columnStyle => TextStyle(
    fontSize: scale(80),
    fontWeight: FontWeight.w900,
    fontFamily: fontFamilly,
    color: Palette.foreground,
    height: 1.0
  );
  TextStyle get descriptionStyle => TextStyle(
    fontSize: scale(40),
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilly,
    color: Palette.foreground.withAlpha(130),
  );

  LinearGradient get dotGradient => LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.65,
      1
    ],
    colors: [
      Palette.pastelPrimaryColor,
      Palette.primaryColor,
    ]
  );

  LinearGradient get pointGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Palette.pastelPrimaryColor,
      Palette.primaryColor,
    ]
  );

  double scale(double baseSize) => baseSize * (width / 1440);

  @override
  Widget build(BuildContext context) {
    return SeoController(
      enabled: true,
      tree: WidgetTree(context: context),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: fontFamilly,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: columnSpace),
                  _description(),
                  SizedBox(height: paragraghSpace),
                  _paragraghWrapper(
                    Expanded(
                      child: Text(
                        "Flutter 앱 개발자로 커리어를 시작해 성장해왔으며, 큰 틀을 중요하게 여기되 서비스의 이미지는 사소한 디테일에서 출발한다고 생각합니다. 그렇기에 인터페이스의 디테일과 사용자 환경이 조화롭게 어우러지는 것을 좋아합니다.",
                        style: descriptionStyle,
                      ),
                    )
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _paragraghWrapper(Widget paragragh) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: dotSize + horizontalPadding / 2),
        paragragh,
      ],
    );
  }

  Widget _columnWrapper(Widget column) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: pointGradient,
          ),
        ),
        SizedBox(width: horizontalPadding / 2),
        column,
      ],
    );
  }

  Widget _description() {
    return _columnWrapper(
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "안녕하십니까?\n",
              ),
              TextSpan(
                text: "저는 Duke, 전범수입니다.",
                style: columnStyle.copyWith(height: 1.5),
              ),
            ],
            style: columnStyle,
          ),
        ),
      )
    );
  }
}