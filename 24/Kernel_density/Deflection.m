
function Y = Deflection(X)

        rng(100,'twister')
        
        b = 0.15; % beam width  (m)
        h = 0.3; % beam height (m)
        L = 30; % beam length (m)

        E = X(:,1);
        delta = -3.15;
         F = X(:,2);


        I = b.* h.^3 / 12; % the moment of intertia

        % loading position delta divide the beam into two part a and part b
        L_a = 15 + delta;
        L_b = 15 - delta;
        
        % now for the actual execution for a ground truth:
         %n sets of measurements
        %29 points along the beam

 


        Nsample = size(E,1);
        Y = zeros(Nsample,29);

        for ii = 1: Nsample

            for jj = 1 : 29
            % calculate the xi values:
            xi = jj/30* L;
    
    
            %calculate deflection part A and part B
                if xi <= L_a 
                    Y(ii,jj) = F(ii,1) .* L_b * xi .* ((L.^2 - L_b.^2) - xi.^2) / (6 * L * E(ii,1) * I)  ;

    
                else
                     Y(ii,jj) =  F(ii,1) .* L_b.* (L./L_b.*(xi-L_a).^3 + (L.^2 - L_b.^2).*xi - xi.^3 )/ (6*L*E(ii,1)*I) ; 
   
    
                end
    

            end

        
        end
   


end 

