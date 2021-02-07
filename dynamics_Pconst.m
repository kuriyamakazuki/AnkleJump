%系の時間発展を表す微分方程式群
%y = (v, x, q, Lcc, Lsec)

function dydt = dynamics_Pconst(t, y, ACTgene, Fmax, Lopt, Lslack, Ksec, mass)
    width = 0.888; %収縮要素の伸縮範囲
    Tact = 0.055;
    Tdeact = 0.065;
    Arel = 0.3;
    Brel = 3.6;
    g = 9.8;
    F0 = 2*mass*g;
    Mass = 4*mass;
    
    ACTnum = length(ACTgene);
    for k = 1:ACTnum
        if 0.5*(k-1)/ACTnum <= t && t < 0.5*k/ACTnum
            ACT = ACTgene(k)/10.0;
            break
        else
            ACT = 1.0;
        end
    end
    
    dy1dt = (Fsec(y(5))-F0)/Mass;
    dy2dt = y(1);
    dy3dt = (ACT-y(3))*((1/Tact-1/Tdeact)*ACT+1/Tdeact);
    dy4dt = F_V(y(4), Fsec(y(5)), y(3));
    dy5dt = -y(1) - F_V(y(4), Fsec(y(5)), y(3));
    dydt = [dy1dt; dy2dt; dy3dt; dy4dt; dy5dt];
    
    %{
    plot(t,y(2),'bo')
    hold on
    drawnow
    %}

    function Fiso = F_L(Lcc) %力−長さ関係
        c = -1/width^2;
        Fiso = c*(Lcc/Lopt)^2 - 2*c*Lcc/Lopt + c + 1;
        if Fiso < 0
            Fiso = eps;
        end
    end
    
    function Vcc = F_V(Lcc, F, q) %力−速度関係
        Fiso = F_L(Lcc);
        fac = min(1, 3.33*q);
        aveP = fac*Lopt*Brel*q*Fmax*Fiso*(1/2+Arel/Fiso-Arel*(Fiso+Arel)*reallog(1+Fiso/Arel)/Fiso^2);
        c2 = -1.5*Fiso;
        c1 = fac*Brel*(Fiso+c2)^2 / (2.0*(Fiso+Arel));
        c3 = c1 / (Fiso+c2);
        c4 = -sqrt(c1/(fac*200.0)) - c2;
        if F == 0
            Vcc = -interp1([0,Fmax*q*Fiso*0.1],[0,aveP*10/9],eps)/eps;
        elseif F < Fmax*q*Fiso*0.1
            Vcc = -interp1([0,Fmax*q*Fiso*0.1],[0,aveP*10/9],F)/F;
        elseif F < Fmax*q*Fiso*0.9
            Vcc = -aveP*10/(F*9);
        elseif F < Fmax*q*Fiso
            Vcc = -interp1([Fmax*q*Fiso*0.9,Fmax*q*Fiso],[aveP*10/9,0],F)/F;
        elseif F < Fmax*q*c4
            Vcc = -Lopt * (c1/(F/(Fmax*q)+c2)-c3);
        else
            Vcc = Lopt * (fac*200.0*(F/(Fmax*q)+c2) + c3 + 2*sqrt(c1*fac*200.0));
        end
    end
    
    function F = Fsec(Lsec) %弾性要素の力−長さ関係
        if Lsec < Lslack
            F = 0;
        else
            F = Ksec * (Lsec-Lslack);
        end
    end
end