
function [Pload, Ppv, capacita_batteria, round_trip, carica_scarica_ora, SOCmax, SOCmin, SOCinit, fasce_orarie_2020, prezzo_vendita_energia_elettrica] = parameter_pass()

global P_pv P_load Round_trip carica_scarica Cap_batteria SOC_max SOC_min SOC_init fasce_orarie2020 prezzo_vendita

Pload = P_load;
Ppv = P_pv;
round_trip = Round_trip;
carica_scarica_ora = carica_scarica;
capacita_batteria = Cap_batteria;
SOCmax = SOC_max;
SOCmin = SOC_min;
SOCinit = SOC_init;
fasce_orarie_2020 = fasce_orarie2020 ;
prezzo_vendita_energia_elettrica = prezzo_vendita;
end