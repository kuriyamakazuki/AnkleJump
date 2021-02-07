function Vjump = evalfunc_Fchange(ACTgene, Ksec, Fmax)
    Lopt = 0.055; %収縮要素の至適長
    Lslack = 0.42; %弾性要素の自然長
    mass = 70.0; %体重
    Lcc0 = Lopt*0.7;
    Lsec0 = Lslack + 2*mass*9.8 / Ksec;

    width = 0.888;
    c = -1/width^2;
    Fiso0 = c*(Lcc0/Lopt)^2 - 2*c*Lcc0/Lopt + c + 1;
    
    opts = odeset('RelTol', 1e-7, 'AbsTol', 1e-10, 'Event', 'dynEventFcn');
        %x=0(離地)になった瞬間に計算終了
        
    [t,y] = ode45(@(t,y) dynamics(t,y,ACTgene,Fmax,Lopt,Lslack,Ksec,mass),...
        [0,0.5], [0;-1e-10;2*mass*9.8/(Fmax*Fiso0);Lcc0; Lsec0], opts);
    
    [minx, ind] = min(y(:,2));
    zurui = 0;
    for k = ind+1:length(y(:,2))
        if y(k,2) < y(k-1,2)
            zurui = 1;
        end
    end
    
    if zurui || y(end,1) < 0 || y(end,2) < 0
        Vjump = 10^10;
    else
        Vjump = 1/y(end, 1);
    end
end