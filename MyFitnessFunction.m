function d = MyFitnessFunction(x)
    [P_load P_pv SOCmin SOCmax SOCinit Round_trip_efficiency carica_scarica_ora] = parameter_pass();
    Erogazione = P_load - P_pv;
    %erogazione negativa: carico batteria
    %erogazione positiva: prende dalla batteria
    P_batt = zeros(1,24);
    SOC = SOCinit;
    delta_t = 1;
    NVV = 1;
    
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

    for i=1:length(Erogazione)
        if Erogazione(i)>0 
              if (SOC - (Erogazione(i)*delta_t) )>= SOCmin 
                  SOC = SOC  - (Erogazione(i)*delta_t);
              else 
                  SOC = SOC - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        elseif Erogazione(i)<0
              if (SOC - (Erogazione(i)*delta_t)) <= SOCmax
                  SOC = SOC - (Erogazione(i)*delta_t);
                  
              else
                  SOC = SOC - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        else
        end
        
    end
    
    %Lo stato della batteria deve tornare a quello iniziale dopo una
    %giornata
    if SOC ~= SOCinit
        NVV = NVV + 1;
    end
    %disp(int2str(NVV));
    %delta_p = (P_pv * x(1) + P_batt * x(2) + Residuo ) - P_load;
    %disp(int2str(NVV));
    delta_p = (P_pv * x(1) + Erogazione * x(2)  ) - P_load;
    d = sqrt(sum(delta_p.^2))*NVV;
    
end