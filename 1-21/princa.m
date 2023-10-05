function [V,S,E,cumE,number]=princa(X,pe)
[m,n]=size(X); %calculate the rows and coloums of X
%-------------Step one: Normalized the matrix X-----------------%
mv=mean(X); % calculate the mean of X
st=std(X);  %calculate the standard diviation
X=(X-repmat(mv,m,1))./repmat(st,m,1); %Normalized matrix X
 

%-------------Step two: calcuate the Correlation coefficient matrix ------%
% R1=X'*X/(m-1); %Method 1: Covariance matrix calculation formula
% R2=cov(X);     %Method 2: Covariance matrix calculation function
R=corrcoef(X); %Method 3: Correlation coefficient matrix function
 

%-------------Step three: Calculate eigenvectors and eigenvalues----------%
[V,D]=eig(R);       % Calculates the eigenvector matrix V and eigenvalue 
                    % matrix D of matrix R, and the eigenvalues go from 
                    % small to large
V=(rot90(V))';      % Sorts the eigenvector matrix V from largest to smallest
D=rot90(rot90(D));  % Sorts the eigenvalue matrix from largest to smallest
E=diag(D);          % Converts an eigenvalue matrix to an eigenvalue vector
 
%Step 4: Calculate the contribution rate and cumulative contribution rate%
ratio=0; %Cumulative contribution rate
for k=1:n
    r=E(k)/sum(E);   %kth principal component contribution rate
    ratio=ratio+r;  %Cumulative contribution rate
    if(ratio>=0.9)  %Take the principal component whose cumulative contribution
                    % rate is greater than or equal to 90%
        break;
    end
end
%-------------       ---------------%
sumE=sum(E);
tep=E./sumE;
cumE=cumsum(tep);
temp1=find(cumE>pe);
number=min(temp1);
%------------- Step 5: Calculate the score -----------------%
S=X*V;