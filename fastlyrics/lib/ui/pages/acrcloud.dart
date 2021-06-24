import 'package:fastlyrics/providers/home_vm.dart';
import 'package:fastlyrics/ui/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:google_fonts/google_fonts.dart';

class ACRCloudPage extends StatefulWidget {
  const ACRCloudPage({Key key, this.pref}) : super(key: key);

  final SharedPreferences pref;

  @override
  _ACRCloudPagetate createState() => _ACRCloudPagetate();
}

class _ACRCloudPagetate extends State<ACRCloudPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      HomeViewModel homeVM = Provider.of<HomeViewModel>(context, listen: false);
      homeVM.init(context);

      homeVM.setController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeVM = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Ripples(
              size: homeVM.loading ? 160 : 40,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(20),
                child: Image.asset(
                  "assets/images/music.png",
                  height: 40,
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 55,
              width: 200,
              child: CupertinoButton(
                onPressed: () {
                  if (!homeVM.loading) {
                    homeVM.start();
                  } else {
                    homeVM.stop();
                  }
                },
                child: Text(
                  'Tap to ${homeVM.loading ? 'Cancel' : 'Identify'}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}

class Ripples extends HookWidget {
  const Ripples({
    this.size = 80.0,
    this.color = Colors.green,
    this.onPressed,
    @required this.child,
  });

  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  Widget _button(AnimationController controller) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[color, Color.lerp(color, Colors.black, .05)],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: controller,
                curve: const _PulsateCurve(),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _controller = context.watch<HomeViewModel>().controller;

    if (_controller == null) return Container();

    return CustomPaint(
      painter: _CirclePainter(
        _controller,
        color: color,
      ),
      child: SizedBox(
        width: size * 2.125,
        height: size * 2.125,
        child: _button(_controller),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter(
    this._animation, {
    @required this.color,
  }) : super(repaint: _animation);

  final Color color;

  final Animation<double> _animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => true;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);

    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);

    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }
}

class _PulsateCurve extends Curve {
  const _PulsateCurve();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
