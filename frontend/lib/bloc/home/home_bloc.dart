import 'package:fitness_app/bloc/home/home_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageChangedEvent {
  final int index;
  const HomePageChangedEvent({this.index = 0});
}

class HomeState {
  final HomeItem currentPage;
  final int index;

  const HomeState({required this.currentPage, required this.index});

  // get title
  String get title => currentPage.title;

  // get icon
  IconData get icon => currentPage.icon;

  // get page
  Widget get page => currentPage.page;

  // get action
  Widget? get action => currentPage.action;
}

class HomeBloc extends Bloc<HomePageChangedEvent, HomeState> {
  final List<HomeItem> homePages;
  final int initialIndex;
  HomeBloc({required this.homePages, this.initialIndex = 0})
      : super(
          HomeState(
            currentPage: homePages[initialIndex],
            index: initialIndex,
          ),
        ) {
    on<HomePageChangedEvent>((event, emit) {
      emit(HomeState(currentPage: homePages[event.index], index: event.index));
    });
  }
}
