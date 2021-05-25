
[Pl, Pp, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();

Npv = 225;
Nb = 78;
deltat = 1;
[E_carico, E_pannellifoto, E_batteria, E_grid, d, Costo, andamento_charge] = MyFitnessFunctionGridPlusAnnoLimitS(Npv, Nb);

% figure(1)
% plot(E_carico(1,:), 'color', 'b')
% hold on
% plot(E_pannellifoto(1,:), 'color', 'r')
% plot(E_batteria(1,:),'color', 'g')
% title('Caratteristiche Energia batterie - Energia carico - Energia PV ')
% legend('Energy load','Energy pv','Energy battery')
% xlabel('Time [hour]');
% ylabel('Energy [KWh]');
% grid on 
s = 1;
% chargeInit =  capacita_batteria * Nb * SOC_init;
% chargeMax = ;
% chargeMin(1:24) = capacita_batteria * Nb * SOC_m;
ore = {'1', '', '', '', '', '', '', '', '', '', '', '',...
'', '', '', '', '', '', '', '', '', '', '', '24'};
stringa =[ "Febbraio", "Maggio", "Ottobre"];
for i = [2 5 10]
    clear y_bat y_load y_pv
    lunghezza = 0;
    for f = 1:(i-1)
        lunghezza = lunghezza + length(Pl(f).month);
    end
        
 	figure('Name',stringa(s),'NumberTitle','off');
    in = 0;
    %fin = 24;
    h = 24;
    %length(Pl(i).month)*
    for j = 1: 7
    %for kk = in:fin
        %fin = j * fin;
        
        for kk = 1:24
        %for j = 1:length(Pl(i).month)
            y_bat(kk + h*in) = E_batteria(lunghezza + j,kk);
            y_load(kk + h*in) = E_carico(lunghezza + j,kk);
            y_pv(kk + h*in) = E_pannellifoto(lunghezza + j,kk);
        end
        in = in + 1;
        
    end
    
    plot(y_bat)
    hold on
    plot(y_load)
    plot(y_pv)
    s = s + 1;
    set(gca,'xtick',1:24*7,...
        'xticklabel', ore);
end

%%set(gca,'xtick',1:24,...
%          'xticklabel',ore);

s = 1;

for i = [2 5 10]
    clear y_and
    lunghezza = 0;
    for f = 1:(i-1)
        lunghezza = lunghezza + length(Pl(f).month);
    end
    
 	figure('Name',stringa(s),'NumberTitle','off');
    in = 0;
    
    %subplot(1,1,i)
    in = 0;
    %fin = 24;
    chargeMax =0;
    chargeMin=0;
    chargeInit = 0;
    h = 24;
    
    %length(Pl(i).month)*
    for j = 1:7
    %for kk = in:fin
        %fin = j * fin;
        
        for kk = 1:24
        %for j = 1:length(Pl(i).month)
            y_and(kk + h*in) = andamento_charge(lunghezza + j,kk);
        end
        in = in + 1;
        
    end
    chargeMax(1:24*7) = capacita_batteria * Nb * SOC_M;
    chargeMin(1:24*7) = capacita_batteria * Nb * SOC_m;
    chargeInit(1:24*7) =  capacita_batteria * Nb * SOC_init;
    s = s + 1;
    plot(chargeMax, 'color', 'r','LineWidth',2)
    hold on
    plot(chargeMin,'color', 'r','LineWidth',2)
    plot(chargeInit,'color', [0.9290 0.6940 0.1250])
    plot(y_and, 'color', [0.592, 0.2313 0.8156],'LineWidth',1.5)
    
    set(gca,'xtick',1:24*7,...
        'xticklabel', ore);
end



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
