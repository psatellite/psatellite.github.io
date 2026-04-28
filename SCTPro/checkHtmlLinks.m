function report = checkHtmlLinks(oldHtmlFile, newHtmlFile)

oldText = fileread(char(oldHtmlFile));
newText = fileread(char(newHtmlFile));

oldLinks = extractLinks(oldText);
newLinks = extractLinks(newText);

missing = {};

for i = 1:numel(oldLinks)
    if ~any(strcmp(oldLinks{i}, newLinks))
        missing{end+1,1} = oldLinks{i};
    end
end

fprintf('\n=====================================\n');
fprintf('HTML LINK CHECK REPORT\n');
fprintf('=====================================\n');

fprintf('Old links found: %d\n', numel(oldLinks));
fprintf('New links found: %d\n', numel(newLinks));
fprintf('Missing links:   %d\n\n', numel(missing));

if isempty(missing)
    fprintf('PASS: All old links exist in the new HTML.\n');
else
    fprintf('FAIL: Missing links:\n');
    for i = 1:numel(missing)
        fprintf('  %s\n', missing{i});
    end
end

report.oldLinks = oldLinks;
report.newLinks = newLinks;
report.missingLinks = missing;

end

function links = extractLinks(txt)

patterns = {
    'href\s*=\s*["'']([^"'']+)["'']'
    'url\s*:\s*["'']([^"'']+)["'']'
};

links = {};

for p = 1:numel(patterns)
    tokens = regexp(txt, patterns{p}, 'tokens');
    for k = 1:numel(tokens)
        link = normalizeLink(tokens{k}{1});
        if ~isempty(link) && ~any(strcmp(link, links))
            links{end+1,1} = link;
        end
    end
end

end

function s = normalizeLink(s)

s = strtrim(char(s));

if isempty(s)
    return
end

if strcmp(s(1), '#')
    s = '';
    return
end

lowerS = lower(s);

if startsWithCompat(lowerS, 'http://') || ...
   startsWithCompat(lowerS, 'https://') || ...
   startsWithCompat(lowerS, 'mailto:') || ...
   startsWithCompat(lowerS, 'javascript:')
    s = '';
    return
end

hashIndex = strfind(s, '#');
if ~isempty(hashIndex)
    s = s(1:hashIndex(1)-1);
end

s = strrep(s, '\', '/');

end

function tf = startsWithCompat(s, prefix)

tf = length(s) >= length(prefix) && strcmp(s(1:length(prefix)), prefix);

end