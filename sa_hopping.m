lb = zeros(10,1);
ub = 10*ones(10,1);
x0 = [0,0,1,1,1,1,1,1,1,1];
IntCon = 1:10;
opt = optimoptions('simulannealbnd', 'Display', 'iter');

[ACT, fval] = simulannealbnd(@evalfunc, x0, lb, ub, opt)

figure
for k = 1:10
    x = 50*(k-1):50*k;
    plot(x, ACT(k)/10.0, 'b.')
    hold on
end