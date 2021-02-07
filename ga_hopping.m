Ksec = zeros(31,1);
Performance = zeros(31,1);
ACT = zeros(31,50);

for k = 1:31
    for repeat = 1:1
        Ksec(k) = (0.9+k*0.1)*10^5;
        Fmax = 5500*sqrt(0.9+k*0.1);
        %{
        lb = zeros(10,1);
        ub = 10*ones(10,1);
        IntCon = 1:10;
        betterACT = 10*ones(5,10);
        for l = 1:5
            for m = 1:l
                betterACT(l,m) = 0;
            end
        end
        gaopts = optimoptions('ga', 'display', 'iter', 'InitialPopulationMatrix', betterACT,...
            'MaxStallGeneration', 5);
        [Ans, fval] = ga(@(ACTgene) evalfunc_Fchange(ACTgene,Ksec(k),Fmax), 10, [], [], [], [], lb, ub, [], IntCon, gaopts);
        %}
        lb = zeros(50,1);
        ub = 10*ones(50,1);
        IntCon = 1:50;
        betterACT = 10*ones(21,50);
        %{
        for l = 1:10
            for m = 1:5
                betterACT(1,5*(l-1)+m) = Ans(l);
            end
        end
        %}
        for l = 1:20
            for m = 1:l
                betterACT(l+1,m) = 0;
            end
        end
        gaopts = optimoptions('ga', 'display', 'iter', 'InitialPopulationMatrix', betterACT,...
            'MaxStallGeneration', 3);
        [Ans, fval] = ga(@(ACTgene) evalfunc_Fchange(ACTgene,Ksec(k),Fmax), 50, [], [], [], [], lb, ub, [], IntCon, gaopts);
        if Performance(k) < 1/fval
            Performance(k) = 1/fval
            ACT(k,:) = Ans;
        end
        Ksec(k)
        repeat
    end
end

plot(Ksec, Performance,'o-')
grid on
xlabel('k_{SEC}[N/m]')
ylabel('velocity of mass[m/s]')
title('Spring Constant vs Performance')