function d = MyFitnessFunctionGridPlusAnnoLimit(x)
%caricare le batterie appena possibile
% 
    [P_load, P_pv, capacita_batteria, Round_trip_efficiency, carica_scarica_ora, SOC_M, SOC_m, SOC_init,  fasce_orarie_2020, prezzo_vendita_energia_elettrica] = parameter_pass();
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
    Costo(1:24) = 0;%kW
    E_bat(1:24) = 0;
    E_grid(1:24) = 0;
    d = 0;
    a = 0;
%     NVV = 0;
    
    for k = 1 : 12
 
        for j = 1 : length(P_load(k).month)
            NVV = 0;
            E_load = P_load(k).month(j,:) * delta_t;
            E_pv = P_pv(k).month(j,:) * x(1) * delta_t;
            fattore_moltiplicativo = 1;
            for i = 1 : 24
                Energy = E_load(i) - E_pv(i);
                %energy positiva: ho bisogno di carica
                %energy negativa: ho un eccesso di carica
                if (i > 8 && i < 19)
                    if Energy > 0
                        if (carica_scarica_ora * x(2) * Round_trip_efficiency) < Energy
                            if (charge_var - carica_scarica_ora * x(2) * Round_trip_efficiency) >= charge_min
                                E_bat(i) = - carica_scarica_ora * x(2) * Round_trip_efficiency; %scarico batt
                                E_grid(i) = - E_bat(i) - Energy;
                                charge_var = charge_var + E_bat(i);
                                andamento_charge(i) = charge_var;
                                Costo(i) = E_grid(i); %negativo
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
                if (andamento_charge(i) <= charge_min) || (andamento_charge(i) >= charge_max)
                    NVV = NVV + 1;
                end
            end
            costo_matrice(j + a, :) = Costo ;
            
            
            if charge_var < limite_inf
                NVV = NVV + 1;
            end
            %disp(int2str(NVV));
            %disp(int2str(NVV)  + "| " + int2str(x(1)) + " f " + int2str(x(2)))
                if NVV == 0
                    fattore_moltiplicativo = 0.1;
                else
                    for i=1:NVV
                        fattore_moltiplicativo = fattore_moltiplicativo * 10;

                    end
                end


                delta_E = (E_pv + E_bat + E_grid) - E_load;


                d = d + sqrt(sum(delta_E.^2)) * fattore_moltiplicativo;
                
        end
        a = a + length(P_load(k).month);
    end
    
    temp = 0;
    ricavo_annuale = 0;
    acquisto_annuale = 0;
    
    NVV = 0;
    fattore_moltiplicativo = 1;
    for m = 1:12
        for g = 1:length(P_load(m).month)
            for z = 1:24
                if costo_matrice(g + temp, z) > 0
                    guadagno(g + temp, z) = costo_matrice(g + temp, z)* prezzo_vendita_energia_elettrica;
                    ricavo_annuale = ricavo_annuale + guadagno(g + temp, z);
                else
                    guadagno(g + temp, z) = costo_matrice(g + temp, z)* fasce_orarie_2020(m).month(g,z);
                    acquisto_annuale = acquisto_annuale + guadagno(g + temp, z);
                end
                
            end
        end
        temp = temp + length(P_load(m).month);
        
    end
    
    if ricavo_annuale + acquisto_annuale > 0
        
    else
        NVV = NVV + 1;
    end
    
   
    if NVV == 0
        fattore_moltiplicativo = 0.1;
    else
        for i=1:NVV
            fattore_moltiplicativo = fattore_moltiplicativo * 10;
            
        end
    end
     d = d * fattore_moltiplicativo;

    %disp(['distance:'  int2str(d) ' , ' int2str(x(1)) ' - ' int2str(x(2))])
end
