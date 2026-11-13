import 'package:flutter/material.dart';
import '../data/buddy_dialogues.dart';

class BuddyMascot extends StatefulWidget {
  final String buddyName;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;

  const BuddyMascot({
    super.key,
    this.buddyName = 'Buddy',
    this.isVisible = true,
    this.onToggleVisibility,
  });

  @override
  State<BuddyMascot> createState() => _BuddyMascotState();
}

class _BuddyMascotState extends State<BuddyMascot> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bobAnimation;

  // Floating coordinates
  Offset _position = const Offset(20, 160);
  String? _currentSpeech;
  bool _isSpeaking = false;
  bool _isHappy = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _tapBuddy() {
    setState(() {
      _currentSpeech = BuddyDialogues.getRandomMessage();
      _isSpeaking = true;
      _isHappy = true;
    });

    // Auto-dismiss bubble after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && _isSpeaking) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  void _dismissSpeech() {
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Keep within safe boundaries
    final clampedX = _position.dx.clamp(12.0, (screenSize.width - 90.0).clamp(12.0, 1000.0));
    final clampedY = _position.dy.clamp(60.0, (screenSize.height - 200.0).clamp(60.0, 2000.0));

    return Stack(
      children: [
        Positioned(
          left: clampedX,
          top: clampedY,
          child: Column(
            crossAxisAlignment: clampedX > screenSize.width / 2
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Speech bubble if speaking
              if (_isSpeaking && _currentSpeech != null) ...[
                GestureDetector(
                  onTap: _dismissSpeech,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: (screenSize.width * 0.72).clamp(180.0, 320.0),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(120),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.buddyName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• Tap to dismiss',
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentSpeech!,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Draggable Oval Smiley Buddy
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position += details.delta;
                  });
                },
                onTap: _tapBuddy,
                child: AnimatedBuilder(
                  animation: _bobAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bobAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5288).withAlpha(140),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/images/buddy.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => CustomPaint(
                          size: const Size(78, 78),
                          painter: OvalSmileyPainter(
                            isHappy: _isHappy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OvalSmileyPainter extends CustomPainter {
  final bool isHappy;

  OvalSmileyPainter({required this.isHappy});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Oval Body with warm gradient
    final Rect bodyRect = Rect.fromCenter(
      center: Offset(w / 2, h / 2),
      width: w,
      height: h,
    );

    final Paint bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFEE88), // Soft sunny honey
          Color(0xFFFFAE34), // Warm amber
        ],
      ).createShader(bodyRect);

    canvas.drawOval(bodyRect, bodyPaint);

    // Subtle edge contour
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = const Color(0xFFE28B00).withAlpha(140);
    canvas.drawOval(bodyRect, borderPaint);

    // Soft top highlight
    final Rect hlRect = Rect.fromCenter(
      center: Offset(w * 0.42, h * 0.28),
      width: w * 0.5,
      height: h * 0.32,
    );
    final Paint hlPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withAlpha(160),
          Colors.white.withAlpha(0),
        ],
      ).createShader(hlRect);
    canvas.drawOval(hlRect, hlPaint);

    // 2. Rosy Cheeks
    final Paint cheekPaint = Paint()
      ..color = const Color(0xFFFF6B81).withAlpha(120);

    // Left cheek
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.22, h * 0.56),
        width: 14,
        height: 10,
      ),
      cheekPaint,
    );

    // Right cheek
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.78, h * 0.56),
        width: 14,
        height: 10,
      ),
      cheekPaint,
    );

    // 3. Eyes (Curved happy eyes or rounded friendly vertical ovals)
    final Paint eyePaint = Paint()
      ..color = const Color(0xFF2C1E14);

    final double eyeY = h * 0.42;

    // Left eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.35, eyeY), width: 7.5, height: 11),
        const Radius.circular(4),
      ),
      eyePaint,
    );

    // Right eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.65, eyeY), width: 7.5, height: 11),
        const Radius.circular(4),
      ),
      eyePaint,
    );

    // White eye catchlights
    final Paint lightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.37, eyeY - 2.5), 1.8, lightPaint);
    canvas.drawCircle(Offset(w * 0.67, eyeY - 2.5), 1.8, lightPaint);

    // 4. Smile Arc
    final Paint smilePaint = Paint()
      ..color = const Color(0xFF2C1E14)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.8;

    final Path smilePath = Path();
    smilePath.moveTo(w * 0.36, h * 0.62);
    smilePath.quadraticBezierTo(
      w * 0.50,
      h * 0.74,
      w * 0.64,
      h * 0.62,
    );

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant OvalSmileyPainter oldDelegate) {
    return oldDelegate.isHappy != isHappy;
  }
}
