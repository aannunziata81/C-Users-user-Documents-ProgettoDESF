function d = MyFitnessFunctionGrid(x)
%grid con tendenza stand alone
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();
    up = 1.2;
    down = 0.8;
    delta_t = 1;
    NVV = 0;
    fattore_moltiplicativo = 1;
    charge = capacita_batteria * x(2);
    charge_max = charge * SOC_M;
    charge_min = charge * SOC_m;
    charge_init = charge * SOC_init; 
    %limite_sup = charge_init * up;
    limite_inf = charge_init * down;
    E_load = P_load(1).month(1,:) * delta_t;
    E_pv = P_pv(1).month(1,:) * x(1) * delta_t;
    charge_var = charge_init;
    andamento_charge(1:24) = 0;
   
    Costo(1:24) = 0;
    E_bat(1:24) = 0;
    E_grid(1:24) = 0;
    
    for i = 1 : 24
        Energy = E_load(i) - E_pv(i);
        %energy positiva: ho bisogno di carica
        %energy negativa: ho un eccesso di carica
        if i > 8 || i < 19
            if Energy > 0 
                if (carica_scarica_ora * x(2)* Round_trip_efficiency) < Energy 
                    E_bat(i) = - carica_scarica_ora * x(2)* Round_trip_efficiency; %scarico batt
                    E_grid(i) = - E_bat(i) - Energy;
                    charge_var = charge_var + E_bat(i);%sottraggo
                    andamento_charge(i) = charge_var;
                    Costo(i) = E_grid(i); %negativo, spendo
                else 
                    E_bat(i) = - Energy;
                    charge_var = charge_var + E_bat(i);
                    andamento_charge(i) = charge_var;
                end
            elseif Energy < 0
                %vendo
                E_grid(i) = - Energy;%positivo
                Costo(i) = E_grid(i);
                andamento_charge(i) = charge_var;
            else
                andamento_charge(i) = charge_var;
            end
        else 
            if Energy > 0 
                E_bat(i) = carica_scarica_ora * x(2); %carico
                E_grid(i) = - Energy;%prendo dalla rete
                Costo(i) = E_grid(i) - E_bat(i);
                charge_var = charge_var + E_bat(i);%carico
                andamento_charge(i) = charge_var;
                
            elseif Energy < 0 %eccesso di carica
                if (carica_scarica_ora * x(2)) < - Energy
                    %di notte 
                    E_bat(i) = carica_scarica_ora * x(2);
                    E_grid(i) = - Energy - E_bat(i);%residuo
                    Costo(i) = E_grid(i);%vendo
                    charge_var = charge_var + E_bat(i);%carico
                    andamento_charge(i) = charge_var;
                else
                    %carico batt, quello che rimane lo vendo
                    E_bat(i) = - Energy ;
                    charge_var = charge_var + E_bat(i);%carico
                    andamento_charge(i) = charge_var;
                end
            else
                andamento_charge(i) = charge_var;
            end
        end
        if (andamento_charge(i) <= charge_min) || (andamento_charge(i) >= charge_max)
            NVV = NVV + 1;
        end
    end
    if charge_var < limite_inf 
        NVV = NVV + 1;
    end
    %disp(int2str(NVV));
    %disp(int2str(NVV)  + "| " + int2str(x(1)) + " f " + int2str(x(2)))
    if NVV == 0
        fattore_moltiplicativo = 0.1;
    else
        fattore_moltiplicativo = 1;
        for i=1:NVV
            fattore_moltiplicativo = fattore_moltiplicativo * 10;
            
        end
    end
    
    
    delta_E = (E_pv + E_bat + E_grid) - E_load;
    d = sqrt(sum(delta_E.^2)) * fattore_moltiplicativo;
    %disp(['distance:'  int2str(d) ' , ' int2str(x(1)) ' - ' int2str(x(2))])
end