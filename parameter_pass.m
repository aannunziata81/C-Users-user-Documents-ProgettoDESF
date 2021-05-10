function [Pload, Ppv, SOCmin, SOCmax, SOCinit, round_trip, carica_scarica_ora] = parameter_pass()

global P_pv P_load SOC_min SOC_max SOC_init Round_trip carica_scarica

Pload = P_load;
Ppv = P_pv;
SOCmin = SOC_min;
SOCmax = SOC_max;
SOCinit = SOC_init;
round_trip = Round_trip;
carica_scarica_ora = carica_scarica;

end