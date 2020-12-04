%微分方程式を解く時の終了イベント設定
%x=y(4)=0になった瞬間にイベントを検出

function [value, isterminal, direction] = dynEventFcn(t,y)
    value(1) = real(y(2));
    value(2) = t-0.99;
    isterminal = 1;
    direction = 1;
end