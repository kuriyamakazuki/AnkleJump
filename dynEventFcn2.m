function [value, isterminal, direction] = dynEventFcn2(t, y)
    value(1) = y(2);
    isterminal = 1;
    direction = [];
end