
function [Pload, Ppv, capacita_batteria, round_trip, carica_scarica_ora, SOCmax, SOCmin, SOCinit] = parameter_pass()

global P_pv P_load Round_trip carica_scarica Cap_batteria SOC_max SOC_min SOC_init

Pload = P_load;
Ppv = P_pv;
round_trip = Round_trip;
carica_scarica_ora = carica_scarica;
capacita_batteria = Cap_batteria;
SOCmax = SOC_max;
SOCmin = SOC_min;
SOCinit = SOC_init;

end