Fmax = 5500*sqrt(0.9+0.1*31); %最大筋力
Lopt = 0.055; %収縮要素の至適長
Lslack = 0.42; %弾性要素の自然長
Ksec = (0.9+0.1*31)*10^5; %弾性要素のバネ定数
mass = 70.0; %体重
Lcc0 = Lopt*0.7;
Lsec0 = Lslack + 2*mass*9.8 / Ksec;

width = 0.888;
c = -1/width^2;
Fiso0 = c*(Lcc0/Lopt)^2 - 2*c*Lcc0/Lopt + c + 1;

opts = odeset('RelTol', 1e-7, 'AbsTol', 1e-10, 'Event', 'dynEventFcn');
    %相対許容誤差を1e-5に抑える
    %x=0(離地)になった瞬間に計算終了

q0 = 2*mass*9.8/(Fmax*Fiso0);
ACTgene = ACT(31,:);

[t,y] = ode45(@(t,y) dynamics(t,y,ACTgene,Fmax,Lopt,Lslack,Ksec,mass),...
    [0,0.5], [0;-1e-10;q0;Lcc0; Lsec0], opts);
y(end, 1)
t(end)

fig = figure('Position', [500,500,300,700]);
tile = tiledlayout(4,1);

for k = 1:4
    ax = nexttile;
    if k == 1
        yyaxis left
        plot(ax, t, y(:,2))
        ylabel('x_{mass} [m]')
        yyaxis right
        plot(ax, t, y(:,1))
        ylabel('V_{mass} [m/s]')
    elseif k == 2
        yyaxis left
        plot(ax, t, [ACTgene(1),ACTgene(ceil(100*t(2:end)))])
        ylabel('EXC')
        yyaxis right
        plot(ax, t, y(:,3))
        ylabel('ACT')
    elseif k == 3
        yyaxis left
        plot(ax, t, y(:,4))
        ylabel('L_{CC} [m]')
        yyaxis right
        plot(ax, t, [0;diff(y(:,4))./diff(t)])
        ylabel('V_{CC} [m/s]')
    elseif k == 4
        yyaxis left
        plot(ax, t, y(:,5))
        ylabel('L_{SEC} [m]')
        yyaxis right
        plot(ax, t, Ksec*(y(:,5)-Lslack), 'Linestyle', 'none')
        ylabel('F_{SEC} [N]')
        xlabel('time')
    end
    grid on
end
%{
for k = 1:4
    ax = nexttile;
    if k == 1
        plot(ax, t, y(:,2))
        ylabel('x_{mass} [m]')
    elseif k == 2
        plot(ax, t, [0;diff(y(:,4))./diff(t)])
        ylabel('V_{CC} [m/s]')
    elseif k == 3
        plot(ax, t, Ksec*(y(:,5)-Lslack))
        ylabel('F_{SEC} [N]')
    elseif k == 4
        plot(ax, t, -Ksec*(y(:,5)-Lslack).*[0;diff(y(:,4))./diff(t)])
        ylabel('P_{CC} [W]')
        xlabel('time [s]')
    end
    grid on
end
%}