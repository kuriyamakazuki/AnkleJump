Fmax = 5500; %最大筋力
Lopt = 0.055; %収縮要素の至適長
Lslack = 0.42; %弾性要素の自然長
Ksec = 2.0*10^5; %弾性要素のバネ定数
mass = 70.0; %体重
Lcc0 = Lopt*0.7;
Lsec0 = Lslack + 2*mass*9.8 / Ksec;

width = 0.888;
c = -1/width^2;
Fiso0 = c*(Lcc0/Lopt)^2 - 2*c*Lcc0/Lopt + c + 1;

opts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn');
    %相対許容誤差を1e-5に抑える
    %x=0(離地)になった瞬間に計算終了

q0 = 2*mass*98/(Fmax*Fiso0);
ACTgene = ACT(10,:);
    
[t,y] = ode45(@(t,y) dynamics(t,y,ACTgene,Fmax,Lopt,Lslack,Ksec,mass),...
    [0,1.0], [0;-1e-10;2*mass*9.8/(Fmax*Fiso0);Lcc0; Lsec0], opts);
y(end, 1)

for k = 1:5
    figure
    plot(t, y(:,k))
    xlabel('t[s]')
    if k == 1
        ylabel('v')
    elseif k == 2
        ylabel('x')
    elseif k == 3
        ylabel('q')
    elseif k == 4
        ylabel('L_{CC}[m]')
    else
        ylabel('L_{SEC}[m]')
    end
end