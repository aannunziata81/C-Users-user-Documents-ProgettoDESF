function d = MyFitnessFunction(x)
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora] = parameter_pass();
    
    Erogazione = P_load - P_pv * x(1);
    %erogazione negativa: carico batteria
    %erogazione positiva: prende dalla batteria
    P_batt = zeros(1,24);
    delta_t = 1;
    NVV = 1;
    charge = capacita_batteria * x(2);
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
                  charge_var = charge_var  - (Erogazione(i)*delta_t);
                  %prendo dalla batteria
              else 
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        elseif Erogazione(i)<0
              if (charge_var - (Erogazione(i)*delta_t)) <= charge_max
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  
              else
                  charge_var = charge_var - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        else
        end
        
    end
    %disp(int2str(charge_var))
    %Lo stato della batteria deve tornare a quello iniziale dopo una
    %giornata
    if charge_var ~= charge_init
        NVV = NVV + 1;
    end
    %disp(int2str(NVV));
    %delta_p = (P_pv * x(1) + P_batt * x(2) + Residuo ) - P_load;
    %disp(int2str(NVV));
    %disp(int2str(NVV)  + "| " + int2str(x(1)) + " f " + int2str(x(2)))
    delta_p = (P_pv * x(1) + capacita_batteria * x(2)) - P_load;
    d = sqrt(sum(delta_p.^2))*NVV;
    
end