part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  
  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}
