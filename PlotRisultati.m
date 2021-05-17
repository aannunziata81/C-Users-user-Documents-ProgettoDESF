[Pl, Pp, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();

Npv = 11136;
Nb = 10;

deltat = 1;
E_carico = Pl * deltat;
E_pannellifoto = Pp * Npv * deltat;
[E_batteria, E_grid, d, Costo] = MyFitnessFunctionGridSPlus(Npv, Nb);

figure(1)
plot(E_carico, 'color', 'b')
hold on
plot(E_pannellifoto, 'color', 'r')
plot(E_batteria,'color', 'g')
title('Caratteristiche Energia batterie - Energia carico - Energia PV ')
legend('Energy load','Energy pv','Energy battery')
xlabel('Time [hour]');
ylabel('Energy [KWh]');
grid on 

chargeInit(1:24) =  capacita_batteria * Nb * SOC_init;
chargeMax(1:24) = capacita_batteria * Nb * SOC_M;
chargeMin(1:24) = capacita_batteria * Nb * SOC_m;

charge_ = chargeInit(1);
andamento_carica(1:24) = 0;

for i=1:24
    if E_batteria(i) > 0
        charge_ = charge_ + E_batteria(i);
        andamento_carica(i) = charge_;
        
    elseif E_batteria(i) < 0
        
        charge_ = charge_ + E_batteria(i);
        andamento_carica(i) = charge_;
        
    else
        andamento_carica(i) = charge_;
    end
end
disp(int2str(d))
figure(2)

plot(1:24, chargeMax, 'color', 'r','LineWidth',2)
hold on
plot(1:24, chargeMin,'color', 'r','LineWidth',2)
plot(1:24, chargeInit,'color', [0.9290 0.6940 0.1250])
plot(1:24, andamento_carica, 'color', [0.592, 0.2313 0.8156],'LineWidth',1.5)
title('Andamento batterie 24h')
legend( 'Charge max','Charge min','Charge init','Andamento carica')
xlabel('Time [hour]');
ylabel('Capacity of battery [KWh]');
grid on
figure(3)
plot (1:24, Costo)
ylabel('Energia')
grid on