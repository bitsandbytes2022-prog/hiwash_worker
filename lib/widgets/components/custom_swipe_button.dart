import 'package:flutter/material.dart';
import 'package:hiwash_worker/styling/app_color.dart';

enum _SwipeButtonType {
  swipe,
  expand,
}

class CustomSwipeButton extends StatefulWidget {
  final Widget child;
  final Widget? thumb;

  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final EdgeInsets thumbPadding;

  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final EdgeInsets trackPadding;

  final BorderRadius? borderRadius;

  final double width;
  final double height;

  final bool enabled;

  final double elevationThumb;
  final double elevationTrack;

  final VoidCallback? onSwipeStart;
  final VoidCallback? onSwipe;
  final VoidCallback? onSwipeEnd;

  final _SwipeButtonType _swipeButtonType;

  final Duration duration;

  const CustomSwipeButton({
    super.key,
    required this.child,
    this.thumb,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding = EdgeInsets.zero,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackPadding = EdgeInsets.zero,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 50,
    this.enabled = true,
    this.elevationThumb = 0,
    this.elevationTrack = 0,
    this.onSwipeStart,
    this.onSwipe,
    this.onSwipeEnd,
    this.duration = const Duration(milliseconds: 250),
  })  : assert(elevationThumb >= 0.0),
        assert(elevationTrack >= 0.0),
        _swipeButtonType = _SwipeButtonType.swipe;

  @override
  State<CustomSwipeButton> createState() => _CustomSwipeState();
}

class _CustomSwipeState extends State<CustomSwipeButton> with TickerProviderStateMixin {
  late AnimationController swipeAnimationController;
  late AnimationController expandAnimationController;

  bool swiped = false;

  @override
  void initState() {
    _initAnimationControllers();
    super.initState();
  }

  _initAnimationControllers() {
    swipeAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
    expandAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
  }

  @override
  void dispose() {
    swipeAnimationController.dispose();
    expandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _buildTrack(context, constraints),
              _buildThumb(context, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrack(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final trackColor = widget.enabled
        ? widget.activeTrackColor ?? theme.colorScheme.surface
        : widget.inactiveTrackColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);
    final elevationTrack = widget.enabled ? widget.elevationTrack : 0.0;

    return Container(
      width: constraints.maxWidth,
      height: widget.height,
      decoration: BoxDecoration(
          color: AppColor.c1F9D70,
          borderRadius: borderRadius,
          boxShadow: [BoxShadow(
            color: AppColor.c1F9D70.withOpacity(0.40),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 10),
          )]
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: widget.child,
    );
  }

  Widget _buildThumb(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final thumbColor = widget.enabled
        ? widget.activeThumbColor ?? theme.colorScheme.secondary
        : widget.inactiveThumbColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);

    final elevationThumb = widget.enabled ? widget.elevationThumb : 0.0;

    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;

    return AnimatedBuilder(
      animation: swipeAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate((isRTL ? -1 : 1) *
                swipeAnimationController.value *
                (constraints.maxWidth - widget.height)),
          child: Container(
            padding: widget.thumbPadding,
            child: GestureDetector(
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details, constraints.maxWidth),
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Material(
                elevation: elevationThumb,
                borderRadius: borderRadius,
                color:  AppColor.c1F9D70,
                clipBehavior: Clip.antiAlias,
                child: AnimatedBuilder(
                  animation: expandAnimationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: widget.height +
                          (expandAnimationController.value *
                              (constraints.maxWidth - widget.height)) -
                          widget.thumbPadding.horizontal,
                      height: widget.height - widget.thumbPadding.vertical,
                      child: widget.thumb ??
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      swiped = false;
    });
    widget.onSwipeStart?.call();
  }

  _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    final double offset = details.primaryDelta! / (width - widget.height);

    if (!swiped && widget.enabled) {
      if (isRTL) {
        swipeAnimationController.value -= offset;
      } else {
        swipeAnimationController.value += offset;
      }

      if (swipeAnimationController.value == 1) {
        setState(() {
          swiped = true;
          widget.onSwipe?.call();
        });
      }
    }
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      swipeAnimationController.animateTo(0);
      expandAnimationController.animateTo(0);
    });
    widget.onSwipeEnd?.call();
  }
}

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Swipe Button Custom Example'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomSwipeButton(
              thumbPadding: EdgeInsets.all(3),
              thumb: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              elevationThumb: 2,
              elevationTrack: 2,
              child: Text(
                "Swipe to ...".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSwipe: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Swiped!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
*/
