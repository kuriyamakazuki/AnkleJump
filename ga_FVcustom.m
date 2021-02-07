%{
Ksec = zeros(31,1);
Performance = zeros(31,1);
ACT = zeros(31,50);
%}

for k = 1:2
    for repeat = 1:3
        Ksec(k) = (0.9+k*0.1)*10^5;
        lb = zeros(10,1);
        ub = 10*ones(10,1);
        IntCon = 1:10;
        gaopts = optimoptions('ga', 'display', 'iter', 'MaxStallGeneration', 30);
        [Ans, fval] = ga(@(ACTgene) evalfunc(ACTgene,Ksec(k)), 10, [], [], [], [], lb, ub, [], IntCon, gaopts);
        betterACT = zeros(1,50);
        for l = 1:10
            for m = 1:5
                betterACT(5*(l-1)+m) = Ans(l);
            end
        end
        gaopts = optimoptions('ga', 'display', 'iter', 'MaxStallGeneration', 30,...
            'InitialPopulationMatrix', betterACT);
        lb = zeros(50,1);
        ub = 10*ones(50,1);
        IntCon = 1:50;
        [Ans, fval] = ga(@(ACTgene) evalfunc(ACTgene,Ksec(k)), 50, [], [], [], [], lb, ub, [], IntCon, gaopts);
        if Performance(k) < 1/fval
            Performance(k) = 1/fval;
            ACT(k,:) = Ans;
        end
        Ksec(k)
        repeat
    end
end

plot(Ksec, Performance)
xlabel('k_{SEC}[N/m]')
ylabel('velocity of mass[m/s]')
title('Spring Constant vs Performance')