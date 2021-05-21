
[Pl, Pp, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();

Npv = 1456;
Nb = 982;
deltat = 1;
[E_carico, E_pannellifoto, E_batteria, E_grid, d, Costo, andamento_charge] = MyFitnessFunctionGridPlusAnnoS(Npv, Nb);

% figure(1)
% plot(E_carico, 'color', 'b')
% hold on
% plot(E_pannellifoto, 'color', 'r')
% plot(E_batteria,'color', 'g')
% title('Caratteristiche Energia batterie - Energia carico - Energia PV ')
% legend('Energy load','Energy pv','Energy battery')
% xlabel('Time [hour]');
% ylabel('Energy [KWh]');
% grid on 

chargeInit(1:24) =  capacita_batteria * Nb * SOC_init;
chargeMax(1:24) = capacita_batteria * Nb * SOC_M;
chargeMin(1:24) = capacita_batteria * Nb * SOC_m;
ore = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',...
'13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'};
figure(1)
for i = 1:1
   
    in = 0;
    %fin = 24;
    h = 24;
    %length(Pl(i).month)*0.5
    for j = 1:15
    %for kk = in:fin
        %fin = j * fin;
        
        for kk = 1:24
        %for j = 1:length(Pl(i).month)
            y_bat(kk + h*in) = E_batteria(j,kk);
            y_load(kk + h*in) = E_carico(j,kk);
            y_pv(kk + h*in) = E_pannellifoto(j,kk);
        end
        in = in + 1;
        
    end
    plot(y_bat)
    hold on
    plot(y_load)
    plot(y_pv)
    set(gca,'xtick',1:24*15,...
        'xticklabel',ore);
end

%%set(gca,'xtick',1:24,...
%          'xticklabel',ore);
disp(int2str(d))
% figure(2)
% 
% plot(1:24, chargeMax, 'color', 'r','LineWidth',2)
% hold on
% plot(1:24, chargeMin,'color', 'r','LineWidth',2)
% plot(1:24, chargeInit,'color', [0.9290 0.6940 0.1250])
% plot(1:24, andamento_carica, 'color', [0.592, 0.2313 0.8156],'LineWidth',1.5)
% title('Andamento batterie 24h')
% legend( 'Charge max','Charge min','Charge init','Andamento carica')
% xlabel('Time [hour]');
% ylabel('Capacity of battery [KWh]');
% grid on
% figure(3)
% plot (1:24, Costo)
% ylabel('Energia')
% grid on