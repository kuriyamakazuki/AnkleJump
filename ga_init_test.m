Ksec = 2.0*10^5;

%{
lb = zeros(10,1);
ub = 10*ones(10,1);
IntCon = 1:10;
opt = optimoptions('ga', 'Display', 'iter', 'MaxStallGenerations', 10);
ACT = ga(@(ACTgene) evalfunc(ACTgene,Ksec), 10, [], [], [], [], lb, ub, [], IntCon, opt);
%}
    
lb = zeros(100,1);
ub = 10*ones(100,1);
IntCon = 1:100;
betterACT = 10*ones(40,100);
for l = 1:40
    for m = 1:l
        betterACT(l,m) = 0;
    end
end
opt = optimoptions('ga', 'Display', 'iter', 'InitialPopulationMatrix', betterACT);
[ACT, fval] = ga(@(ACTgene) evalfunc(ACTgene,Ksec), 100, [], [], [], [], lb, ub, [], IntCon, opt);

figure
for k = 1:100
    x = 5*(k-1):5*k;
    plot(x, ACT(k)/10.0, 'b.')
    hold on
end