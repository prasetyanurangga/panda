import 'package:flutter/material.dart';
import 'package:panda/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda/bloc/just_listen/just_listen_bloc.dart';
import 'package:panda/provider/api_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)  => JustListenBloc(),
      child: MaterialApp(
        title: 'Just Podcast',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
