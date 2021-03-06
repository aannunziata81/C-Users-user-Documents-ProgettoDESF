function d = MyFitnessFunctionGridPlusAnno(x)
%caricare le batterie appena possibile
% x(1) = 19;
% x(2) = 53;
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init] = parameter_pass();
    up = 1.2;
    down = 0.8;
    delta_t = 1;
    charge = capacita_batteria * x(2);
    charge_max = charge * SOC_M;
    charge_min = charge * SOC_m;
    charge_init = charge * SOC_init; 
    %limite_sup = charge_init * up;
    limite_inf = charge_init * down;

    charge_var = charge_init;
    andamento_charge(1:24) = 0;
    Costo(1:24) = 0;
    E_bat(1:24) = 0;
    E_grid(1:24) = 0;
    d = 0;
    NVV = 0;
    
    for k = 1 : 12
 
        for j = 1 : length(P_load(k).month)
            
            E_load = P_load(k).month(j,:) * delta_t;
            E_pv = P_pv(k).month(j,:) * x(1) * delta_t;
%             fattore_moltiplicativo = 1;
            for i = 1 : 24
                Energy = E_load(i) - E_pv(i);
                %energy positiva: ho bisogno di carica
                %energy negativa: ho un eccesso di carica
                if (i > 8 && i < 19)
                    if Energy > 0
                        if (carica_scarica_ora * x(2) * Round_trip_efficiency) < Energy
                            if charge_var - carica_scarica_ora * x(2) * Round_trip_efficiency >= charge_min
                                E_bat(i) = - carica_scarica_ora * x(2) * Round_trip_efficiency; %scarico batt
                                E_grid(i) = - E_bat(i) - Energy;
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                                Costo(i) = E_grid(i); %negativo
                            elseif not(under_bound)
                                E_bat(i) = - carica_scarica_ora * x(2) * Round_trip_efficiency; %scarico batt
                                E_grid(i) = - E_bat(i) - Energy;
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                                Costo(i) = E_grid(i); %negativo
                                under_bound = 1;
                            else
                                E_grid(i) = - Energy;
                                andamento_charge(i) = charge_var;
                                Costo(i) = E_grid(i); %negativo, compro tutto
                            end
                        else
                            if charge_var - Energy >= charge_min
                                E_bat(i) = - Energy; %prendo dalla batteria
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                            elseif not(under_bound)
                                E_bat(i) = - Energy; %prendo dalla batteria
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                                under_bound = 1;
                            else
                                E_grid(i) = - Energy;
                                andamento_charge(i) = charge_var;
                                Costo(i) = E_grid(i); %negativo, compro tutto
                            end
                        end
                    elseif Energy < 0
                        %vendo
                        if (carica_scarica_ora * x(2)) < - Energy
                            E_grid(i) = - Energy;%positivo
                            Costo(i) = E_grid(i);
                            andamento_charge(i) = charge_var;
                        else
                            if charge_var - Energy <= charge_max
                                E_bat(i) = - Energy;
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                            elseif not(over_bound)
                                E_bat(i) = - Energy;
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                                over_bound = 1;
                            else
                                E_grid(i) = - Energy;%positivo
                                Costo(i) = E_grid(i);
                                andamento_charge(i) = charge_var;
                            end
                        end
                    else
                        andamento_charge(i) = charge_var;
                    end
                else
                    if Energy > 0
                        if carica_scarica_ora * x(2) + charge_var <= charge_max
                            E_bat(i) = carica_scarica_ora * x(2); %carico
                            E_grid(i) = - Energy;%prendo dalla rete
                            Costo(i) = E_grid(i) - E_bat(i);
                            charge_var = charge_var + E_bat(i);%carico
                            andamento_charge(i) = charge_var;
                        elseif not(over_bound)
                            E_bat(i) = carica_scarica_ora * x(2); %carico
                            E_grid(i) = - Energy;%prendo dalla rete
                            Costo(i) = E_grid(i) - E_bat(i);
                            charge_var = charge_var + E_bat(i);%carico
                            andamento_charge(i) = charge_var;
                            over_bound = 1;
                        else
                            E_grid(i) = - Energy;%prendo dalla rete
                            Costo(i) = E_grid(i);
                            andamento_charge(i) = charge_var;
                        end

                        
                    elseif Energy < 0 %eccesso di carica
                        if (carica_scarica_ora * x(2)) < - Energy
                            if carica_scarica_ora * x(2) + charge_var <= charge_max
                                %di notte
                                E_bat(i) = carica_scarica_ora * x(2);
                                E_grid(i) = - Energy - E_bat(i);%residuo
                                Costo(i) = E_grid(i);%vendo
                                charge_var = charge_var + E_bat(i);%carico
                                andamento_charge(i) = charge_var;
                            elseif not(over_bound)
                                %di notte
                                E_bat(i) = carica_scarica_ora * x(2);
                                E_grid(i) = - Energy - E_bat(i);%residuo
                                Costo(i) = E_grid(i);%vendo
                                charge_var = charge_var + E_bat(i);%carico
                                andamento_charge(i) = charge_var;
                                over_bound = 1;
                            else
                                E_grid(i) = - Energy;%
                                Costo(i) = E_grid(i);%vendo
                                andamento_charge(i) = charge_var;
                            end
                        else
                            if (- Energy + charge_var) <= charge_max
                                %
                                E_bat(i) = - Energy ;
                                charge_var = charge_var + E_bat(i);%carico
                                andamento_charge(i) = charge_var;
                            elseif not(over_bound)
                                E_bat(i) = - Energy ;
                                charge_var = charge_var + E_bat(i);%carico
                                andamento_charge(i) = charge_var;
                                over_bound = 1;
                            else
                                E_grid(i) = - Energy;
                                Costo(i) = E_grid(i);%vendo
                                andamento_charge(i) = charge_var;
                            end
                        end
                    else
                        andamento_charge(i) = charge_var;
                    end
                end
                if (charge_var >= charge_min)
                    under_bound = 0;
                end
                if (charge_var <= charge_max)
                    over_bound = 0;
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
            

%             d = d + sqrt(sum(delta_E.^2)) * fattore_moltiplicativo;
        end
    end
    d = NVV;
    %disp(['distance:'  int2str(d) ' , ' int2str(x(1)) ' - ' int2str(x(2))])
end
