import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:running_man/main.dart';
import 'package:running_man/packages/audio_player.dart';
import 'package:running_man/screens/about.dart';
import 'package:running_man/screens/feedback.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  static final player = FlameAudio.bgm;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    player.play('menu.mp3');

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Card(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: EdgeInsets.all(size.width - size.width * 93 / 100),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Run Man",
                  style: TextStyle(
                    fontSize: size.height - size.height * 90 / 100,
                    fontFamily: "Audiowide",
                    color: Colors.yellow,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MaterialButton(
                  onPressed: () {
                    AudioSfx.click.resume();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyGameApp()),
                    );
                    player.stop();
                  },
                  color: Colors.blue,
                  child: Text("Play",
                      style: TextStyle(
                        fontSize: size.height - size.height * 95 / 100,
                        fontFamily: "Audiowide",
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MaterialButton(
                  onPressed: () {
                    AudioSfx.click.resume();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutApp()),
                    );
                  },
                  color: Colors.blue,
                  child: Text("About",
                      style: TextStyle(
                        fontSize: size.height - size.height * 95 / 100,
                        fontFamily: "Audiowide",
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MaterialButton(
                  onPressed: () {
                    AudioSfx.click.resume();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppFeedback()),
                    );
                  },
                  color: Colors.blue,
                  child: Text("Feedback",
                      style: TextStyle(
                        fontSize: size.height - size.height * 95 / 100,
                        fontFamily: "Audiowide",
                        color: Colors.white,
                      )),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
