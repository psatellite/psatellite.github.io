% Remove "Children" section and "Back" link from all HTML files 

htmlDir = 'FormationFlying/FormationFlyingHeaders';
files = dir(fullfile(htmlDir, '*.html'));

fprintf('Found %d HTML files to process.\n', numel(files));

for i = 1:numel(files)
    filepath = fullfile(files(i).folder, files(i).name);
    
    % Read file content
    fid = fopen(filepath, 'r');
    content = fread(fid, '*char')';
    fclose(fid);
    
    original = content;
    
    % Remove Children section:
    % Matches <h2>Children:</h2> ... </pre> (including all links inside)
    content = regexprep(content, ...
        '<h2>Children:</h2>\s*<pre>.*?</pre>', ...
        '', 'dotall');
    
    % Remove the Back link line:
    % Matches <hr><p> ... Back ... </p>
    content = regexprep(content, ...
        '<hr><p>.*?</p>', ...
        '', 'dotall');
    
    % Only write if something changed
    if ~strcmp(content, original)
        fid = fopen(filepath, 'w');
        fwrite(fid, content);
        fclose(fid);
        fprintf('Cleaned: %s\n', files(i).name);
    else
        fprintf('No changes: %s\n', files(i).name);
    end
end

fprintf('Done.\n');