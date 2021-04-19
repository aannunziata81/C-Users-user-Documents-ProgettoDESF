%% Clear all, clc, close all
clear all, clc, close all

%% Vettore giornata
ore = 0 : 23;


%------------------Soleggiamento--------------------
% Soleggiamento Anno 2020 (W/m^2)
% Caricamento file

% Unità di misura W / m^2
file_soleggiamento = load('soleggiamento_genova_stazione2020');

sol_gennaio_2020 = file_soleggiamento.soleggiamentogennaio;
sol_febbraio_2020 = file_soleggiamento.soleggiamentofebbraio;
sol_marzo_2020 = file_soleggiamento.soleggiamentomarzo;



%------------------Profilo di carico-------------------
% Sito profilo di carico (Azienda ...) Nord-Ovest d'Italia
% Genova Stazione Funzionale

% Profilo del carico nei diversi periodi
% Alto consumo Ott - Gen
% Intermedio consumo Feb - Apr e Lug - Set
% Basso consumo Mag - Giu

% Potenza misurata in KW
file_profilo_carico = load('profilo_carico2020');
profilo_gennaio_2020 = file_profilo_carico.profilo_carico_gennaio;
profilo_febbraio_2020 = file_profilo_carico.profilo_carico_febbraio;
profilo_marzo_2020 = file_profilo_carico.profilo_carico_marzo;
profilo_aprile_2020 = file_profilo_carico.profilo_carico_aprile;
profilo_maggio_2020 = file_profilo_carico.profilo_carico_maggio;
profilo_giugno_2020 = file_profilo_carico.profilo_carico_giugno;
profilo_luglio_2020 = file_profilo_carico.profilo_carico_luglio;
profilo_agosto_2020 = file_profilo_carico.profilo_carico_agosto;
profilo_settembre_2020 = file_profilo_carico.profilo_carico_settembre;


%-----------------Pannelli Fotovoltaici----------------
% Pannelli fotovoltaici - Modello: Vertex TSM-DE21 635-670
% Singolo pannello specifiche:
% Potenza massima 670 Wp; Efficienza del 21,6 %
% Dimensioni pannello 2384×1303×35 mm
% Tensione di circuito aperto 46.1 Volt
% Corrente di corto circuito 18.62 A
% MPP: Vmpp = 38.2 V; Impp = 17.55 A
% Prezzo caduno € 850,00

numero_pannelli = 100;
superfice_pannello = 2.384 * (numero_pannelli * 1.303);
efficienza_pannello = 0.216;

% Potenza generata da un pannello fotovoltaico,  10 pannelli
Potenza_PV_gennaio_2020 = sol_gennaio_2020(:, :) * superfice_pannello * efficienza_pannello
Potenza_PV_febbraio_2020 = sol_febbraio_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_marzo_2020 = sol_marzo_2020(:, :) * superfice_pannello * efficienza_pannello;



%------------------------Batteria----------------------
% Batteria - PowerWall 2 - Tesla da 14 KWh - Costo € 6.000,00
% Scarica e carica batteria 5 KWh, per 10 secondi 7 KWh
% Round trip efficiency 90 %, 90 % di energia prelevabile in un ora
carica_scarica_ora = 5;      % KWh
Round_trip_efficiency = 0.9;
Numero_batterie = 15;
Capacita_Batteria = 14;      %KWh


% Range di mantenimento dello stato di carica
% SOC - stato di carica
SOCmax = 80 / 100 * Capacita_Batteria; % percento
SOCmin = 20 / 100 * Capacita_Batteria; % percento

% SOC iniziale
SOCinit = 50 / 100 * Capacita_Batteria; % percento







