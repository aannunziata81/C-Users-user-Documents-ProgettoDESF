function out = RunGA(problem, params)
    % Problem
    ObjectiveFunction = problem.ObjectiveFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    VarSize = [1, nVar];
    % Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    pC = params.pC;
    nC = round(pC*nPop/2)*2;
    mu = params.mu;
    sigma = params.sigma;
    gamma = params.gamma; 
    
    % Template for Empty Individuals
    empty_individual.Position = [];
    empty_individual.Cost = [];
    empty_individual.NVV = [];
    
    % Best Solution Ever Found
    bestsol.Cost = inf;
    bestNVV = inf;
    % Initialization
    pop = repmat(empty_individual, nPop, 1);
    for i = 1 : nPop
        

        % Generate Random Solution
%         pop(i).Position = unifrnd(VarMin, VarMax, VarSize);

        pop(i).Position(1) = randi([VarMin(1) VarMax(1)], 1);
        pop(i).Position(2) = randi([VarMin(2) VarMax(2)], 1);
        
        % NVV - vincoli violati
        pop(i).NVV = MyFitnessFunctionS(pop(i).Position(1), pop(i).Position(2));
        
        % Evaluate Solution
        pop(i).Cost = round(ObjectiveFunction(pop(i).Position));
        %disp("primi individui " + num2str(pop(i).Position(1)) + ' | ' + num2str(pop(i).Position(2) ))
        
        % NVV da evidenziare
        NVV_temp = pop(i).NVV;
        % Compare Solution to Best Solution Ever Found
        if NVV_temp <= bestNVV
            bestNVV = NVV_temp;
            if pop(i).Cost < bestsol.Cost
                    bestsol = pop(i);
            end
            
        end
        
    end
    
    
    % Best Cost of Iterations
    bestcost = nan(MaxIt, 1);
    
    % Main Loop
    for it = 1:MaxIt
        
        % Selection Probabilities
        c = [pop.Cost];
        avgc = mean(c); %c barrato
        if avgc ~= 0
            c = c/avgc;
        end
        probs = exp(-beta*c);
        
        % Initialize Offsprings Population
        popc = repmat(empty_individual, nC/2, 2);
        
        % Crossover
        for k = 1:nC/2
            
            % Select Parents
            p1 = pop(RouletteWheelSelection(probs));
            p2 = pop(RouletteWheelSelection(probs));
            
            % Perform Crossover
            [popc(k, 1).Position, popc(k, 2).Position] = ...
                UniformCrossover(p1.Position, p2.Position, gamma);
            %disp("crossover " + num2str(popc(k, 1).Position(1)) + ' | ' + num2str(popc(k, 1).Position(2) ))

        end
        
        % Convert popc to Single-Column Matrix
        popc = popc(:);

        % Mutation
        for m = 1:nC
            
            % Perform Mutation
            popc(m).Position = round(Mutate(popc(m).Position, mu, sigma));
            % Check for Varialme Bounds
            popc(m).Position = max(popc(m).Position, VarMin);
            popc(m).Position = min(popc(m).Position, VarMax);
            
            %disp("mutate " + num2str(popc(m).Position(1)) + ' | ' + num2str(popc(m).Position(2)))
            % NVV
            popc(m).NVV = MyFitnessFunctionS(popc(m).Position(1), popc(m).Position(2));
            
            % Evaluation
            popc(m).Cost = round(ObjectiveFunction(popc(m).Position));
            %disp("costo: " + int2str(popc(m).Cost))
            NVV_temp = popc(i).NVV;
            
            
            
            %disp('mutate ' + num2str(popc(m).Position))
            
            % Compare Solution to Best Solution Ever Found
%             if (popc(l).Cost < bestsol.Cost & NVV_temp < 20 )
%                 bestsol = popc(l);
%             end
            if NVV_temp <= bestNVV 
                bestNVV = NVV_temp;
                
                if popc(m).Cost < bestsol.Cost
                    bestsol = popc(m);
                end
            end
                
            
        end
        
        % Merge and Sort Populations
        pop = SortPopulation([pop; popc]);
        
        % Remove Extra Individuals
        pop = pop(1:nPop);
        
        % Update Best Cost of Iteration
        bestcost(it) = bestsol.Cost;

        % Display Itertion Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it)) ' - ' num2str(bestsol.Position(1)) ' | ' num2str(bestsol.Position(2))]);
        
    end
    
    
    % Results
    out.pop = pop;
    %bestsol.Position = round(bestsol.Position);
    %bestsol.Cost = round(bestsol.Cost);
    out.bestsol = bestsol;
    out.bestcost = bestcost;
    disp(bestsol);
end