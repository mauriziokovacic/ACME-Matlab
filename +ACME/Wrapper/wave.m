function [f] = wave(theta,period,cutoff,dumping)
f = dumping * (1-theta).^cutoff .* sin(period*theta*2*pi);
end