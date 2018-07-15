function [ encoded_data , dict ] = source_code( dictionary, probability_array , indexes, source_encoding_method )
    
    
    workspace;
    dict = huffman_dict (probability_array);
    
    
    workspace;
    encoded_data = [dict{indexes}];

end
