function [ symbols, freq , Pr, location] = source_stat(str)
  
%   str = fileread('test.txt');

  [symbols,~,location] = unique(str);  % location save where the indexes of sybols whic will reconstruct the main string
  
  freq = histc(str, symbols);
  
  n = length(str);
  
  Pr = freq/n;

end