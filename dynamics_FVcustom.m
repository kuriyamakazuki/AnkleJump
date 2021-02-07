%系の時間発展を表す微分方程式群
%y = (v, x, q, Lcc, Lsec)

function dydt = dynamics_FVcustom(t, y, ACTgene, Fmax, Lopt, Lslack, Ksec, mass)
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

    function Fiso = F_L(Lcc) %力−長さ関係
        c = -1/width^2;
        Fiso = c*(Lcc/Lopt)^2 - 2*c*Lcc/Lopt + c + 1;
    end
    
    function Vcc = F_V(Lcc, F, q) %力−速度関係
        Fiso = F_L(Lcc);
        fac = min(1, 3.33*q);
        Vcc_max = -fac*Lopt*Brel*Fiso/Arel;
        Fp = [0, Fiso*q*Fmax*0.9, Fiso*q*Fmax, Fiso*q*Fmax*1.1];
        Vccp = [Vcc_max, Vcc_max*0.9, 0, -Vcc_max*0.9];
        p = pchip(Fp,Vccp);
        Vcc = ppval(p,F);
    end
    
    function F = Fsec(Lsec) %弾性要素の力−長さ関係
        if Lsec < Lslack
            F = 0;
        else
            F = Ksec * (Lsec-Lslack);
        end
    end
end