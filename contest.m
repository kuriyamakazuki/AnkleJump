Lopt = 0.055;
Lslack = 0.42;
mass = 70.0;
Ksec = 1.0*10^5;
Fsec0 = 2*mass*9.8;
Lcc0 = Lopt*0.7;
Lsec0 = Lslack + Fsec0 / Ksec;

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');

%pcoeff = [42.8050   -0.8900 -298.6853 -540.8071 -737.2138];
    
[t,y] = ode45(@(t,y) dynamics2(t,y,pcoeff(1,:),Ksec), [0,1.0], [Lcc0; Lsec0; Fsec0; 0; -1e-10], odeopts);
y(end, 4)

fig = figure;
tiledlayout(4,2)
for k = 1:5
    if k ~= 4
        ax = nexttile;
        ax = nexttile;
        plot(ax, t, y(:,k))
        grid on
        if k == 1
            ylabel('L_{CC}[m]')
        elseif k == 2
            ylabel('L_{SEC}[m]')
        elseif k == 3
            ylabel('F_{SEC}[N]')
        elseif k == 5
            ylabel('x_{mass}[m]')
            xlabel('time[s]')
        end
    end
end