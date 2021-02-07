function eval = evalfunc_Fmax(throughp, Ksec)

Lopt = 0.055;
width = 0.888;
Lslack = 0.42;
mass = 70.0;
Fsec0 = 2*mass*9.8;
Lcc0 = Lopt*0.7;
Lsec0 = Lslack + Fsec0 / Ksec;
Fmax = 5500;

tp = 0:0.05:0.5;
throughp = [0,throughp,-5*ones(1,5)];
p = pchip(tp,throughp);

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');
    
[t,y] = ode45(@(t,y) dynamics_Fmax(t,y,p,Ksec), [0,0.5], [0; -1e-10], odeopts);

Fsec_max = max(Ksec*(Fsec0/Ksec-ppval(p,t)-y(:,2)));

if y(end, 1) < 0 || y(end, 2) < 0
    eval = 10^10;
else
    eval = 1/y(end, 1) + (Fsec_max-Fmax)*heaviside(Fsec_max-Fmax);
end

end