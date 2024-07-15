import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageCubit extends Cubit<int> {
  PageController pageController = PageController();

  PageCubit() : super(0); // initial state is 0

  void onPageChanged(int index) {
    pageController.jumpToPage(index);
    emit(index); // emit the new state
  }
}