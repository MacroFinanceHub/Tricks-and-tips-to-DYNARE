function [ys_, params, info] = jermann98_steadystate2(ys_, exo_, params)
% Steady state generated by Dynare preprocessor
    info = 0;
    ys_(7)=params(6)/params(10);
    ys_(6)=params(6)/params(10);
    ys_(3)=ys_(6)-ys_(7);
    ys_(10)=1;
    ys_(5)=((params(6)/params(10)-(1-params(4)))/(params(1)*params(6)^(1-params(1))))^(1/(params(1)-1));
    ys_(9)=params(6)^(-params(1))*ys_(5)^params(1);
    ys_(8)=(1-params(1))*ys_(9);
    ys_(4)=ys_(5)*(1-(1-params(4))*1/params(6));
    ys_(2)=ys_(9)-ys_(8)-ys_(4);
    ys_(1)=ys_(8)+ys_(2);
    ys_(11)=(ys_(1)-ys_(1)*params(2)/params(6))^(-params(5))-params(2)*params(11)*(params(6)*ys_(1)-ys_(1)*params(2))^(-params(5));
    % Auxiliary equations
ys_(12)=ys_(11)*params(10)/params(6)/ys_(11);
    check_=0;
end
