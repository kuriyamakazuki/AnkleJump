Ksec = zeros(31,1);
Performance = zeros(31,1);
throughp = zeros(31,6);

Lopt = 0.055;
width = 0.888;
Lslack = 0.42;
mass = 70.0;
Fsec0 = 2*mass*9.8;
Fmax = 5500;

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');

for k = 1:31
    Ksec(k) = (0.9+0.1*k)*10^5;
    Lsec0 = Lslack + Fsec0 / Ksec(k);
    for l = 0:5
        for m = -5:5
            for n = -5:5
                for s = -5:5
                    for t = -5:5
                        for u = -5:-5
                            tp = 0:0.05:0.5;
                            throughp_local = [l,m,n,s,t,u];
                            yp = [0,throughp_local,-5*ones(1,4)];
                            p = pchip(tp,yp);
                            [t,y] = ode45(@(t,y) dynamics2(t,y,p,Ksec(k)), [0,0.5], [0; -1e-10], odeopts);
                            Lsec_max = max(Lsec0-Lopt*width*ppval(p,t)/10-y(:,2));
                            Fsec_max = Ksec(k)*(Lsec_max-Lslack);
                            if 0 < y(end, 2) && Fsec_max < Fmax && Performance(k) < y(end, 1)
                                Performance(k) = y(end,1);
                                throughp(k,:) = throughp_local
                            end
                        end
                    end
                end
            end
        end
    end
    Ksec(k)
    Performance(k)
end

figure
plot(Ksec, Performance)
grid on