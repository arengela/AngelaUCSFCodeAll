function [sample] = findNearest(tim,time_array)

% [sample] = findNearest(tim,time_array)
% In a series of increasing timepoints (time_array) find the index closest to a desired
% time (tim)

% JR wrote it long time ago

sample = zeros(size(tim));
for k=1:length(tim)
    
    h=min(find(time_array >= tim(k)));
    if isempty(h) %larger than any value 
        sample(k)=length(time_array);
    elseif h==1 % smaller than any value 
        sample(k)=1;
    elseif abs(time_array(h)-tim(k))< abs(time_array(h-1)-tim(k)) %in interval:larer value is closer
        sample(k) = h;
    elseif  abs(time_array(h)-tim(k))>= abs(time_array(h-1)-tim(k)) %in interval:smaller value is closer
        sample(k) = h-1;
    else 
        error('nearest: Should never get here');
    end
end
  
