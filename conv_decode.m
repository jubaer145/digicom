function [decoded_stream] = conv_decode(received_stream,generators,k,number_of_bits)

  length_of_recieved_stream = length(received_stream);
  
  [n, block_size] = size(generators);
  
  col = 2^(block_size-k);
  
  k_len = 2^k;
  
  possible_transitions =  mod((0:2^block_size - 1),col)';
  
  possible_solutions = mod(fliplr(dec2bin(0:2^block_size-1) - '0') * generators',2);
  
  [row,blocks] = size(possible_solutions);
  
  flag = 1;
  
  path_metric = zeros(col, 2*length_of_recieved_stream / blocks + 2);
  
  path_metric(:,1:2) = inf*ones(col,2);
  
  path_metric(1,1) = 0;
  
  for i = 1:blocks:length_of_recieved_stream
          
          checker_matrix = meshgrid(received_stream(i:i+blocks-1), ones(row,1));
          
          branch_metric = sum(xor(checker_matrix , possible_solutions),2);
          
          result_matrix = inf * ones(col,2);
          
          for j = 1:row
              
              ind  = ceil(j/k_len);
              
              if (branch_metric(j)+path_metric(ind,flag)) < result_matrix(possible_transitions(j)+1,1);
              
                  result_matrix(possible_transitions(j)+1,1) = (branch_metric(j)+path_metric(ind,flag));
                  
                  result_matrix(possible_transitions(j)+1,2) = j;
                  
              end
              
          end
          
          path_metric(:,flag+2:flag+3) =  result_matrix;
          
          flag = flag + 2;
          
  end
  
  ii = (flag+1)/2;
  
  decoded_stream = zeros(1,ii);
  
  index = 1;
  
  for i = flag+1:-2:2
    
      decoded_stream(ii) = mod(index-1, k_len) ;
      
      index = path_metric(ceil(index/k_len),i);
      
      ii = ii - 1;
      
  end
  
  decoded_stream = dec2bin(decoded_stream) - '0';
  
  decoded_stream = decoded_stream';
  
  decoded_stream = decoded_stream(:)';
  
  decoded_stream = decoded_stream(1:number_of_bits);
  
end