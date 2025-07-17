import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [selectedIndex];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
