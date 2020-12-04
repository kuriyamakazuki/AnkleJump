lb = [-10; -10; -10; -10; 0];
ub = [10; 10; 10; 10; 10];
%opt = optimoptions('ga', 'display', 'iter');

Ksec = zeros(31,1);
Performance = zeros(31,1);
pcoeff = zeros(31,5);

for k = 1:31
    Ksec(k) = (0.9+0.1*k)*10^5;
    saikyo = 0;
    for l = 1:10
        [pcoeff_fake, fval] = ga(@(pcoeff_gene) evalfunc2(pcoeff_gene, Ksec(k)), 5, [], [], [], [], lb, ub);
        if saikyo < 1/fval
            saikyo = 1/fval;
            pcoeff_max = pcoeff_fake;
        end
    end
    Performance(k) = saikyo
    pcoeff(k,:) = pcoeff_max
end

plot(Ksec, Performance)

%{
[t,y] = ode45(@(t,y) dynamics2(t,y,pcoeff_max), [0,1.0], [Lcc0; Lsec0; Fsec0; 0; -1e-10], odeopts);

for k = 1:5
    figure
    plot(t, y(:,k))
    xlabel('t[s]')
    if k == 1
        ylabel('Lcc')
    elseif k == 2
        ylabel('Lsec')
    elseif k == 3
        ylabel('Fsec')
    elseif k == 4
        ylabel('v')
    elseif k == 5
        ylabel('x')
    end
end
%}