import 'dart:ffi' as ffi;
import 'native_h.dart' as c;
import 'native_d.dart' as d;

final libuno = ffi.DynamicLibrary.open("libuno.so");

/** carta.hpp
 *
 */
final carta_get_cor =
    libuno.lookupFunction<c.carta_get_cor, d.carta_get_cor>("carta_get_cor");
final carta_get_numero = libuno
    .lookupFunction<c.carta_get_numero, d.carta_get_numero>("carta_get_numero");
final carta_delete =
    libuno.lookupFunction<c.carta_delete, d.carta_delete>("carta_delete");
/** carta_especial.hpp
 *
 */
final cast_carta_to_carta_especial = libuno.lookupFunction<
    c.cast_carta_to_carta_especial,
    d.cast_carta_to_carta_especial>("cast_carta_to_carta_especial");
final carta_especial_get_tipo =
    libuno.lookupFunction<c.carta_especial_get_tipo, d.carta_especial_get_tipo>(
        "carta_especial_get_tipo");
/** map.hpp
 *
 */
final mao_size = libuno.lookupFunction<c.mao_size, d.mao_size>("mao_size");
final mao_begin = libuno.lookupFunction<c.mao_begin, d.mao_begin>("mao_begin");
final mao_end = libuno.lookupFunction<c.mao_end, d.mao_end>("mao_end");
final mao_adicionar_carta =
    libuno.lookupFunction<c.mao_adicionar_carta, d.mao_adicionar_carta>(
        "mao_adicionar_carta");
final mao_remover_carta =
    libuno.lookupFunction<c.mao_remover_carta, d.mao_remover_carta>(
        "mao_remover_carta");
final mao_at = libuno.lookupFunction<c.mao_at, d.mao_at>("mao_at");
final mao_get_cor_da_carta =
    libuno.lookupFunction<c.mao_get_cor_da_carta, d.mao_get_cor_da_carta>(
        "mao_get_cor_da_carta");
/** jogador.hpp
 *
 */

final jogador_get_mao = libuno
    .lookupFunction<c.jogador_get_mao, d.jogador_get_mao>("jogador_get_mao");
final jogador_get_id =
    libuno.lookupFunction<c.jogador_get_id, d.jogador_get_id>("jogador_get_id");
/** partida.hpp
 *
 */
final partida_get_direcao =
    libuno.lookupFunction<c.partida_get_direcao, d.partida_get_direcao>(
        "partida_get_direcao");
final partida_get_jogador_atual = libuno.lookupFunction<
    c.partida_get_jogador_atual,
    d.partida_get_jogador_atual>("partida_get_jogador_atual");
final partida_jogar_carta =
    libuno.lookupFunction<c.partida_jogar_carta, d.partida_jogar_carta>(
        "partida_jogar_carta");
final partida_get_cor_da_partida = libuno.lookupFunction<
    c.partida_get_cor_da_partida,
    d.partida_get_cor_da_partida>("partida_get_cor_da_partida");
final partida_comer_carta =
    libuno.lookupFunction<c.partida_comer_carta, d.partida_comer_carta>(
        "partida_comer_carta");
final partida_jogar_bot =
    libuno.lookupFunction<c.partida_jogar_bot, d.partida_jogar_bot>(
        "partida_jogar_bot");
final partida_begin =
    libuno.lookupFunction<c.partida_begin, d.partida_begin>("partida_begin");
final partida_end =
    libuno.lookupFunction<c.partida_end, d.partida_end>("partida_end");
/** interface.hpp
 *
 */
final interface_new =
    libuno.lookupFunction<c.interface_new, d.interface_new>("interface_new");
final interface_delete = libuno
    .lookupFunction<c.interface_delete, d.interface_delete>("interface_delete");
final interface_get_partida =
    libuno.lookupFunction<c.interface_get_partida, d.interface_get_partida>(
        "interface_get_partida");
final interface_get_instrucoes = libuno.lookupFunction<
    c.interface_get_instrucoes,
    d.interface_get_instrucoes>("interface_get_instrucoes");
final interface_sair =
    libuno.lookupFunction<c.interface_sair, d.interface_sair>("interface_sair");
final interface_resetar =
    libuno.lookupFunction<c.interface_resetar, d.interface_resetar>(
        "interface_resetar");
final interface_comecar =
    libuno.lookupFunction<c.interface_comecar, d.interface_comecar>(
        "interface_comecar");
