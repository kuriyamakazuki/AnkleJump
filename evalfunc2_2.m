function eval = evalfunc2_2(throughp, Ksec)
mass = 70.0;
g = 9.8;
Fsec0 = 2*mass*g;
Fmax = 5500;
width = 2*(Fmax-2*mass*g)/(3*Ksec);

tp = 0:0.01:0.5;
throughp = [0,throughp,-5*ones(1,20)];
p = pchip(tp,throughp);

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');
    
[t,y] = ode45(@(t,y) dynamics2_2(t,y,p,Ksec), [0,1.0], [0; -1e-10], odeopts);

Fsec_max = max(Ksec*(Fsec0/Ksec-1e-10-width*ppval(p,t)/10-y(:,2)));

if y(end, 1) < 0 || y(end, 2) < 0
    eval = 10^10;
else
    eval = 1/y(end, 1) + 10*heaviside(Fsec_max-Fmax);
end

end