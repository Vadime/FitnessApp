import 'package:flutter/material.dart';

class TwoTickSlider extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double min;
  final double max;
  final double minLimit;
  final double maxLimit;
  final Function(double, double) onChanged;

  const TwoTickSlider({
    Key? key,
    required this.startValue,
    required this.endValue,
    this.min = 0.0,
    this.max = 1.0,
    this.minLimit = 0.0,
    this.maxLimit = 1.0,
    required this.onChanged,
  }) : super(key: key);

  @override
  TwoTickSliderState createState() => TwoTickSliderState();
}

class TwoTickSliderState extends State<TwoTickSlider>
    with SingleTickerProviderStateMixin {
  late double _startDragValue;
  late double _endDragValue;
  Thumb? _currentThumb;

  // für animation
  late final AnimationController _controller;
  late final Animation<double> _startThumbAnimation;
  late final Animation<double> _endThumbAnimation;

  // für schatten
  bool _isStartThumbPressed = false;
  bool _isEndThumbPressed = false;

  @override
  void initState() {
    super.initState();
    _startDragValue = widget.startValue;
    _endDragValue = widget.endValue;

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300) // Die Dauer der Animation
        );

    _startDragValue = widget.startValue;
    _endDragValue = widget.endValue;

    _startThumbAnimation =
        Tween<double>(begin: _startDragValue, end: _startDragValue)
            .animate(_controller)
          ..addListener(() => _updateStartThumbValue());

    _endThumbAnimation = Tween<double>(begin: _endDragValue, end: _endDragValue)
        .animate(_controller)
      ..addListener(() => _updateStartThumbValue());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTapDown: (details) {},
        onHorizontalDragStart: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          final startThumbX = _valueToPosition(_startDragValue, renderBox.size);
          final endThumbX = _valueToPosition(_endDragValue, renderBox.size);

          if ((localPosition.dx - startThumbX).abs() <= 30) {
            _currentThumb = Thumb.start;
          } else if ((localPosition.dx - endThumbX).abs() <= 30) {
            _currentThumb = Thumb.end;
          }
          if (_currentThumb == Thumb.start) {
            setState(() => _isStartThumbPressed = true);
          } else if (_currentThumb == Thumb.end) {
            setState(() => _isEndThumbPressed = true);
          }
        },
        onHorizontalDragUpdate: (details) {
          if (_currentThumb != null) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            final dragPosition = localPosition.dx;

            if (_currentThumb == Thumb.start) {
              double newValue = _positionToValue(dragPosition, renderBox.size);
              _startDragValue = newValue.clamp(widget.minLimit, _endDragValue);
            } else {
              double newValue = _positionToValue(dragPosition, renderBox.size);
              _endDragValue = newValue.clamp(_startDragValue, widget.maxLimit);
            }

            widget.onChanged(_startDragValue, _endDragValue);

            setState(() {});
          }
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            _isStartThumbPressed = false;
            _isEndThumbPressed = false;
          });
          _currentThumb = null;
          // Optional: Smoothly animate to the final value on drag end
          _startThumbAnimation =
              Tween<double>(begin: _startDragValue, end: _startDragValue)
                  .animate(_controller);
          _endThumbAnimation =
              Tween<double>(begin: _endDragValue, end: _endDragValue)
                  .animate(_controller);
          _controller.forward(from: 0.0);
        },
        onTapUp: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          final tapPosition = localPosition.dx;

          double newStartValue = _positionToValue(tapPosition, renderBox.size);
          double newEndValue = _positionToValue(tapPosition, renderBox.size);

          bool isStartCloser = (tapPosition -
                      _valueToPosition(_startDragValue, renderBox.size))
                  .abs() <
              (tapPosition - _valueToPosition(_endDragValue, renderBox.size))
                  .abs();

          _controller.reset();

          // Entfernen der alten Listener
          _startThumbAnimation.removeListener(_updateStartThumbValue);
          _endThumbAnimation.removeListener(_updateEndThumbValue);

          if (isStartCloser) {
            _startThumbAnimation = Tween<double>(
              begin: _startDragValue,
              end: newStartValue.clamp(widget.minLimit, _endDragValue),
            ).animate(_controller)
              ..addListener(_updateStartThumbValue);
            widget.onChanged(
                newStartValue.clamp(widget.minLimit, _endDragValue),
                _endDragValue);
          } else {
            _endThumbAnimation = Tween<double>(
              begin: _endDragValue,
              end: newEndValue.clamp(_startDragValue, widget.maxLimit),
            ).animate(_controller)
              ..addListener(_updateEndThumbValue);
            widget.onChanged(_startDragValue,
                newEndValue.clamp(_startDragValue, widget.maxLimit));
          }

          _controller.forward();
        },
        child: CustomPaint(
          size: const Size(double.infinity, 20),
          painter: _RangeSliderPainter(
            startValue: _startDragValue,
            endValue: _endDragValue,
            min: widget.min,
            max: widget.max,
            isStartThumbPressed: _isStartThumbPressed,
            isEndThumbPressed: _isEndThumbPressed,
          ),
        ),
      ),
    );
  }

  double _positionToValue(double position, Size size) {
    return position / size.width * (widget.max - widget.min) + widget.min;
  }

  double _valueToPosition(double value, Size size) {
    return (value - widget.min) / (widget.max - widget.min) * size.width;
  }

  void _updateStartThumbValue() {
    if (_currentThumb == Thumb.start || _currentThumb == null) {
      setState(() {
        _startDragValue = _startThumbAnimation.value;
      });
    }
  }

  void _updateEndThumbValue() {
    if (_currentThumb == Thumb.end || _currentThumb == null) {
      setState(() {
        _endDragValue = _endThumbAnimation.value;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum Thumb { start, end }

class _RangeSliderPainter extends CustomPainter {
  final double startValue;
  final double endValue;
  final double min;
  final double max;
  final bool isStartThumbPressed;
  final bool isEndThumbPressed;

  _RangeSliderPainter({
    required this.startValue,
    required this.endValue,
    required this.min,
    required this.max,
    required this.isStartThumbPressed,
    required this.isEndThumbPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double barHeight = 5;
    var trackPaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barHeight;
    var sector1Paint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barHeight;
    var sector2Paint = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barHeight;
    var sector3Paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barHeight;
    var thumbPaint = Paint()
      ..color = Colors.orange
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height;

    // Draw the track
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), trackPaint);

    double startThumbX = _valueToPosition(startValue, size);
    double endThumbX = _valueToPosition(endValue, size);

    // Zeichnen der Sektoren
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(startThumbX, size.height / 2), sector1Paint);

    canvas.drawLine(Offset(startThumbX, size.height / 2),
        Offset(endThumbX, size.height / 2), sector2Paint);

    canvas.drawLine(Offset(endThumbX, size.height / 2),
        Offset(size.width, size.height / 2), sector3Paint);

    if (isStartThumbPressed) {
      // Zeichnen Sie einen Schatten für den Start-Daumen
      var shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(
          Offset(startThumbX, size.height / 2), size.height / 2, shadowPaint);
    }

    if (isEndThumbPressed) {
      // Zeichnen Sie einen Schatten für den End-Daumen
      var shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(
          Offset(endThumbX, size.height / 2), size.height / 2, shadowPaint);
    }

    // Draw the thumbs
    canvas.drawCircle(
        Offset(startThumbX, size.height / 2), size.height / 2, thumbPaint);
    canvas.drawCircle(
        Offset(endThumbX, size.height / 2), size.height / 2, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double _valueToPosition(double value, Size size) {
    return (value - min) / (max - min) * size.width;
  }
}
