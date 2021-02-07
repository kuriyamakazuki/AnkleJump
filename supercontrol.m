Ksec = zeros(31,1);
Performance = zeros(31,1);
Ts = zeros(31,1);

odeopts = odeset('RelTol', 1e-5, 'AbsTol', 1e-8, 'Event', 'dynEventFcn2');

for k = 1:31
    Ksec(k) = (0.9+0.1*k)*10^5;
    for ts_loop = 1:200
        ts = ts_loop*0.001;
        [t,y] = ode45(@(t,y) dynamics3(t,y,ts,Ksec(k)), [0,0.5], [0; -1e-10], odeopts);
        if Performance(k) < y(end,1)
            Performance(k) = y(end,1);
            Ts(k) = ts;
        end
    end
    Performance(k)
end

figure
plot(Ksec, Performance, 'o-')
grid on