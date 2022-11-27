import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:libuno/uno.dart';

class _SendPortsAndStateMachine {
  final SendPort isolatePortSendPort;
  final SendPort stateSendPort;
  final SendPort didSucceedSendPort;
  final UnoStateMachine stateMachine;

  _SendPortsAndStateMachine(
    this.isolatePortSendPort,
    this.stateSendPort,
    this.didSucceedSendPort,
    this.stateMachine,
  );
}

abstract class _EventAndIdOrSetState {}

class _SetState extends _EventAndIdOrSetState {
  final UnoState state;

  _SetState(this.state);
}

class _EventAndId extends _EventAndIdOrSetState {
  final UnoEvent event;
  final int id;

  _EventAndId(this.event, this.id);
}

class _SucceededAndId {
  final bool succeeded;
  final int id;

  _SucceededAndId(this.succeeded, this.id);
}

class ThreadedStateMachine extends UnoStateMachine {
  final List<StreamController<UnoState>> _listeners = [];
  final Isolate _isolate;
  @override
  final GameParameters parameters;
  SendPort? _isolateSendPort;
  UnoState _state;
  ThreadedStateMachine._(
    this._isolate,
    this._state,
    this.parameters,
    ReceivePort isolatePortReceivePort,
    ReceivePort stateReceivePort,
    ReceivePort didSucceedReceivePort,
  ) {
    isolatePortReceivePort.listen(_onIsolateSendPort);
    stateReceivePort.listen(_onState);
    didSucceedReceivePort.listen(_onDidSucceed);
  }

  static Future<ThreadedStateMachine> spawn(UnoStateMachine baseMachine) async {
    final isolatePortReceivePort = ReceivePort();
    final stateReceivePort = ReceivePort();
    final didSucceedReceivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      _isolateMain,
      _SendPortsAndStateMachine(
        isolatePortReceivePort.sendPort,
        stateReceivePort.sendPort,
        didSucceedReceivePort.sendPort,
        baseMachine,
      ),
    );
    return ThreadedStateMachine._(
      isolate,
      baseMachine.currentState,
      baseMachine.parameters,
      isolatePortReceivePort,
      stateReceivePort,
      didSucceedReceivePort,
    );
  }

  final Map<int, Completer<bool>> _completers = {};
  final Queue<_EventAndIdOrSetState> _eventsBeforeIsolateStart = Queue();
  int _id = 0;
  static void _isolateMain(_SendPortsAndStateMachine args) {
    final sink = args.stateSendPort;
    final machine = args.stateMachine;
    machine.state.listen(sink.send);
    final stream = ReceivePort();
    args.isolatePortSendPort.send(stream.sendPort);
    stream.listen((e) async {
      final sink = args.didSucceedSendPort;
      final event = e as _EventAndIdOrSetState;
      if (event is _EventAndId) {
        final didSucceed = await machine.dispatch(event.event);
        sink.send(_SucceededAndId(didSucceed, event.id));
      }
      if (event is _SetState) {
        machine.currentState = event.state;
      }
    });
  }

  @override
  set currentState(UnoState state) {
    final e = _SetState(state);
    if (_isolateSendPort != null) {
      _isolateSendPort!.send(e);
    } else {
      _eventsBeforeIsolateStart.add(e);
    }
    _state = state;
  }

  @override
  UnoState get currentState => _state;

  @override
  Future<bool> dispatch(UnoEvent event) {
    final id = _id++;
    final completer = _completers[id] = Completer();
    final e = _EventAndId(event, id);
    if (_isolateSendPort != null) {
      _isolateSendPort!.send(e);
    } else {
      _eventsBeforeIsolateStart.add(e);
    }
    return completer.future;
  }

  void _onDidSucceed(dynamic m) {
    final msg = m as _SucceededAndId;
    final c = _completers.remove(msg.id)!;
    c.complete(msg.succeeded);
  }

  void _onState(dynamic m) {
    final msg = m as UnoState;
    for (final l in _listeners) {
      l.add(msg);
    }
  }

  void _onIsolateSendPort(dynamic m) {
    final msg = m as SendPort;
    _isolateSendPort = msg;
    while (_eventsBeforeIsolateStart.isNotEmpty) {
      final e = _eventsBeforeIsolateStart.removeFirst();
      _isolateSendPort!.send(e);
    }
  }

  @override
  Stream<UnoState> get state {
    final controller = StreamController<UnoState>();
    controller.onListen = () => _listeners.add(controller);
    controller.onCancel = () => _listeners.remove(controller);
    controller.add(currentState);
    return controller.stream;
  }

  void dispose() {
    _isolate.kill();
  }
}
