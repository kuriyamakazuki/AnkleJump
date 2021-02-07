%y = (v, x)

function dydt = dynamics_Fmax(t, y, p, Ksec)
    Lslack = 0.42;
    width = 0.888;
    mass = 70.0;
    g = 9.8;
    F0 = 2*mass*g;
    Mass = 4*mass;
    
    Lsec = Lslack+F0/Ksec-ppval(p,t)-y(2);
    
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