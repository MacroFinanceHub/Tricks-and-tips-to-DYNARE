// 3-equations NK model (without ZLB): stochastic case

var y     // GDP
    pie   // Inflation
    r     // Nominal interest rate
    eps_a // Productivity shock (opposite of cost-push shock)
    eps_b // Confidence shock (shock to rate of preference for the present)
    ;

varexo eta_r // Monetary policy error
       eta_a // Innovation to productivity shock
       eta_b // Innovation to confidence shock
       ;

parameters sigma   // Relative risk aversion
           rho_r   // Inertia of monetary policy
           rho_pie // Reaction of monetary policy to inflation
           rho_y   // Reaction of monetary policy to output gap
           beta    // Discount factor
           rho_a   // Autocorrelation of productivity shock
           rho_b   // Autocorrelation of confidence shock
           kappa   // Weight of output gap in Phillips curve
           delta   // Weight of inflation expectations in Phillips curve
           ;

sigma = 2;
rho_r = 0.96;
rho_pie = 1.68;
rho_y = 0.1;
beta = 0.99;
rho_a = 0.82;
rho_b = 0.85;
delta = 0.67;
kappa = 0.1;

model;
 // Euler equation
 beta*r/pie(+1)*eps_b(+1)*y(+1)^(-sigma) = eps_b*y^(-sigma);

 // NK Phillips curve
 log(pie/STEADY_STATE(pie)) = delta*log(pie(+1)/STEADY_STATE(pie)) + kappa*log(y/STEADY_STATE(y)) - log(eps_a);

 // Taylor rule (in multiplicative form) NOTA BENE: the ZLB doesn't work, i.e. the constraint is not enforced, because we have a stochastic model
 log(r) = max(0,rho_r*log(r(-1)) + (1-rho_r)*(log(STEADY_STATE(pie)/beta) + rho_pie*log(pie(-1)/STEADY_STATE(pie)) + rho_y*log(y/STEADY_STATE(y))) + eta_r);

 // Stochastic shocks (AR(1) processes)
 log(eps_a) = rho_a*log(eps_a(-1)) + eta_a;
 log(eps_b) = rho_b*log(eps_b(-1)) + eta_b;
end;

shocks;
var eta_a; 
 periods 1;
 values 0;
end;

steady_state_model;
 eps_a = 1;
 eps_b = 1;
 pie = 1.005; // Steady state inflation is not determined by the model, any value will work here
 y = 1; // Same applies to GDP
 r = pie/beta;
end;

steady;

perfect_foresight_setup(periods=100);
perfect_foresight_solver;

// Declare unexpected shock (after first simulation!)
oo_.exo_simul(6, 1) = -0.01; // Period 5 has index 6!

// Strip first 4 periods and save them
saved_endo = oo_.endo_simul(:, 1:4);  // Save periods 0 to 4
saved_exo = oo_.exo_simul(1:4, :);
oo_.endo_simul = oo_.endo_simul(:, 5:end); // Keep periods 4
oo_.exo_simul = oo_.exo_simul(5:end, :);

periods 96;
perfect_foresight_solver;

// Combine the two simulations
oo_.endo_simul = [ saved_endo oo_.endo_simul ];
oo_.exo_simul = [ saved_exo; oo_.exo_simul ];

rplot r;