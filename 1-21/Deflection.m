
function Y = Deflection(X)

        rng(100,'twister')
        F = X;
        b = 0.15; % beam width  (m)
        h = 0.3; % beam height (m)
        L = 30; % beam length (m)
        E = 30e9;
        delta = -2;
        I = b.* h.^3 / 12; % the moment of intertia

        % loading position delta divide the beam into two part a and part b
        L_a = 15 + delta;
        L_b = 15 - delta;
        
        % now for the actual execution for a ground truth:
         %n sets of measurements
        %29 points along the beam

 


        Nsample = size(F,1);
        Y = zeros(Nsample,29);

        for ii = 1: Nsample

            for jj = 1 : 29
            % calculate the xi values:
            xi = jj/30* L;
    
    
            %calculate deflection part A and part B
                if xi <= L_a
                    Y(ii,jj) = F(ii,1) .* L_b .* xi ./ (6 .* L .* E .* I)  .* ((L.^2 - L_b.^2) - xi.^2);
                    %measurement error                   
                    %error_scale = noisePercentage.* Y(ii,jj); 
                    error_scale = 0.* Y(ii,jj);
                    error = normrnd(0,error_scale);
                    Y(ii,jj) =  Y(ii,jj) + error;
    
                else
                     Y(ii,jj) = F(ii,1).*L_b/ (6.*L.*E.*I) .* (L/L_b.*(xi-L_a).^3 + (L.^2 - L_b.^2).*xi - xi.^3 ); 
                    %measurement error 
                    %error_scale = noisePercentage.* Y(ii,jj); 
                    error_scale = 0.* Y(ii,jj);                   
                    error = normrnd(0,error_scale);  
                    Y(ii,jj) =  Y(ii,jj) + error;   
    
                end
    

            end

        
        end
   


end 


