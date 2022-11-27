import 'dart:ffi' as c;

import 'package:ffi/ffi.dart';

/** carta.hpp
 *
 */
typedef numero_da_carta = c.UnsignedChar;
typedef cCorDaCarta = c.Char;

class Carta extends c.Opaque {}

typedef carta_get_cor = cCorDaCarta Function(c.Pointer<Carta>);
typedef carta_get_numero = numero_da_carta Function(c.Pointer<Carta>);
typedef carta_delete = c.Void Function(c.Pointer<Carta>);

/** carta_especial.hpp
 *
 */
typedef cTipoDeCartaEspecial = c.Char;

class CartaEspecial extends c.Opaque {}

typedef cast_carta_to_carta_especial = c.Pointer<CartaEspecial> Function(
    c.Pointer<Carta>);
typedef carta_especial_get_tipo = cTipoDeCartaEspecial Function(
    c.Pointer<CartaEspecial>);

/** map.hpp
 *
 */
class Mao extends c.Opaque {}

typedef mao_size = c.Size Function(c.Pointer<Mao>);
typedef mao_begin = c.Pointer<c.Pointer<Carta>> Function(c.Pointer<Mao>);
typedef mao_end = c.Pointer<c.Pointer<Carta>> Function(c.Pointer<Mao>);
typedef mao_adicionar_carta = c.Void Function(c.Pointer<Mao>, c.Pointer<Carta>);
typedef mao_remover_carta = c.Pointer<Carta> Function(c.Pointer<Mao>, c.Size);
typedef mao_at = c.Pointer<Carta> Function(
    c.Pointer<Mao>, c.Size, c.Pointer<c.Pointer<Utf8>>);
typedef mao_get_cor_da_carta = cCorDaCarta Function(c.Pointer<Mao>, c.Size);

/** jogador.hpp
 *
 */
typedef id_jogador = c.Size;

class Jogador extends c.Opaque {}

typedef jogador_get_mao = c.Pointer<Mao> Function(c.Pointer<Jogador>);
typedef jogador_get_id = id_jogador Function(c.Pointer<Jogador>);

/** partida.hpp
 *
 */
typedef cDirecaoDaPartida = c.Char;

class Partida extends c.Opaque {}

typedef partida_get_direcao = cDirecaoDaPartida Function(c.Pointer<Partida>);
typedef partida_get_jogador_atual = id_jogador Function(c.Pointer<Partida>);
typedef partida_jogar_carta = c.Void Function(
    c.Pointer<Partida>, id_jogador, c.Size, c.Pointer<c.Pointer<Utf8>>);
typedef partida_get_cor_da_partida = cCorDaCarta Function(c.Pointer<Partida>);
typedef partida_comer_carta = c.Void Function(
    c.Pointer<Partida>, id_jogador, c.Pointer<c.Pointer<Utf8>>);
typedef partida_begin = c.Pointer<Jogador> Function(c.Pointer<Partida>);
typedef partida_end = c.Pointer<Jogador> Function(c.Pointer<Partida>);

/** interface.hpp
 *
 */
class Interface extends c.Opaque {}

typedef interface_new = c.Pointer<Interface> Function();
typedef interface_delete = c.Void Function(c.Pointer<Interface>);
typedef interface_get_partida = c.Pointer<Partida> Function(
    c.Pointer<Interface>);
typedef interface_get_instrucoes = c.Pointer<c.Char> Function(
    c.Pointer<Interface>);
typedef interface_sair = c.Void Function(c.Pointer<Interface>);
typedef interface_resetar = c.Void Function(c.Pointer<Interface>);
typedef interface_comecar = c.Void Function(c.Pointer<Interface>);
