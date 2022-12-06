export 'native_impl.dart';
import 'package:ffi/ffi.dart';
import 'package:libuno/data.dart';

import 'native_impl.dart' as impl;
export 'native_h.dart'
    show Carta, CartaEspecial, Interface, Jogador, Mao, Partida;
import 'native_h.dart'
    show id_jogador, Carta, CartaEspecial, Interface, Jogador, Mao, Partida;
import 'dart:ffi' as c;
import 'native_d.dart' as d;

enum CorDaCarta { amarelo, azul, verde, vermelho }

enum TipoDeCartaEspecial { bloqueia, comeDois, reverso }

enum DirecaoDaPartida { normal, reversa }

CorDaCarta cor_da_carta_from_c(int cor_da_carta) {
  switch (cor_da_carta) {
    case 0:
      return CorDaCarta.amarelo;
    case 1:
      return CorDaCarta.azul;
    case 2:
      return CorDaCarta.verde;
    case 3:
      return CorDaCarta.vermelho;
    default:
      throw Exception("Invalid cor_da_carta");
  }
}

final carta_get_cor = _carta_get_cor;
CorDaCarta _carta_get_cor(c.Pointer<Carta> self) =>
    cor_da_carta_from_c(impl.carta_get_cor(self));

TipoDeCartaEspecial tipo_de_carta_especial_from_c(int tipo_de_carta_especial) {
  switch (tipo_de_carta_especial) {
    case 10:
      return TipoDeCartaEspecial.bloqueia;
    case 11:
      return TipoDeCartaEspecial.comeDois;
    case 12:
      return TipoDeCartaEspecial.reverso;
    default:
      throw Exception("Invalid tipo_de_carta_especial");
  }
}

final carta_especial_get_tipo = _carta_especial_get_tipo;
TipoDeCartaEspecial _carta_especial_get_tipo(c.Pointer<CartaEspecial> self) =>
    tipo_de_carta_especial_from_c(impl.carta_especial_get_tipo(self));
final mao_at = _mao_at;
c.Pointer<Carta> _mao_at(c.Pointer<Mao> self, int i) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  final v = impl.mao_at(self, i, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
  return v;
}

DirecaoDaPartida direcao_da_partida_from_c(int direcao_da_partida) {
  switch (direcao_da_partida) {
    case 0:
      return DirecaoDaPartida.normal;
    case 1:
      return DirecaoDaPartida.reversa;
    default:
      throw Exception("Invalid direcao_da_partida");
  }
}

final mao_get_cor_da_carta = _mao_get_cor_da_carta;
CorDaCarta _mao_get_cor_da_carta(c.Pointer<Mao> self, int i) =>
    cor_da_carta_from_c(impl.mao_get_cor_da_carta(self, i));
final partida_get_cor_da_partida = _partida_get_cor_da_partida;
CorDaCarta _partida_get_cor_da_partida(c.Pointer<Partida> self) =>
    cor_da_carta_from_c(impl.partida_get_cor_da_partida(self));
final partida_get_direcao = _partida_get_direcao;
DirecaoDaPartida _partida_get_direcao(c.Pointer<Partida> self) =>
    direcao_da_partida_from_c(impl.partida_get_direcao(self));
final partida_jogar_carta = _partida_jogar_carta;
void _partida_jogar_carta(c.Pointer<Partida> self, int id_jogador, int i) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  impl.partida_jogar_carta(self, id_jogador, i, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
}

final partida_comer_carta = _partida_comer_carta;
void _partida_comer_carta(c.Pointer<Partida> self, int id_jogador) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  impl.partida_comer_carta(self, id_jogador, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
}

final partida_at = _partida_at;
c.Pointer<Jogador> _partida_at(c.Pointer<Partida> self, int i) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  final v = impl.partida_at(self, i, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
  return v;
}

final interface_get_instrucoes = _interface_get_instrucoes;
String _interface_get_instrucoes(c.Pointer<Interface> self) {
  final c_str = impl.interface_get_instrucoes(self);
  final dartStr = c_str.toDartString();
  return dartStr;
}

abstract class CAPI {
  const CAPI();
  factory CAPI.impl() => CAPIImpl();
  UnoCardColor cor_da_carta_to_uno_card_color(CorDaCarta cor) {
    switch (cor) {
      case CorDaCarta.amarelo:
        return UnoCardColor.yellow;
      case CorDaCarta.azul:
        return UnoCardColor.blue;
      case CorDaCarta.verde:
        return UnoCardColor.green;
      case CorDaCarta.vermelho:
        return UnoCardColor.red;
    }
  }

  UnoCard carta_to_uno_card(c.Pointer<Carta> carta) {
    final especial = cast_carta_to_carta_especial(carta);
    final cor = cor_da_carta_to_uno_card_color(carta_get_cor(carta));
    if (especial != c.nullptr) {
      final tipo = carta_especial_get_tipo(especial);
      switch (tipo) {
        case TipoDeCartaEspecial.bloqueia:
          return UnoCard.blockCard(cor);
        case TipoDeCartaEspecial.comeDois:
          return UnoCard.plusTwoCard(cor);
        case TipoDeCartaEspecial.reverso:
          return UnoCard.reverseCard(cor);
      }
    }
    return UnoCard.defaultCard(
      cor,
      carta_get_numero(carta),
    );
  }

