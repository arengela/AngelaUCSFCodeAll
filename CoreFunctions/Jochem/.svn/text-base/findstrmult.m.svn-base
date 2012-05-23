function [rows,varargout] = findstrmult(strarray,sstring)

% [rows,columns] = findstrmult(strarray) Find a substring in a cell or character array of strings
%
% Purpose: Find a substring in a character (2D) or cell (1D) array of strings.
%          This function extends the findstr function to string arrays.
%          If no match was found the empty matrix is returned.
%
% Input:   
% strarray:The string array as character or cell array. The arrays
%          are searched in their original format. 
% sstring: A character array containing the string to be searched
%
% Output:  
% rows:    A vector with  indices to the rows containing the search string.
% columns: Optional. A cell array with indices to the columns in which
%          the start of the search string was found. Columns is of the same
%          size as rows.  

%initialize some variables
rows = []; columns = {[]};

if iscell(strarray)
  for k=1:length(strarray)
    tmp = findstr(strarray{k},sstring);
    if ~isempty(tmp)
      rows = [rows k];
      columns{length(rows)} = tmp;
    end
  end
end
if ischar(strarray)
  for k=1:size(strarray,1)
    tmp = findstr(strarray(k,:),sstring);
    if ~isempty(tmp)
      rows = [rows k];
      columns{length(rows)} = tmp;
    end
  end
end

if nargout>1
  varargout{1} = columns;
end