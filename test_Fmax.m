Lopt = 0.055;
width = 0.888;
Lslack = 0.42;
mass = 70.0;
Ksec = 4.0*10^5;
Fsec0 = 2*mass*9.8;
Lsec0 = Lslack + Fsec0 / Ksec;

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');

tp = 0:0.05:0.5;
p = pchip(tp,[0,throughp(31,:),-5*ones(1,5)]);

[t,y] = ode45(@(t,y) dynamics_Fmax(t,y,p,Ksec), [0,0.5], [0; -1e-10], odeopts);
Fsec_max = max(Ksec*(Fsec0/Ksec-ppval(p,t)-y(:,2)))
y(end,1)

fig = figure;
tiledlayout(2,2)
for k = 1:4
    ax = nexttile;
    xlabel('time[s]')
    if k == 1
        plot(ax, t, y(:,1))
        ylabel('v[m/s]')
    elseif k == 3
        plot(ax, t, y(:,2))
        ylabel('x_{mass}[m]')
    elseif k == 2
        plot(ax, t, Lopt+ppval(p,t))
        ylabel('L_{CC}[m]')
    elseif k == 4
        plot(ax, t, Lsec0-ppval(p,t)-y(:,2))
        ylabel('L_{SEC}[m]')
    end
    grid on
end