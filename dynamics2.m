%y = (Lcc, Lsec, Fsec, v, x)

function dydt = dynamics2(t, y, p, Ksec)
    Lslack = 0.42;
    mass = 70.0;
    g = 9.8;
    F0 = 2*mass*g;
    Mass = 4*mass;
    
    %{
    dp = 0;
    for k = 1:5
        dp = dp + pcoeff(k)*t^(5-k);
    end
    %}
    
    
    dy1dt = dp;
    dy2dt = -y(4)-dp;
    if y(2) > Lslack
        dy3dt = Ksec * dy2dt;
    else
        dy3dt = 0;
    end
    dy4dt = (y(3)-F0)/Mass;
    dy5dt = y(4);
    dydt = [dy1dt; dy2dt; dy3dt; dy4dt; dy5dt];
    
    function F = Fsec(Lsec)
        if Lsec < Lslack
            F = 0;
        else
            F = Ksec * (Lsec-Lslack);
        end
    end
end