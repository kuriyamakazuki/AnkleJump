odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');
gaopts = optimoptions('ga', 'display', 'iter');

%{
Ksec = zeros(31,1);
Performance = zeros(31,1);
throughp = zeros(31,10);
%}

for k = 31:31
    Ksec(k) = (0.9+0.1*k)*10^5;
    for l = 1:100
        lb = -5*ones(10,1);
        lb(1) = 0;
        ub = 5*ones(10,1);
        IntCon = 1:10;
        [throughp_localmax, fval] = ga(@(throughp) evalfunc2(throughp, Ksec(k)), 10, [], [], [], [], lb, ub, [], IntCon,gaopts);
        tp = 0:0.03:0.5;
        p = pchip(tp,[0,throughp_localmax,-5*ones(1,6)]);
        [t,y] = ode45(@(t,y) dynamics2(t,y,p,Ksec(k)), [0,0.5], [0; -1e-10], odeopts);
        throughp_max = throughp_localmax;
        if Performance(k) < y(end,1)
            Performance(k) = y(end,1)
            throughp(k,:) = throughp_max
        end
    end
end

figure
plot(Ksec, Performance, 'o-')
grid on