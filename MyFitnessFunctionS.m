function [d, E_bat] = MyFitnessFunctionS(x1, x2)
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();
    
    delta_t = 1;
    NVV = 1;
    charge = capacita_batteria * x2;
    charge_max = charge * SOC_M;
    charge_min = charge * SOC_m;
    charge_init = charge * SOC_init;

    E_load = P_load.month(1,:) * delta_t;
    E_pv = P_pv.month(1,:) * x1 * delta_t;
    charge_var = charge_init;
    
    for i = 1 : 24
        %E_bat(i) = - (charge * carica_scarica_ora * x2 * Round_trip_efficiency);
        Energy = E_load(i) - E_pv(i);
        if Energy > 0
            
            if (carica_scarica_ora * x2 * Round_trip_efficiency) < Energy
                E_bat(i) = -carica_scarica_ora * x2 * Round_trip_efficiency;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
                
            else
                E_bat(i) = - Energy;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
            end
            
        elseif Energy < 0
            %ho energia in eccesso 
            if (carica_scarica_ora * x2) < - Energy
                %carico la batteria
                E_bat(i) = carica_scarica_ora * x2;
                charge_var = charge_var + E_bat(i);
                andamento_charge(i) = charge_var;
            else
                %energia troppo grande da mettere in batteria
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


    d = NVV;
end