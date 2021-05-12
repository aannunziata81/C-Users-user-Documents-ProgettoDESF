function d = MyFitnessFunctionS(x1, x2)
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora] = parameter_pass();
    
    Erogazione = P_load - P_pv * x1;
    %erogazione negativa: carico batteria
    %erogazione positiva: prende dalla batteria
    P_batt = zeros(1,24);
    delta_t = 1;
    NVV = 1;
    charge = capacita_batteria * x2;
    charge_max = charge * 0.8;
    charge_min = charge * 0.2;
    charge_init = charge * 0.5;
    
%     for i=1:length(Erogazione)
%         if Erogazione(i)>0
%             if (SOC - carica_scarica_ora*Round_trip_efficiency) >= SOCmin
%                 P_batt(i) = (carica_scarica_ora*Round_trip_efficiency)/delta_t;
%                 Residuo(i) = (SOC - carica_scarica_ora*Round_trip_efficiency) / delta_t;
%                 SOC = SOC - carica_scarica_ora*Round_trip_efficiency;
%             else
%                 Residuo(i) = Erogazione(i);
%             end    
%         elseif Erogazione(i)<0
%             if (SOC + carica_scarica_ora) <= SOCmax
%                 P_batt(i) = -carica_scarica_ora/delta_t;
%                 Residuo(i) = (SOC + carica_scarica_ora)/delta_t;
%                 SOC = SOC + carica_scarica_ora;
%             else
%                 Residuo(i) = Erogazione(i);
%             end
%         else
%             Residuo(i) = Erogazione(i);
%         end
%     end
    
%     for i=1:length(Residuo)
%         if Residuo(i)
%             
%         end
%     end
    charge_var = charge_init;
    for i=1:length(Erogazione)
        if Erogazione(i)>0 
              if (charge_var - (Erogazione(i)*delta_t) )>= charge_min 
                  %si può prendere dalla batteria
                  charge_var = charge_var  - (Erogazione(i)*delta_t);
              else 
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  %prendi dalla batteria ma si supera il limite
                  NVV = NVV + 1;
              end
        elseif Erogazione(i)<0
              if (charge_var - (Erogazione(i)*delta_t)) <= charge_max
                  %carica la batteria se può essere caricata
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  
              else
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  NVV = NVV + 1; %limite max violato
              end
        else
        end
        
    end
    if charge_var ~= charge_init
        NVV = NVV + 1;
    end
    d = NVV;
    
end