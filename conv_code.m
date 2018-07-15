function [coded_string] = conv_code(bit, generators, k)

    [n, block_size] = size(generators);
    
    bit_length = length(bit);
    
    coded_string = zeros(n, bit_length + block_size - 1);
    
    for i = 1:n
    
        coded_string(i,:) = mod(conv(bit,generators(i,:)),2);
        
    end
    
    [~, l] = size(coded_string);
    
    coded_string = coded_string(:,mod(1:l,k)==0);
    
    coded_string = coded_string(:)';
    

end