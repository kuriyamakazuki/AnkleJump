%y = (v, x)

function dydt = dynamics3(t, y, ts, Ksec)
    Lslack = 0.42;
    Lopt = 0.055;
    width = 0.888;
    mass = 70.0;
    g = 9.8;
    F0 = 2*mass*g;
    Mass = 4*mass;
    Lsec0 = Lslack + F0/Ksec;
    
    if t == 0
        Lsec = Lsec0;
    elseif t < ts
        Lsec = Lsec0-Lopt*width/2.0-y(2);
    else
        Lsec = Lsec0+Lopt*width/2.0-y(2);
    end
    
    dy1dt = (Fsec(Lsec)-F0)/Mass;
    dy2dt = y(1);
    dydt = [dy1dt; dy2dt];
    
    function F = Fsec(Lsec)
        if Lsec < Lslack
            F = 0;
        else
            F = Ksec * (Lsec-Lslack);
        end
    end
end