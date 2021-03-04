import 'package:bloc/bloc.dart';
import 'package:soil_mate/screens/home.dart';
import 'package:soil_mate/screens/sample_list.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  TextureSurveyClickedEvent,
  GroundCoverSurveyClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(NavigationStates initialState) : super(initialState);


  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield Home();
        break;
      case NavigationEvents.TextureSurveyClickedEvent:
        yield SampleList();
        break;
      // case NavigationEvents.GroundCoverSurveyClickedEvent:
      //   yield GroundCoverSampleList();
      //   break;
    }
  }
}