function eval = evalfunc2(pcoeff, Ksec)

Lopt = 0.055;
Lslack = 0.42;
mass = 70.0;
%Ksec = 2.0*10^5;
Fsec0 = 2*mass*9.8;
Lcc0 = Lopt*0.7;
Lsec0 = Lslack + Fsec0 / Ksec;

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');
    
[t,y] = ode45(@(t,y) dynamics2(t,y,pcoeff,Ksec), [0,1.0], [Lcc0; Lsec0; Fsec0; 0; -1e-10], odeopts);

if y(end, 4) < 0 || y(end, 5) < 0
    eval = 10^10;
else
    eval = 1/y(end, 4);
end

end