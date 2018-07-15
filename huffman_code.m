function [ Encoded_msg , dictionary ] = huffman_code( probability_array , indexes )
    
    
    workspace;
    dictionary = huffman_dict (probability_array);
    
    
    workspace;
    Encoded_msg = [dictionary{indexes}];

end

