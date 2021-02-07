odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');
gaopts = optimoptions('ga', 'display', 'iter');

%{
Ksec = zeros(31,1);
Performance = zeros(31,1);
throughp = zeros(31,5);
%}

for k = 9:9
    Ksec(k) = (0.9+0.1*k)*10^5;
    for l = 1:10
        lb = -ones(5,1)/10;
        lb(1) = 0;
        ub = ones(5,1)/10;
        [throughp_max, fval] = ga(@(throughp) evalfunc_Fmax(throughp, Ksec(k)), 5, [], [], [], [], lb, ub, [], [],[]);
        tp = 0:0.05:0.5;
        p = pchip(tp,[0,throughp_max,-5*ones(1,5)]);
        [t,y] = ode45(@(t,y) dynamics_Fmax(t,y,p,Ksec(k)), [0,0.5], [0; -1e-10], odeopts);
        Fsec_max = max(Ksec(k)*(Fsec0/Ksec(k)-ppval(p,t)-y(:,2)));
        if Performance(k) < y(end,1) && Fsec_max < Fmax
            Performance(k) = y(end,1)
            throughp(k,:) = throughp_max
        end
        Ksec(k)
        l
    end
end

figure
plot(Ksec, Performance, 'o-')
grid on