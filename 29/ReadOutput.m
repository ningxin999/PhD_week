function  output = ReadOutput(outputfilename)

% Keyword that identify the requested output
search_string = '                                INCREMENT     1 SUMMARY';
%get the outputfile name
[~,outputfilename,~] = fileparts(outputfilename);
%read all lines in outputfile 
textinc = string(readlines([outputfilename,'.dat']));
% find the initial  line started with 
found = find(strcmp(textinc, search_string));

% Shorten cell array to only after the search string.
if isempty(found)
    warning(['Search string "' search_string '" not found in file: .dat']);
    return
else
    textinc_shortened = textinc(found:end);
end

% define the increment number and every increment starting line
inc = 1:50;
increment = string(inc);

for k=1:size(inc,2)
    incre_N = sprintf('%6d', k);
    increment(k) = append('                                INCREMENT', incre_N, ' SUMMARY');
end

%loop to get the output and save the output the new file "FE_Result"

%count number for total increment
j = 0;
%initial data for output
findata=zeros(0,0);
for i=1:length(textinc_shortened)
    % start with the every increment output beginning line 
    if  contains(textinc_shortened(i),increment)
        % get the first line and last line including the output
        First_line = i+19; 
        Last_line = First_line + 28;

        % save results of interest
        j=j+1;
        t=str2double(split(textinc_shortened(First_line:Last_line))); 
        findata(:,j)=t(:,3);  % y-coordinates

    end
end

% create a new folder to save the results
subfolder = 'FE_Result';
if ~exist(subfolder, 'dir')
    mkdir(subfolder);
end

save(fullfile(subfolder, outputfilename), 'findata');

N_Row = size(findata,1);
N_Col = size(findata,2);

%Note: reshape is very important, because uqlab only support vector 
% output, not support matrix output

output = reshape(findata,1,N_Row*N_Col);
% display the FE running progress
disp([outputfilename  ' is finished!'])

end



