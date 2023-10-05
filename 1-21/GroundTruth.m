
function Y = GroundTruth(E,delta,F,N,errorPerc)

        b = 0.15; % beam width  (m)
        h = 0.3; % beam height (m)
        L = 30; % beam length (m)        
        I = b.* h.^3 / 12; % the moment of intertia

        % loading position delta divide the beam into two part a and part b
        L_a = 15 + delta;
        L_b = 15 - delta;
        
        % now for the actual execution for a ground truth:
         %n sets of measurements
        for i = 1:N
        %9 points along the beam
            for jj = 1 : 29
            % calculate the xi values:
            xi = jj/30* L;
            %calculate deflection part A and part B
                if xi <= L_a
                    Y(i,jj) = F*L_b*xi/ (6*L*E*I) * ((L^2 - L_b^2) - xi^2);
                    %measurement error 3%                    
                    error_scale = errorPerc*Y(i,jj);                    
                    error = normrnd(0,error_scale);
                    Y(i,jj) = Y(i,jj) + error;

                else
                    Y(i,jj) = F*L_b/ (6*L*E*I) * (L/L_b*(xi-L_a)^3 + (L^2 - L_b^2)*xi - xi^3 ); 
                    %measurement error 3%
                    error_scale = errorPerc*Y(i,jj);                    
                    error = normrnd(0,error_scale);  
                    Y(i,jj) = Y(i,jj) + error;   

                end
                       
            end

        end
        
        
   


end 