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
    
    % Best Solution Ever Found
    bestsol.Cost = inf;
    
    % Initialization
    pop = repmat(empty_individual, nPop, 1);
    for i = 1:nPop
        
        %unifrnd(problem.VarMin, problem.VarMax, VarSize)
        % Generate Random Solution
        pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
        
        %randi([VarMin VarMax], 1);   
        %pop(i).Position(2) = randi([1 25], 1);
        %pop(i).Position = round(pop(i).Position)
        
        
        % Evaluate Solution
        pop(i).Cost = ObjectiveFunction(pop(i).Position);
        
        % Compare Solution to Best Solution Ever Found
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
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
            popc(l).Position = Mutate(popc(l).Position, mu, sigma);
            
            % Check for Variable Buonds
            popc(l).Position = max(popc(1).Position, VarMin);
            popc(l).Position = min(popc(1).Position, VarMax);
            
            % Evaluation
            popc(l).Cost = ObjectiveFunction(popc(l).Position);
            
            % Compare Solution to Best Solution Ever Found
            if popc(l).Cost < bestsol.Cost
                bestsol = popc(l);
            end
            
        end
        
        % Merge and Sort Populations
        pop = SortPopulation([pop; popc]);
        
        % Remove Extra Individuals
        pop = pop(1:nPop);
        
        % Update Best Cost of Iteration
        bestcost(it) = round(bestsol.Cost);

        % Display Itertion Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);
        
    end
    
    
    % Results
    out.pop = pop;
    bestsol.Position = round(bestsol.Position);
    bestsol.Cost = round(bestsol.Cost);
    out.bestsol = bestsol;
    out.bestcost = bestcost;
    disp(bestsol);
end