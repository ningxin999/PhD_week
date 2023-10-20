
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
        for ii = 1:N
        %9 points along the beam
            for jj = 1 : 29
            % calculate the xi values:
            xi = jj/30* L;
            %calculate deflection part A and part B
                     if xi <= L_a
                    Y(ii,jj) = F(ii,1) .* L_b(ii,1) * xi .* ((L.^2 - L_b(ii,1).^2) - xi.^2) / (6 * L * E(ii,1) * I)  ;


                    else
                    Y(ii,jj) = F(ii,1).* L_b(ii,1).* (L./L_b(ii,1).*(xi-L_a(ii,1)).^3 + (L.^2 - L_b(ii,1).^2).*xi - xi.^3 )/ (6*L*E(ii,1)*I) ;


                     end

                       
            end

        end

        NoiseStd = mean(errorPerc * std(Y));
        
        noise = normrnd(0, NoiseStd , [size(Y,1) size(Y,2)]);
        
        Y = Y + noise;
        
        
   


end 