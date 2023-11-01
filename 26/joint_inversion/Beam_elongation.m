function V = Beam_elongation(X)

% Vectorized implementation
V = 40e3.*30./(0.15.*0.3.*X(:,1));
