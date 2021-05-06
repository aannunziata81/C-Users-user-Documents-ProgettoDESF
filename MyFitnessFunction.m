function d = MyFitnessFunction(x)
    
    [Ppv Pload Cbatt SOC_min SOC_max SOC_init] = parameter_pass();
    
    for i=1:length(Pload)
        Erogazione(i) = Pload(i)-Ppv(i);
        %erogazione negativa: carico batteria
        %erogazione positiva: prende dalla batteria
    end
    SOC = SOC_init;
    delta_t = 1;
    NVV = 1;
    for i=1:length(Erogazione)
        if Erogazione(i)>0 
              if ((SOC / delta_t) - Erogazione(i))>=SOC_min 
                  SOC = (SOC / delta_t) - (Erogazione(i)*delta_t);
              else 
                  SOC = (SOC / delta_t) - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        elseif Erogazione(i)<0
              if ((SOC / delta_t) - (Erogazione(i)*delta_t)) >= SOC_max
                  SOC = (SOC / delta_t) - (Erogazione(i)*delta_t);
                  
              else
                  SOC = (SOC / delta_t) - (Erogazione(i)*delta_t);
                  NVV = NVV + 1;
              end
        else
        end
        
    end
    
    %Lo stato della batteria deve tornare a quello iniziale dopo una
    %giornata
    if SOC ~= SOC_init
        NVV = NVV + 1;
    end
    %disp(int2str(NVV));
    delta_p = (Ppv * x(1) + Erogazione * x(2)) - Pload;

    d = sqrt(sum(delta_p.^2))*NVV;
    
end