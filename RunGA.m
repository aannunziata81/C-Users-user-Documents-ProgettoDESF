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
            
        end
        
        % Convert popc to Single-Column Matrix
        popc = popc(:);
        
        % Mutation
        for l = 1:nC
            
            % Perform Mutation
            popc(l).Position = round(Mutate(popc(l).Position, mu, sigma));
            % Check for Variable Bounds
            popc(l).Position = max(popc(1).Position, VarMin);
            popc(l).Position = min(popc(1).Position, VarMax);
            
            % NVV
            popc(l).NVV = MyFitnessFunctionS(popc(l).Position(1), popc(l).Position(2));
            
            % Evaluation
            popc(l).Cost = round(ObjectiveFunction(popc(l).Position));
            
            NVV_temp = popc(i).NVV;
            
            % Compare Solution to Best Solution Ever Found
%             if (popc(l).Cost < bestsol.Cost & NVV_temp < 20 )
%                 bestsol = popc(l);
%             end
            if NVV_temp <= bestNVV 
                bestNVV = NVV_temp;
                
                if popc(l).Cost < bestsol.Cost
                    bestsol = popc(l);
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
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);
        
    end
    
    
    % Results
    out.pop = pop;
    %bestsol.Position = round(bestsol.Position);
    %bestsol.Cost = round(bestsol.Cost);
    out.bestsol = bestsol;
    out.bestcost = bestcost;
    disp(bestsol);
end