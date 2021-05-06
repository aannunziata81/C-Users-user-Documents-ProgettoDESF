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
sol_aprile_2020 = file_soleggiamento.soleggiamentoaprile;
sol_maggio_2020 = file_soleggiamento.soleggiamentomaggio;
sol_giugno_2020 = file_soleggiamento.soleggiamentogiugno;
sol_luglio_2020 = file_soleggiamento.soleggiamentoluglio;
sol_agosto_2020 = file_soleggiamento.soleggiamentoagosto;
sol_settembre_2020 = file_soleggiamento.soleggiamentosettembre;
sol_ottobre_2020 = file_soleggiamento.soleggiamentoottobre;
sol_novembre_2020 = file_soleggiamento.soleggiamentonovembre;
sol_dicembre_2020 = file_soleggiamento.soleggiamentodicembre;

soleggiamento_anno2020 = (sum(sum(sol_gennaio_2020)) + sum(sum(sol_febbraio_2020)) + sum(sum(sol_marzo_2020)) + sum(sum(sol_aprile_2020)) + sum(sum(sol_maggio_2020)) + sum(sum(sol_giugno_2020)) + sum(sum(sol_luglio_2020)) + sum(sum(sol_agosto_2020)) + sum(sum(sol_settembre_2020)) + sum(sum(sol_ottobre_2020)) + sum(sum(sol_novembre_2020)) + sum(sum(sol_dicembre_2020))) / 1000;



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
profilo_ottobre_2020 = file_profilo_carico.profilo_carico_ottobre;
profilo_novembre_2020 = file_profilo_carico.profilo_carico_novembre;
profilo_dicembre_2020 = file_profilo_carico.profilo_carico_dicembre;



% Consumo annuo del carico
profilo_carico_anno2020 = sum(sum(profilo_gennaio_2020)) + sum(sum(profilo_febbraio_2020)) + sum(sum(profilo_marzo_2020)) + sum(sum(profilo_aprile_2020)) + sum(sum(profilo_maggio_2020)) + sum(sum(profilo_giugno_2020)) + sum(sum(profilo_luglio_2020)) + sum(sum(profilo_agosto_2020)) + sum(sum(profilo_settembre_2020)) + sum(sum(profilo_ottobre_2020)) + sum(sum(profilo_novembre_2020)) + sum(sum(profilo_dicembre_2020));




%-----------------Pannelli Fotovoltaici----------------
% Pannelli fotovoltaici - Modello: Vertex TSM-DE21 635-670
% Singolo pannello specifiche:
% Potenza massima 670 Wp; Efficienza del 21,6 %
% Dimensioni pannello 2384×1303×35 mm
% Tensione di circuito aperto 46.1 Volt
% Corrente di corto circuito 18.62 A
% MPP: Vmpp = 38.2 V; Impp = 17.55 A
% Prezzo caduno € 850,00

% design margin
K = 0.8;

% numero di pannelli
num_PV = profilo_carico_anno2020 / (soleggiamento_anno2020 * K);


% previsione area: circa 7000 m^2
superfice_pannello = 2.384 * 1.303;
efficienza_pannello = 0.216;

% Potenza generata da un pannello fotovoltaico,  
Potenza_PV_gennaio_2020 = sol_gennaio_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_febbraio_2020 = sol_febbraio_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_marzo_2020 = sol_marzo_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_aprile_2020 = sol_aprile_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_maggio_2020 = sol_maggio_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_giugno_2020 = sol_giugno_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_luglio_2020 = sol_luglio_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_agosto_2020 = sol_agosto_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_settembre_2020 = sol_settembre_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_ottobre_2020 = sol_ottobre_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_novembre_2020 = sol_novembre_2020(:, :) * superfice_pannello * efficienza_pannello;
Potenza_PV_dicembre_2020 = sol_dicembre_2020(:, :) * superfice_pannello * efficienza_pannello;


%------------------------Batteria----------------------
% Batteria - PowerWall 2 - Tesla da 14 KWh - Costo € 6.000,00
% Scarica e carica batteria 5 KWh, per 10 secondi 7 KWh
% Round trip efficiency 90 %, energia prelevabile in un'ora
carica_scarica_ora = 5;      % KWh
Round_trip_efficiency = 0.9;
%Numero_batterie = 15;
Capacita_Batteria = 14;      %KWh


% Range di mantenimento dello stato di carica
% SOC - stato di carica
SOCmax = 90 / 100 * Capacita_Batteria; %KWh
SOCmin = 20 / 100 * Capacita_Batteria; %KWh

% SOC iniziale
SOCinit = 50 / 100 * Capacita_Batteria; %KWh



%-----------------------Prezzi fasce-------------------
% [(PM x energia prodotta) - (PUN x energia utilizzata)] 
% F1, F2, F3
% Vendita e Acquisto
prezzo_vendita_energia_elettrica = 0.04018;
file_fasce_orarie = load('fasceorarie');
fasce_orarie_gennaio = file_fasce_orarie.fasceorariegennaio;
fasce_orarie_febbraio = file_fasce_orarie.fasceorariefebbraio;
fasce_orarie_marzo = file_fasce_orarie.fasceorariemarzo;
fasce_orarie_aprile = file_fasce_orarie.fasceorarieaprile;
fasce_orarie_maggio = file_fasce_orarie.fasceorariemaggio;
fasce_orarie_giugno = file_fasce_orarie.fasceorariegiugno;
fasce_orarie_luglio = file_fasce_orarie.fasceorarieluglio;
fasce_orarie_agosto = file_fasce_orarie.fasceorarieagosto;
fasce_orarie_settembre = file_fasce_orarie.fasceorariesettembre;
fasce_orarie_ottobre = file_fasce_orarie.fasceorarieottobre;
fasce_orarie_novembre = file_fasce_orarie.fasceorarienovembre;
fasce_orarie_dicembre = file_fasce_orarie.fasceorariedicembre;

%----------------------Inverter------------------------
% Rappresentazione qualitativa della caratteristica dell'inverter
% basandosi sulla potenza che può generare l'impianto PV
% vedi appunti

potenza_nominale_inveter = 900 * 670;
campioni = 100;
for i = 1 : campioni
    potenza_rapporto(i) = i / campioni;
end

%figure(1)
%plot(potenza_rapporto, eta_inverter)

%%-----------------------Parameters----------------------
global Ppv Pload Cbatt SOC_min SOC_max SOC_init
Ppv = Potenza_PV_maggio_2020(1, :)./ 1000;
Pload = profilo_maggio_2020(1, :);
Cbatt = 14;
SOC_min = SOCmin;
SOC_max = SOCmax;
SOC_init = SOCinit;

%%---------------------------Optimization Algorithm------

% Problem Definition

problem.ObjectiveFunction = @(x) MyFitnessFunction(x);
problem.nVar = 2;
problem.VarMin = [1  1];
problem.VarMax = [5000 200];

% GA Parameters
params.MaxIt = 1000;
params.nPop = 100;

params.beta = 1;
params.pC = 1;
params.mu = 0.02;
params.sigma = 0.1;
params.gamma = 0.1;

% Run GA
out = RunGA(problem, params);

% Results
%figure;
%plot(out.bestcost, 'LineWidth', 2);
%semilog(out.bestcost, 'LineWidth', 2);
%xlabel('Iterations');
%ylabel('Best Cost');
%grid on;