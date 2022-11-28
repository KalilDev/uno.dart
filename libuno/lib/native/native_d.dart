import 'dart:ffi' as c;
import 'package:ffi/ffi.dart';

import 'native_h.dart'
    show Carta, CartaEspecial, Mao, Jogador, Partida, Interface;

/** carta.hpp
 *
 */
typedef numero_da_carta = int;
typedef cCorDaCarta = int;

typedef carta_get_cor = cCorDaCarta Function(c.Pointer<Carta>);
typedef carta_get_numero = numero_da_carta Function(c.Pointer<Carta>);
typedef carta_delete = void Function(c.Pointer<Carta>);

/** carta_especial.hpp
 *
 */
typedef cTipoDeCartaEspecial = int;

typedef cast_carta_to_carta_especial = c.Pointer<CartaEspecial> Function(
    c.Pointer<Carta>);
typedef carta_especial_get_tipo = cTipoDeCartaEspecial Function(
    c.Pointer<CartaEspecial>);

/** map.hpp
 *
 */
typedef mao_size = int Function(c.Pointer<Mao>);
typedef mao_begin = c.Pointer<c.Pointer<Carta>> Function(c.Pointer<Mao>);
typedef mao_end = c.Pointer<c.Pointer<Carta>> Function(c.Pointer<Mao>);
typedef mao_adicionar_carta = void Function(c.Pointer<Mao>, c.Pointer<Carta>);
typedef mao_remover_carta = c.Pointer<Carta> Function(c.Pointer<Mao>, int);
typedef mao_at = c.Pointer<Carta> Function(
    c.Pointer<Mao>, int, c.Pointer<c.Pointer<Utf8>>);
typedef mao_get_cor_da_carta = cCorDaCarta Function(c.Pointer<Mao>, int);

/** jogador.hpp
 *
 */
typedef id_jogador = int;

typedef jogador_get_mao = c.Pointer<Mao> Function(c.Pointer<Jogador>);
typedef jogador_get_id = id_jogador Function(c.Pointer<Jogador>);

/** partida.hpp
 *
 */
typedef cDirecaoDaPartida = int;

typedef partida_get_direcao = cDirecaoDaPartida Function(c.Pointer<Partida>);
typedef partida_get_jogador_atual = id_jogador Function(c.Pointer<Partida>);
typedef partida_jogar_carta = void Function(
    c.Pointer<Partida>, id_jogador, int, c.Pointer<c.Pointer<Utf8>>);
typedef partida_get_cor_da_partida = cCorDaCarta Function(c.Pointer<Partida>);
typedef partida_comer_carta = void Function(
    c.Pointer<Partida>, id_jogador, c.Pointer<c.Pointer<Utf8>>);
typedef partida_jogar_bot = void Function(c.Pointer<Partida>);
typedef partida_begin = c.Pointer<Jogador> Function(c.Pointer<Partida>);
typedef partida_end = c.Pointer<Jogador> Function(c.Pointer<Partida>);

/** interface.hpp
 *
 */
typedef interface_new = c.Pointer<Interface> Function();
typedef interface_delete = void Function(c.Pointer<Interface>);
typedef interface_get_partida = c.Pointer<Partida> Function(
    c.Pointer<Interface>);
typedef interface_get_instrucoes = c.Pointer<c.Char> Function(
    c.Pointer<Interface>);
typedef interface_sair = void Function(c.Pointer<Interface>);
typedef interface_resetar = void Function(c.Pointer<Interface>);
typedef interface_comecar = void Function(c.Pointer<Interface>);