  UnoDirection direcao_da_partida_to_uno_direction(DirecaoDaPartida direcao) {
    switch (direcao) {
      case DirecaoDaPartida.normal:
        return UnoDirection.clockwise;
      case DirecaoDaPartida.reversa:
        return UnoDirection.counterClockwise;
    }
  }

  c.Pointer<T> itNextPtr<T extends c.NativeType>(c.Pointer<T> it) =>
      c.Pointer.fromAddress(it.address + c.sizeOf<c.Pointer<c.Void>>());
  Iterable<c.Pointer<T>> iteratePtr<T extends c.NativeType>(
      c.Pointer<T> begin, c.Pointer<T> end) sync* {
    for (var it = begin; it != end; it = itNextPtr(it)) {
      yield it;
    }
  }

  Iterable<c.Pointer<Jogador>> iterateJogador(c.Pointer<Partida> self) sync* {
    for (var i = 0; i < partida_size(self); i++) {
      yield partida_at(self, i);
    }
  }

  d.cast_carta_to_carta_especial get cast_carta_to_carta_especial;
  CorDaCarta Function(c.Pointer<Carta>) get carta_get_cor;
  TipoDeCartaEspecial Function(c.Pointer<CartaEspecial>)
      get carta_especial_get_tipo;
  d.carta_get_numero get carta_get_numero;
  d.partida_size get partida_size;
  c.Pointer<Jogador> Function(c.Pointer<Partida>, int) get partida_at;
  d.interface_new get interface_new;
  d.interface_get_partida get interface_get_partida;
  void Function(c.Pointer<Partida>, int) get partida_comer_carta;
  void Function(c.Pointer<Partida>, int, int) get partida_jogar_carta;
  d.partida_jogar_bot get partida_jogar_bot;
  d.jogador_get_id get jogador_get_id;
  d.jogador_get_mao get jogador_get_mao;
  d.mao_size get mao_size;
  d.mao_begin get mao_begin;
  d.mao_end get mao_end;
  d.partida_get_cartas_na_mesa get partida_get_cartas_na_mesa;
  d.partida_get_cartas_para_comer get partida_get_cartas_para_comer;
  d.pilha_begin get pilha_begin;
  d.pilha_end get pilha_end;
  CorDaCarta Function(c.Pointer<Partida>) get partida_get_cor_da_partida;
  d.partida_get_vencedor get partida_get_vencedor;
  d.interface_delete get interface_delete;
  d.partida_get_jogador_atual get partida_get_jogador_atual;
  DirecaoDaPartida Function(c.Pointer<Partida>) get partida_get_direcao;
  String Function(c.Pointer<Interface>) get interface_get_instrucoes;
  d.interface_resetar get interface_resetar;
}

class CAPIImpl extends CAPI {
  @override
  final d.cast_carta_to_carta_especial cast_carta_to_carta_especial =
      impl.cast_carta_to_carta_especial;
  @override
  final CorDaCarta Function(c.Pointer<Carta>) carta_get_cor = _carta_get_cor;
  @override
  final TipoDeCartaEspecial Function(c.Pointer<CartaEspecial>)
      carta_especial_get_tipo = _carta_especial_get_tipo;
  @override
  final d.carta_get_numero carta_get_numero = impl.carta_get_numero;
  @override
  final d.partida_size partida_size = impl.partida_size;
  @override
  final c.Pointer<Jogador> Function(c.Pointer<Partida>, int) partida_at =
      _partida_at;
  @override
  final d.interface_new interface_new = impl.interface_new;
  @override
  final d.interface_get_partida interface_get_partida =
      impl.interface_get_partida;
  @override
  final void Function(c.Pointer<Partida>, int) partida_comer_carta =
      _partida_comer_carta;
  @override
  final void Function(c.Pointer<Partida>, int, int) partida_jogar_carta =
      _partida_jogar_carta;
  @override
  final d.partida_jogar_bot partida_jogar_bot = impl.partida_jogar_bot;
  @override
  final d.jogador_get_id jogador_get_id = impl.jogador_get_id;
  @override
  final d.jogador_get_mao jogador_get_mao = impl.jogador_get_mao;
  @override
  final d.mao_size mao_size = impl.mao_size;
  @override
  final d.mao_begin mao_begin = impl.mao_begin;
  @override
  final d.mao_end mao_end = impl.mao_end;
  @override
  final d.partida_get_cartas_na_mesa partida_get_cartas_na_mesa =
      impl.partida_get_cartas_na_mesa;
  @override
  final d.partida_get_cartas_para_comer partida_get_cartas_para_comer =
      impl.partida_get_cartas_para_comer;
  @override
  final d.pilha_begin pilha_begin = impl.pilha_begin;
  @override
  final d.pilha_end pilha_end = impl.pilha_end;
  @override
  final CorDaCarta Function(c.Pointer<Partida>) partida_get_cor_da_partida =
      _partida_get_cor_da_partida;
  @override
  final d.partida_get_vencedor partida_get_vencedor = impl.partida_get_vencedor;
  @override
  final d.interface_delete interface_delete = impl.interface_delete;
  @override
  final d.partida_get_jogador_atual partida_get_jogador_atual =
      impl.partida_get_jogador_atual;
  @override
  final DirecaoDaPartida Function(c.Pointer<Partida>) partida_get_direcao =
      _partida_get_direcao;
  @override
  final String Function(c.Pointer<Interface>) interface_get_instrucoes =
      _interface_get_instrucoes;
  @override
  final d.interface_resetar interface_resetar = impl.interface_resetar;
}
