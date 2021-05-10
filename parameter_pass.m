function [Pload, Ppv, capacita_batteria, round_trip, carica_scarica_ora] = parameter_pass()

global P_pv P_load Round_trip carica_scarica Cap_batteria

Pload = P_load;
Ppv = P_pv;
round_trip = Round_trip;
carica_scarica_ora = carica_scarica;
capacita_batteria = Cap_batteria;
end