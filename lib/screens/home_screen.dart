import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:panda/constant.dart';
import 'package:panda/models/just_listen_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda/bloc/just_listen/just_listen_bloc.dart';
import 'package:panda/bloc/just_listen/just_listen_event.dart';
import 'package:panda/bloc/just_listen/just_listen_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer;
  double currentProgress = 0.0;
  int maxProgress = 365;
  Duration endDuration = Duration(seconds : 0);
  Duration startDuration = Duration(seconds: 0);
  AnimationController iconController;
  bool firstPlay = true;
  bool isPlaying = false;
  int indexColor = 0;
  bool isLoading = true;
  JustListen currentData;


  playAudio() async {
    audioPlayer.play();
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  void handleOnPressedIcon() {
    if(!isLoading){
      setState(() {
        isPlaying = !isPlaying;
        if(isPlaying){
          iconController.forward();
          playAudio();
        }else{
          iconController.reverse();
          pauseAudio();
        }
      });  
    }
    
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    BlocProvider.of<JustListenBloc>(context).add(
      Fetch(),
    );
    audioPlayer.setUrl("https://www.listennotes.com/e/p/44698217937f4d9c9b3e404e6cfce303/");

    iconController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    audioPlayer.positionStream.listen((position) {
      final positionNotNull = position ?? Duration.zero;
      setState((){
        currentProgress = positionNotNull.inSeconds / maxProgress;
        startDuration = positionNotNull;
      });
    });

    audioPlayer.playerStateStream.listen((playState) {
      if(playState.processingState == ProcessingState.ready){
        print("ready");
      }
      if(playState.processingState == ProcessingState.completed){
        iconController.reverse();
        pauseAudio();
        setState((){
            indexColor = ((indexColor+2) > backColor.length) ? 0 : indexColor+1; 
            endDuration = Duration(seconds : 0);
            startDuration = Duration(seconds : 0);
            currentProgress = 0;
            isPlaying = false;
        });
        BlocProvider.of<JustListenBloc>(context).add(
          Fetch(),
        );
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHour =twoDigits(duration.inHours);

    if(duration.inHours > 0 ){
      return "$twoDigitHour:$twoDigitMinutes:$twoDigitSeconds";
    }
    else{
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: backColor[indexColor]
        ),
      ),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(   
            children :[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(30),
                child: BlocConsumer<JustListenBloc, JustListenState>(
                  listener: (context, state) {
                    if(state is JustListenLoading)
                    {
                      setState((){
                        isLoading = true;
                      });
                    }

                    else if(state is JustListenFailure){
                      setState((){
                        isLoading = true;
                      });
                    }

                    else if(state is JustListenSuccess)
                    {
                      setState((){
                        isLoading = false;
                        currentData = state.justListen;
                        maxProgress = currentData.audioLengthSec;
                        audioPlayer.setUrl(currentData.audio);
                        endDuration = Duration(seconds : state.justListen.audioLengthSec);
                      });
                    }
                  },
                  builder: (context, state){
                    if(state is JustListenSuccess){
                      var data = state.justListen;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          // imageUrl: "https://cdn-images-1.listennotes.com/podcasts/the-wake-up/the-wake-up-nov-2-2020-once-Lct8AHSPTjN-KjW2divRpn0.1400x1400.jpg"
                          imageUrl:  data.thumbnail,
                          placeholder: (context, url) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(0.3),
                              child: Center(
                                child : SvgPicture.asset("assets/icons/microphone.svg", color: Colors.white, width: 100, height: 100),
                              )
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      );
                    }
                    else{ 
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.white.withOpacity(0.3),
                            child: Center(
                                child : SvgPicture.asset("assets/icons/microphone.svg", color: Colors.white, width: 100, height: 100),
                            )
                        )
                      );
                    }
                  },
                )
              ),
              Padding(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey[300].withOpacity(0.3),
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      value: currentProgress,
                    ),
                    SizedBox(
                      height: 5
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(printDuration(startDuration), 
                          style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white   )
                        ),
                        Text(printDuration(endDuration), 
                          style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white)
                        ),
                      ]
                    ),
                  ]
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5)
              ),
              
              SizedBox(
                height: 50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.fast_rewind, color: Colors.white),
                    onPressed: (){
                      iconController.reverse();
                      pauseAudio();
                      setState((){
                          indexColor = ((indexColor-1) < 0) ?  backColor.length - 1 : indexColor-1;
                          endDuration = Duration(seconds : 0);
                          startDuration = Duration(seconds : 0);
                          currentProgress = 0;
                          isPlaying = false;
                      });
                      BlocProvider.of<JustListenBloc>(context).add(
                        Fetch(),
                      );
                    }
                  ),
                  Container(  
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 100,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: iconController,
                        color: Colors.white,
                      ),
                      onPressed: () => handleOnPressedIcon()
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.fast_forward, color: Colors.white),
                    onPressed: (){
                      iconController.reverse();
                      pauseAudio();
                      setState((){
                          indexColor = ((indexColor+2) > backColor.length) ? 0 : indexColor+1;  
                          endDuration = Duration(seconds : 0);
                          startDuration = Duration(seconds : 0);
                          currentProgress = 0;
                          isPlaying = false;
                      });
                      BlocProvider.of<JustListenBloc>(context).add(
                        Fetch(),
                      );
                    }
                  )
                ]
              ),
              // Spacer(),
              // Container(
              //   height: 5, 
              //   width: 200,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16.0),
              //     color: Colors.white, 
              //   )
              // ),
              // SizedBox(height: 20)
            ]
          )
        )
      ),
    );
  }
}
