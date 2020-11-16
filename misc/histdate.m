function [counts, bins, bins_center] = histdate(dates,interval)

if nargin < 2
    interval  = days(7);
end

minimal_date     = min(dates);
minimal_date_str = datestr(minimal_date,'01-01-yyyy 00:00:00');
minimal_edge     = datetime(minimal_date_str, 'InputFormat', 'dd-MM-yyyy 00:00:00');

maximal_date     = max(dates);
maximal_date_str = datestr(maximal_date,'01-01-yyyy 00:00:00');
maximal_edge     = datetime(maximal_date_str, 'InputFormat', 'dd-MM-yyyy 00:00:00');


bins = minimal_edge:interval:(maximal_edge+ interval);

bins_center = bins(1:end-1) + interval/2;

counts = nan(size(bins_center));

for t = 1 : length(bins)-1
    id_time_edge = (bins(t) <= dates) & (dates < bins(t+1));
    counts(t) = sum(id_time_edge);
end

