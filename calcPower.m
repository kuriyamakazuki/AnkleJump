Arel = 0.3;
Brel = 3.6;

Lcc = y(:,4);
F = Ksec*(y(:,5)-Lslack);
q = y(:,3);
Vcc = zeros(length(F),1);
for k = 1:length(F)
    c = -1/width^2;
    Fiso = c*(Lcc(k)/Lopt)^2 - 2*c*Lcc(k)/Lopt + c + 1;
    Fcc = Fmax*Fiso*q(k);
    fac = min(1, 3.33*q(k));
    c2 = -1.5*Fiso;
    c1 = fac*Brel*(Fiso+c2)^2 / (2.0*(Fiso+Arel));
    c3 = c1 / (Fiso+c2);
    c4 = -sqrt(c1/(fac*200.0)) - c2;
    if F(k) < Fcc %concentric
        Vcc(k) = fac*Lopt*Brel*(1-Fmax*q(k)*(Fiso+Arel)/(F(k)+Arel*Fmax*q(k)));
    elseif F(k) < Fmax*q(k)*c4 %eccentric(low speed)
        Vcc(k) = -Lopt * (c1/(F(k)/(Fmax*q(k))+c2)-c3);
    else %eccentric(high speed)
        Vcc(k) = Lopt * (fac*200.0*(F(k)/(Fmax*q(k))+c2) + c3 + 2*sqrt(c1*fac*200.0));
    end
end
plot(t, -Ksec*Vcc.*(y(:,5)-Lslack))
ylim([-400,400])
xlabel('t')
ylabel('Power')
