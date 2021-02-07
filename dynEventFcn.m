%微分方程式を解く時の終了イベント設定
%x=y(4)=0になった瞬間にイベントを検出

function [value, isterminal, direction] = dynEventFcn(t,y)
    value(1) = real(y(2));
    value(2) = t-0.49;
    value(3) = real(y(4)-0.055*1.444);
    value(4) = real(0.055*0.556-y(4));
    isterminal = ones(1,4);
    direction = [];
end