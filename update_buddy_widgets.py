with open('lib/features/home/presentation/home_screen.dart', 'r', encoding='utf-8') as f:
    home_content = f.read()

old_home_avatar = """                Container(
                  width: 52,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD166),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFAE34).withAlpha(100),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('😊', style: TextStyle(fontSize: 28)),
                  ),
                ),"""

new_home_avatar = """                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5288).withAlpha(110),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/buddy.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('😊', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                ),"""

home_content = home_content.replace(old_home_avatar, new_home_avatar)
with open('lib/features/home/presentation/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(home_content)

print("home_screen.dart updated successfully!")

# Update buddy_mascot.dart
with open('lib/features/buddy/presentation/buddy_mascot.dart', 'r', encoding='utf-8') as f:
    buddy_content = f.read()

old_buddy_container = """                  child: Container(
                    width: 72,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF7B731).withAlpha(110),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      size: const Size(72, 86),
                      painter: OvalSmileyPainter(
                        isHappy: _isHappy,
                      ),
                    ),
                  ),"""

new_buddy_container = """                  child: Container(
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
                        errorBuilder: (_, __, ___) => CustomPaint(
                          size: const Size(78, 78),
                          painter: OvalSmileyPainter(
                            isHappy: _isHappy,
                          ),
                        ),
                      ),
                    ),
                  ),"""

buddy_content = buddy_content.replace(old_buddy_container, new_buddy_container)
with open('lib/features/buddy/presentation/buddy_mascot.dart', 'w', encoding='utf-8') as f:
    f.write(buddy_content)

print("buddy_mascot.dart updated successfully!")

