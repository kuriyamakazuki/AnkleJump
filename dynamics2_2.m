%y = (v, x)

function dydt = dynamics2_2(t, y, p, Ksec)
    Lslack = 0.42;
    mass = 70.0;
    g = 9.8;
    F0 = 2*mass*g;
    Mass = 4*mass;
    Fmax = 5500;
    width = 2*(Fmax-2*mass*g)/(3*Ksec);
    
    Lsec = Lslack+F0/Ksec-1e-10-width*ppval(p,t)/10-y(2);
    
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