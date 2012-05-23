function [outarr] = string2words(instr)

% [outarr] = string2words(instr) convert a string to an char array of words
% 
% Purpose: Convert a series of words located in a row vector of characters
%          into a char array of its constituting words. Default delimiter 
%          is whitespace
%
% Input:
% instr:   A row vector of characters containing the series of words.
% delim:   OPTIONAL The delimiter used to seperate the words (Not supported yet)
%
% Output:
% outarr:  A character array holding the words (padded with blanks)


outarr = char([]);
nextindex=1;

while nextindex<length(instr)
  instr = instr(nextindex:end);
  [tmpname,count,errmsh,nextindex] = sscanf(instr,'%s',1);
  outarr = strvcat(outarr(:,:),tmpname);
end

return


