import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final String selectedMenu;

  const HomeState({
    this.selectedIndex = 0,
    this.selectedMenu = 'Home',
  });

  HomeState copyWith({
    int? selectedIndex,
    String? selectedMenu,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedMenu: selectedMenu ?? this.selectedMenu,
    );
  }

  @override
  List<Object> get props => [selectedIndex, selectedMenu];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeTab(int index, {String? menu}) {
    emit(state.copyWith(selectedIndex: index, selectedMenu: menu));
  }
}
