part of easy_refresh_my;

const _kDefaultSkatingTriggerOffset = 180.0;

const _kSkatingProcessed = Duration(milliseconds: 700);

/// Skating indicator.
/// Base widget for [SkatingHeader] and [SkatingFooter].
class _SkatingIndicator extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  const _SkatingIndicator({
    Key? key,
    required this.state,
    required this.reverse,
  }) : super(key: key);

  @override
  State<_SkatingIndicator> createState() => _SkatingIndicatorState();
}

class _SkatingIndicatorState extends State<_SkatingIndicator> {
  double get _offset => widget.state.offset;

  /// Mode change listener.
  void _onModeChange(IndicatorMode mode, double offset) {
    if (mode == IndicatorMode.ready || mode == IndicatorMode.processing) {
    } else {}
    if (mode == IndicatorMode.processed) {
    } else {}
    if (mode == IndicatorMode.inactive) {
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.state.notifier.addModeChangeListener(_onModeChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.state.notifier.removeModeChangeListener(_onModeChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SkatingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: _offset,
        ),
        Positioned(
          top: _offset > 100 ? _offset - 100 : 0,
          left: 0,
          right: 0,
          child: SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100.0,
              child: Center(
                child: Image.asset(
                  'assets/images/mjCustomGifImage.gif',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
