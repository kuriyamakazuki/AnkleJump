function [value, isterminal, direction] = dynEventFcn2(t, y)
    value(1) = y(5);
    value(2) = y(2);
    value(3) = y(1) - 0.055*1.44;
    value(4) = y(1) - 0.055*0.56;
    value(5) = y(3) - 5500;
    isterminal = ones(1,5);
    direction = [];
end