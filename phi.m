function [g] = phi(x,alpha,rho)
g = exp(-x.^2./(2*alpha*rho));
end