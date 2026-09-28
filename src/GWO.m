function [Alpha_score, Alpha_pos, Convergence_curve] = GWO( ...
    SearchAgents, MaxIter, lb, ub, dim, fobj)



%   SearchAgents : Number of search agents (wolves)
%   MaxIter      : Maximum number of iterations
%   lb           : Lower bounds
%   ub           : Upper bounds
%   dim          : Number of decision variables
%   fobj         : Objective function
%
% Outputs:
%   Alpha_score       : Best objective function value
%   Alpha_pos        : Best solution
%   Convergence_curve : Convergence history
% =========================================================


Alpha_pos = zeros(1,dim);
Alpha_score = inf;

Beta_pos = zeros(1,dim);
Beta_score = inf;

Delta_pos = zeros(1,dim);
Delta_score = inf;


Positions = initialization(SearchAgents,dim,ub,lb);

Convergence_curve = zeros(1,MaxIter);


for l = 1:MaxIter


    for i = 1:SearchAgents

        % Boundary checking
        Positions(i,:) = max(Positions(i,:),lb);
        Positions(i,:) = min(Positions(i,:),ub);

        % Objective function
        fitness = fobj(Positions(i,:));


        if fitness < Alpha_score

            Alpha_score = fitness;
            Alpha_pos = Positions(i,:);

        elseif fitness < Beta_score

            Beta_score = fitness;
            Beta_pos = Positions(i,:);

        elseif fitness < Delta_score

            Delta_score = fitness;
            Delta_pos = Positions(i,:);

        end

    end


    a = 2 - l*(2/MaxIter);


    for i = 1:SearchAgents

        for j = 1:dim

            % Alpha wolf

            r1 = rand();
            r2 = rand();

            A1 = 2*a*r1 - a;
            C1 = 2*r2;

            D_alpha = abs(C1*Alpha_pos(j) - Positions(i,j));

            X1 = Alpha_pos(j) - A1*D_alpha;


            % Beta wolf

            r1 = rand();
            r2 = rand();

            A2 = 2*a*r1 - a;
            C2 = 2*r2;

            D_beta = abs(C2*Beta_pos(j) - Positions(i,j));

            X2 = Beta_pos(j) - A2*D_beta;


            % Delta wolf

            r1 = rand();
            r2 = rand();

            A3 = 2*a*r1 - a;
            C3 = 2*r2;

            D_delta = abs(C3*Delta_pos(j) - Positions(i,j));

            X3 = Delta_pos(j) - A3*D_delta;


            % New position

            Positions(i,j) = (X1 + X2 + X3)/3;

        end

    end


    Convergence_curve(l) = Alpha_score;

    fprintf('Iteration %d/%d | Best = %.6f\n', ...
        l, MaxIter, Alpha_score);

end

end




function Positions = initialization(SearchAgents,dim,ub,lb)

Boundary_no = size(ub,2);

if Boundary_no == 1

    Positions = rand(SearchAgents,dim) .* ...
        (ub-lb) + lb;

else

    Positions = zeros(SearchAgents,dim);

    for i = 1:dim

        ub_i = ub(i);
        lb_i = lb(i);

        Positions(:,i) = rand(SearchAgents,1) .* ...
            (ub_i-lb_i) + lb_i;

    end

end

end