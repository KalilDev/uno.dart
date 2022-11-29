export 'native_impl.dart';
import 'package:ffi/ffi.dart';

import 'native_impl.dart' as impl;
export 'native_h.dart'
    show Carta, CartaEspecial, Interface, Jogador, Mao, Partida;
import 'native_h.dart'
    show id_jogador, Carta, CartaEspecial, Interface, Jogador, Mao, Partida;
import 'dart:ffi' as c;

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

CorDaCarta carta_get_cor(c.Pointer<Carta> self) =>
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

TipoDeCartaEspecial carta_especial_get_tipo(c.Pointer<CartaEspecial> self) =>
    tipo_de_carta_especial_from_c(impl.carta_especial_get_tipo(self));
c.Pointer<Carta> mao_at(c.Pointer<Mao> self, int i) {
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
    case 1:
      return DirecaoDaPartida.normal;
    case -1:
      return DirecaoDaPartida.reversa;
    default:
      throw Exception("Invalid direcao_da_partida");
  }
}

CorDaCarta mao_get_cor_da_carta(c.Pointer<Mao> self, int i) =>
    cor_da_carta_from_c(impl.mao_get_cor_da_carta(self, i));
CorDaCarta partida_get_cor_da_partida(c.Pointer<Partida> self) =>
    cor_da_carta_from_c(impl.partida_get_cor_da_partida(self));
DirecaoDaPartida partida_get_direcao(c.Pointer<Partida> self) =>
    direcao_da_partida_from_c(impl.partida_get_direcao(self));
void partida_jogar_carta(c.Pointer<Partida> self, int id_jogador, int i) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  impl.partida_jogar_carta(self, id_jogador, i, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
}

void partida_comer_carta(c.Pointer<Partida> self, int id_jogador) {
  c.Pointer<c.Pointer<Utf8>> e = malloc(c.sizeOf<c.Pointer<Utf8>>());
  impl.partida_comer_carta(self, id_jogador, e);
  if (e.value != c.nullptr) {
    final string = e.value.toDartString();
    malloc.free(e);
    throw Exception(string);
  }
  malloc.free(e);
}

c.Pointer<Jogador> partida_at(c.Pointer<Partida> self, int i) {
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

String interface_get_instrucoes(c.Pointer<Interface> self) {
  final c_str = impl.interface_get_instrucoes(self);
  final dartStr = c_str.toDartString();
  malloc.free(c_str);
  return dartStr;
}
