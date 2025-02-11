import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/widget_system/repositories/model/node_model.dart';
import 'package:flutter_unit/widget_system/repositories/model/widget_model.dart';
import 'package:flutter_unit/widget_system/repositories/repositories.dart';


import 'widget_detail_event.dart';
import 'widget_detail_state.dart';

/// create by 张风捷特烈 on 2020-03-03
/// contact me by email 1981462002@qq.com
/// 说明:

class WidgetDetailBloc extends Bloc<DetailEvent, DetailState> {

  final WidgetRepository repository;

  WidgetDetailBloc({required this.repository}):super(DetailLoading());


  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is FetchWidgetDetail) {
      yield* _mapLoadWidgetToState(event.widgetModel);
    }
    if(event is ResetDetailState){
      yield DetailLoading();
    }
  }

  Stream<DetailState> _mapLoadWidgetToState(WidgetModel widgetModel) async* {
    yield DetailLoading();
    try {
      final List<NodeModel> nodes = await repository.loadNode(widgetModel);
      final List<WidgetModel> links = await repository.loadWidget(widgetModel.links);
      if(nodes.isEmpty){
        yield DetailEmpty();
      }else{
        yield DetailWithData(widgetModel: widgetModel, nodes: nodes,links: links);
      }

    } catch (_) {
      yield DetailFailed();
    }
  }
}
