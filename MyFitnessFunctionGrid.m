function d = MyFitnessFunctionGrid(x)
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
    %i=8,9,10,11,12,13,14,15,16,17,18 fascia F1
    %i=7,19,20,21,22 fascia F2
    %i=23,24,1,2,3,4,5,6 fascia F3
    Costo(1:24) = 0;
    E_bat(1:24) = 0;
    E_grid(1:24) = 0;
    
    for i = 1 : 24
        Energy = E_load(i) - E_pv(i);
        if i > 8 | i < 19
            if Energy > 0 
                if (carica_scarica_ora * x(2)* Round_trip_efficiency) < Energy 
                    E_bat(i) = - carica_scarica_ora * x(2)* Round_trip_efficiency;%scarico batt
                    E_grid(i) = - E_bat(i) - Energy;
                    charge_var = charge_var + E_bat(i);%sottraggo
                    andamento_charge(i) = charge_var;
                    Costo(i) = E_grid(i); %negativo
                else 
                    E_bat(i) = - Energy;
                    charge_var = charge_var + E_bat(i);
                    andamento_charge(i) = charge_var;
                end
            elseif Energy < 0
                %vendo
                E_grid(i) = - Energy;%positivo
                Costo(i) = - E_grid(i);
                andamento_charge(i) = charge_var;
            else
                andamento_charge(i) = charge_var;
            end
        else 
            if Energy > 0 
                E_bat(i) = carica_scarica_ora * x(2);
                E_grid(i) = - Energy;%prendo dalla rete
                Costo(i) = E_grid(i) - E_bat(i);
                charge_var = charge_var + E_bat(i);%carico
                andamento_charge(i) = charge_var;
            elseif Energy < 0
                if (carica_scarica_ora * x(2)) < - Energy
                    %di notte carico
                    E_bat(i) = carica_scarica_ora * x(2);
                    E_grid(i) = - Energy - E_bat(i);%residuo
                    Costo(i) = E_grid(i);%vendo
                    charge_var = charge_var + E_bat(i);%carico
                    andamento_charge(i) = charge_var;
                else
                    %carico batt
                    E_bat(i) = carica_scarica_ora * x(2);
                    E_grid(i) = E_bat(i) + Energy;%residuo
                    Costo(i) = E_grid(i);
                    charge_var = charge_var + E_bat(i);%carico
                    andamento_charge(i) = charge_var;
                end
            else
                andamento_charge(i) = charge_var;
            end
        end
        if (andamento_charge(i) <= charge_min) | (andamento_charge(i) >= charge_max)
            NVV = NVV + 1;
        end
    end
    if charge_var ~= charge_init
        NVV = NVV + 1;
    end
    %disp(int2str(NVV));
    %disp(int2str(NVV)  + "| " + int2str(x(1)) + " f " + int2str(x(2)))
   
    delta_E = (E_pv + E_bat + E_grid) - E_load;
    d = sqrt(sum(delta_E.^2)) * NVV;
    %disp(['distance:'  int2str(d) ' , ' int2str(x(1)) ' - ' int2str(x(2))])
end