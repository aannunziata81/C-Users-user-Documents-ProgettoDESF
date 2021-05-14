function d = MyFitnessFunction(x)
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();
    
    delta_t = 1;
    NVV = 1;
    charge = capacita_batteria * x(2);
    charge_max = charge * SOC_M;
    charge_min = charge * SOC_m;
    charge_init = charge * SOC_init; 

    E_load = P_load * delta_t;
    E_pv = P_pv * x(1) * delta_t;
    charge_var = charge_init;
    andamento_charge(1:24) = 0;
    
    for i = 1 : 24
        Energy = E_load(i) - E_pv(i);
        %E_bat(i) = - (charge * carica_scarica_ora * x(2) * Round_trip_efficiency);
        if Energy > 0
            %Energy positiva significa che c'è bisogno di energia da
            %erogare oltre i pannelli
            if (carica_scarica_ora * x(2) * Round_trip_efficiency) < Energy
                %l'energia che si può erogare è inferiore all'energia che
                %serve
                E_bat(i) = -carica_scarica_ora * x(2) * Round_trip_efficiency;
                %E_bat(i)= E_bat(i) - Energy;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
                %quindi viola il vincolo 
            else
                %si può erogare l'energia necessaria
                E_bat(i) = -Energy;
                %E_bat(i)= E_bat(i) - Energy;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
            end

        elseif Energy < 0
            %Energy negativa significa che c'è eccesso di carica
            if (carica_scarica_ora * x(2)) < - Energy
                
                E_bat(i) =  carica_scarica_ora * x(2);
                charge_var = charge_var + E_bat(i);%carico la batteria
                andamento_charge(i) = charge_var;
            else
                E_bat(i) = - Energy;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
            end
        else
            E_bat(i) = 0;
            andamento_charge(i) = charge_var;
        end
        
        
        if (andamento_charge(i) <= charge_min) | (andamento_charge(i) >= charge_max)
            NVV = NVV + 1;
        end
    end

    %disp(int2str(NVV));
    %delta_p = (P_pv * x(1) + P_batt * x(2) + Residuo ) - P_load;
    %disp(int2str(NVV));
    %disp(int2str(NVV)  + "| " + int2str(x(1)) + " f " + int2str(x(2)))
   
    delta_E = (E_pv + E_bat ) - E_load;
    d = sqrt(sum(delta_E.^2)) * NVV;
    
    %disp(['distance:'  int2str(d) ' , ' int2str(x(1)) ' - ' int2str(x(2))])
end