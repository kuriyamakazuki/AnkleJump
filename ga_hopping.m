Ksec = zeros(9,1);
Performance = zeros(9,1);
ACT = zeros(9,100);

for k = 10:10
    Ksec(k) = (0.9+k*0.1)*10^5;

    lb = zeros(100,1);
    ub = 10*ones(100,1);
    IntCon = 1:100;
    betterACT = 10*ones(40,100);
    for l = 1:40
        for m = 1:l
            betterACT(l,m) = 0;
        end
    end
    opt = optimoptions('ga', 'display', 'iter', 'InitialPopulationMatrix', betterACT,...
        'MaxStallGeneration', 10);
    [Ans, fval] = ga(@(ACTgene) evalfunc(ACTgene,Ksec(k)), 100, [], [], [], [], lb, ub, [], IntCon, opt);

    Performance(k) = 1/fval
    ACT(k,:) = Ans;
end

plot(Ksec, Performance)
xlabel('k_{SEC}[N/m]')
ylabel('velocity of mass[m/s]')
title('Spring Constant vs Performance')