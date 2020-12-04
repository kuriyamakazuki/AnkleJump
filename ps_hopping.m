lb = zeros(10,1);
ub = 10*ones(10,1);
opt = optimoptions('particleswarm', 'Display', 'iter');

[ACT, fval] = particleswarm(@evalfunc, 10, lb, ub, opt)

figure
for k = 1:10
    x = 50*(k-1):50*k;
    plot(x, ACT(k)/10.0, 'b.')
    hold on
end