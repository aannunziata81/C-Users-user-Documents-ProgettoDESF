function [E_load, E_pv, E_bat, E_grid, d, Costo, andamento_charge] = MyFitnessFunctionGridPlusAnnoS(x1, x2)
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();
    up = 1.2;
    down = 0.8;
    delta_t = 1;
    NVV = 0;
    fattore_moltiplicativo = 1;
    charge = capacita_batteria * x2;
    charge_max = charge * SOC_M;
    charge_min = charge * SOC_m;
    charge_init = charge * SOC_init; 
    %limite_sup = charge_init * up;
    limite_inf = charge_init * down;
    E_load = P_load(1).month(1,:) * delta_t;
    E_pv = P_pv(1).month(1,:) * x1 * delta_t;
    charge_var = charge_init;
    
    %i=8,9,10,11,12,13,14,15,16,17,18 fascia F1
    %i=7,19,20,21,22 fascia F2
    %i=23,24,1,2,3,4,5,6 fascia F3
    E_load(length(P_load(1).month), 1:24) = 0;
    E_pv(length(P_load(1).month), 1:24) = 0;
    Costo(length(P_load(1).month), 1:24) = 0;
    E_grid(length(P_load(1).month), 1:24) = 0;
    andamento_charge(length(P_load(1).month), 1:24) = 0;
    E_bat(length(P_load(1).month), 1:24) = 0;
    for k = 1 : 12 
        for j = 1 : length(P_load(k).month)
            NVV = 0;
            E_load(j,:) = P_load(k).month(j,:) * delta_t;
            E_pv(j,:) = P_pv(k).month(j,:) * x1 * delta_t;
            fattore_moltiplicativo = 1;
            for i = 1 : 24
                Energy = E_load(j,i) - E_pv(j,i);
                %energy positiva: ho bisogno di carica
                %energy negativa: ho un eccesso di carica
                if i > 8 || i < 19
                    if Energy > 0
                        if (carica_scarica_ora * x2* Round_trip_efficiency) < Energy
                            E_grid(j,i) = - Energy;
                            andamento_charge(j,i) = charge_var;
                            Costo(j,i) = E_grid(j,i); %negativo, compro tutto
                        else
                            E_bat(j,i) = - Energy; %prengo dalla batteria
                            charge_var = charge_var + E_bat(j,i);
                            andamento_charge(j,i) = charge_var;
                        end
                    elseif Energy < 0
                        %vendo
                        if (carica_scarica_ora * x2) < - Energy
                            E_grid(j,i) = - Energy;%positivo
                            Costo(j,i) = E_grid(j,i);
                            andamento_charge(j,i) = charge_var;
                        else
                            E_bat(j,i) = - Energy;
                            charge_var = charge_var + E_bat(j,i);
                            andamento_charge(j,i) = charge_var;
                        end
                    else
                        andamento_charge(j,i) = charge_var;
                    end
                else
                    if Energy > 0
                        E_bat(j,i) = carica_scarica_ora * x2; %carico
                        E_grid(j,i) = - Energy;%prendo dalla rete
                        Costo(j,i) = E_grid(j,i) - E_bat(j,i);
                        charge_var = charge_var + E_bat(j,i);%carico
                        andamento_charge(j,i) = charge_var;
                        
                    elseif Energy < 0 %eccesso di carica
                        if (carica_scarica_ora * x2) < - Energy
                            %di notte
                            E_bat(j,i) = carica_scarica_ora * x2;
                            E_grid(j,i) = - Energy - E_bat(j,i);%residuo
                            Costo(j,i) = E_grid(j,i);%vendo
                            charge_var = charge_var + E_bat(j,i);%carico
                            andamento_charge(j,i) = charge_var;
                        else
                            %carico batt, quello che rimane lo vendo
                            E_bat(j,i) = - Energy ;
                            charge_var = charge_var + E_bat(j,i);%carico
                            andamento_charge(j,i) = charge_var;
                        end
                    else
                        andamento_charge(j,i) = charge_var;
                    end
                end
                if (andamento_charge(j,i) <= charge_min) || (andamento_charge(j,i) >= charge_max)
                    NVV = NVV + 1;
                end
            end
            if charge_var < limite_inf
                NVV = NVV + 1;
            end
            %disp(int2str(NVV));
            %disp(int2str(NVV)  + "| " + int2str(x1) + " f " + int2str(x2))
            if NVV == 0
                fattore_moltiplicativo = 0.1;
            else
                for i=1:NVV
                    fattore_moltiplicativo = fattore_moltiplicativo * 10;
                    
                end
            end
        end
        if k < 12
            E_load(end+length(P_load(k+1).month), 1:24) = 0;
            E_pv(end+length(P_load(k+1).month), 1:24) = 0;
            Costo(end+length(P_load(k+1).month), 1:24) = 0;
            E_grid(end+length(P_load(k+1).month), 1:24) = 0;
            andamento_charge(end+length(P_load(k+1).month), 1:24) = 0;
            E_bat(end+length(P_load(k+1).month), 1:24) = 0;
        end
    end
    if charge_var < limite_inf 
        NVV = NVV + 1;
    end
    
    %disp(int2str(NVV));
    %disp(int2str(NVV)  + "| " + int2str(x1) + " f " + int2str(x2))
   
%     delta_E = (E_pv + E_bat + E_grid) - E_load;
%     d = sqrt(sum(delta_E.^2)) * NVV;
    d = NVV;
    %disp(['distance:'  int2str(d) ' , ' int2str(x1) ' - ' int2str(x2)])
end