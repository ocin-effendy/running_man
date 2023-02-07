import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:running_man/game/man.dart';
import 'package:running_man/packages/enemy_generator.dart';

class TinyGame extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  late Man man; // Animations for the Man
  late EnemyGenerator enemyGenerator;
  late ParallaxComponent parallaxComponent; // Map
  late TextComponent scoreComponent;
  late TextComponent scoreTitle;
  late double score;
  bool isPaused = false;
  double currentSpeed = 0.2;

  static final player = FlameAudio.bgm.audioPlayer;

  TinyGame() {
    enemyGenerator = EnemyGenerator();
    scoreComponent = TextComponent();
    scoreTitle = TextComponent();
  }

  @override
  Future<void>? onLoad() async {
    man = await Man.create();

    await FlameAudio.audioCache
        .loadAll(['bgr.mp3', 'jump.wav', 'death.mp3', 'hurt.mp3']);
    player.play(AssetSource('bgr.mp3'), volume: 80);
    player.setReleaseMode(ReleaseMode.loop);

    parallaxComponent = await loadParallaxComponent(
      [
        // Parallax Forest Background
        ParallaxImageData('Background/Layer_0011_0.png'),
        ParallaxImageData('Background/Layer_0010_1.png'),
        ParallaxImageData('Background/Layer_0009_2.png'),
        ParallaxImageData('Background/Layer_0008_3.png'),
        ParallaxImageData('Background/Layer_0007_4.png'),
        ParallaxImageData('Background/Layer_0006_5.png'),
        ParallaxImageData('Background/Layer_0005_6.png'),
        ParallaxImageData('Background/Layer_0004_7.png'),
      ],
      baseVelocity: Vector2(currentSpeed, 0), // Map Move Speed
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );

    score = 0;
    scoreTitle = TextComponent(
      text: "Score",
      textRenderer: TextPaint(
          style: TextStyle(
              fontFamily: 'Audiowide', fontSize: size.y - size.y * 90 / 100)),
    );

    scoreComponent = TextComponent(
        text: score.toStringAsFixed(0),
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
            style: TextStyle(
                fontFamily: 'Audiowide',
                fontSize: size.y - size.y * 94 / 100,
                color: Colors.yellow)));

    addAll([
      parallaxComponent,
      man,
      man.dust,
      enemyGenerator,
      scoreTitle,
      scoreComponent,
    ]);

    overlays.add("Pause Button");
    overlays.add("Lives");

    onGameResize(canvasSize);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Game Over Check
    gameOver();

    // Score Manipulation
    score += 60 * dt;
    scoreComponent.text = score.toStringAsFixed(0);

    // Smoke run / jump Animation
    if (!man.onGround()) {
      man.dust.jumpDust();
    }
    if (man.onGround()) {
      man.dust.runDust();
    }

    super.update(dt);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    // Score Title Resizing
    scoreTitle.x = (canvasSize.x - scoreComponent.width - scoreTitle.width) / 2;
    scoreTitle.y = canvasSize.y - canvasSize.y * 88 / 100;

    // Score Resizing
    scoreComponent.x = (canvasSize.x - scoreComponent.width) / 2;
    scoreComponent.y = canvasSize.y - canvasSize.y * 75 / 100;
    super.onGameResize(canvasSize);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Screen Touch Taps
    man.jump();
    super.onTapDown(info);
  }

  void gameOver() async {
    if (man.life.value <= 0) {
      player.stop();
      enemyGenerator.removeAllEnemy();
      scoreComponent.removeFromParent();
      scoreTitle.removeFromParent();
      man.die();
      await Future.delayed(const Duration(milliseconds: 500));
      overlays.add('Game Over');
      pauseEngine();
    }
  }

  @override
  KeyEventResult onKeyEvent(
      // Keyboard Space Taps
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed) {
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace) {
      man.jump();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
