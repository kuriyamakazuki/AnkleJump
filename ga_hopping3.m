odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');

%{
Ksec = zeros(31,1);
Performance = zeros(31,1);
throughp = zeros(31,30);
%}
%Performance_new = zeros(31,1);
%throughp_new = zeros(31,30);

for k = 11:11
    Ksec(k) = (0.7+0.3*k)*10^5;
    for l = 1:1
        %{
        lb = -5*ones(5,1);
        lb(1) = 0;
        ub = 5*ones(5,1);
        gaopts = optimoptions('ga', 'display', 'iter');
        [throughp_max, fval] = ga(@(throughp) evalfunc2(throughp, Ksec(k)), 5, [], [], [], [], lb, ub, [], [],gaopts);
        %}
        tp = 0:0.05:0.5;
        p = pchip(tp,[0,throughp(3*k-2,:),-5*ones(1,4)]);
        lb = -5*ones(30,1);
        lb(1) = 0;
        ub = 5*ones(30,1);
        candi = zeros(1,30);
        tp = 0:0.01:0.5;
        for m = 1:30
            candi(m) = ppval(p,tp(m+1));
        end
        gaopts = optimoptions('ga', 'display', 'iter', 'InitialPopulationMatrix', candi);
        [throughp_max, fval] = ga(@(throughp) evalfunc2d(throughp, Ksec(k)), 30, [], [], [], [], lb, ub, [], [],gaopts);
        p = pchip(tp,[0,throughp_max,-5*ones(1,20)]);
        [t,y] = ode45(@(t,y) dynamics2(t,y,p,Ksec(k)), [0,0.5], [0; -1e-10], odeopts);
        if Performance_new(k) < y(end,1)
            Performance_new(k) = y(end,1)
            throughp_new(k,:) = throughp_max
        end
        Ksec(k)
        l
    end
end

figure
plot(Ksec, Performance, 'o-')
grid on