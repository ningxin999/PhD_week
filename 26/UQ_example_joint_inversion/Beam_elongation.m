function V = Beam_elongation(X)

% Vectorized implementation
V = X(:,2).*5./(0.15.*0.3.*X(:,1));
