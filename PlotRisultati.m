
[Pl, Pp, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init, fasce_orarie_2020, prezzo_vendita_energia_elettrica] = parameter_pass();

Npv = 1018;
Nb = 40;
deltat = 1;
[E_carico, E_pannellifoto, E_batteria, E_grid, d, Costo, andamento_charge] = MyFitnessFunctionGridPlusAnnoLimitS(Npv, Nb);

s = 1;
% chargeInit =  capacita_batteria * Nb * SOC_init;
% chargeMax = ;
% chargeMin(1:24) = capacita_batteria * Nb * SOC_m;

stringa =[ "Febbraio", "Maggio", "Ottobre"];
periodi = ["intermedio", "basso","alto" ];
for i = [2 5 10]
    clear y_bat y_load y_pv t
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
    t = datetime(2020,i,01,01,00,00):minutes(60):datetime(2020,i,01)+hours(168);
    hold on
    plot(t,y_load,'color', 'g')
    plot(t,y_pv, 'color', 'r')
    plot(t,y_bat, 'color', 'b')
    title('Caratteristiche Energia batterie - Energia carico - Energia PV del periodo a consumo '+ periodi(s))
    legend('Energy load','Energy pv','Energy battery')
    xlabel('Date [day-month-year hour:minute]');
    ylabel('Energy [KWh]');
    grid on
    xticks([t(12) t(36) t(60) t(84) t(108) t(132) t(156)])
    xtickformat('dd-MMM-yyyy HH:mm')
    s = s + 1;
end

s = 1;

for i = [2 5 10]
    clear y_and t
    lunghezza = 0;
    for f = 1:(i-1)
        lunghezza = lunghezza + length(Pl(f).month);
    end
    
 	figure('Name',stringa(s),'NumberTitle','off');
        
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
   
    
    t = datetime(2020,i,01,01,00,00):minutes(60):datetime(2020,i,01)+hours(168);
    plot(t, chargeMax, 'color', 'r','LineWidth',2)
    hold on
    plot(t, chargeMin,'color', 'r','LineWidth',2)
    plot(t, chargeInit,'color', [0.9290 0.6940 0.1250])
    plot(t, y_and, 'color', [0.592, 0.2313 0.8156],'LineWidth',1.5)
    title('Andamento batterie prima settimana di ' + stringa(s))
    legend('Charge max','Charge min','Charge init','Andamento carica')
    xlabel('Date [day-month-year hour:minute]');
    ylabel('Capacity of battery [KWh]');
    xticks([t(12) t(36) t(60) t(84) t(108) t(132) t(156)])
    xtickformat('dd-MMM-yyyy HH:mm')
    s = s + 1;
end
temp = 0;
ricavo_annuale = 0;
acquisto_annuale = 0;
for m = 1:12
    for g = 1:length(Pl(m).month)
        for z = 1:24
            if Costo(g + temp, z) > 0
                guadagno(g + temp, z) = Costo(g + temp, z)* prezzo_vendita_energia_elettrica;
                ricavo_annuale = ricavo_annuale + guadagno(g + temp, z);
            else
                guadagno(g + temp, z) = Costo(g + temp, z)* fasce_orarie_2020(m).month(g,z);
                acquisto_annuale = acquisto_annuale + guadagno(g + temp, z);
            end
            
        end
    end
    temp = temp + length(Pl(m).month);
end


s = 1;
for i = [2 5 10]
    clear y_and t
    lunghezza = 0;
    for f = 1:(i-1)
        lunghezza = lunghezza + length(Pl(f).month);
    end
    figure('Name',stringa(s),'NumberTitle','off');
    in = 0;
    h = 24;
    for j = 1:7
        for kk = 1:24
            y_costi(kk + h*in) = Costo(lunghezza + j,kk);
        end
        in = in + 1;
    end
    
    
    
    
    t = datetime(2020,i,01,01,00,00):minutes(60):datetime(2020,i,01)+hours(168);
    plot(t, y_costi)
    title('Andamento costi del mese di ' + stringa(s))
    xticks([t(12) t(36) t(60) t(84) t(108) t(132) t(156)])
    xtickformat('HH:mm')
    s = s +1;
end
