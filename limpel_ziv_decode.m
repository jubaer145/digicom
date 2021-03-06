function [decoded_msg] = limpel_ziv_decode(enc, dict, dict_ind, max_enc)

binary = enc
dict_sym = dict;
dict_ind = dict_ind;

bits= floor(log2(max_enc)) + 1 % This quantity is changed according to the number of bits required to encode each decimal index. %

%%%% Binary to decimal index conversion %%%%
k= 1;
for i= 1:bits:length(binary)-bits+1
    
    temp= bin2dec(binary(i:i+bits-1))
    
    
    incoming_msg{k} = num2str(temp)
    
    k= k+1;
    
end



 


dec_msg= cell(1,10);
curr_index= length(dict_ind)
 
len= length(incoming_msg);
 
for i= 1: len  
    
    found= 0;
    
    for ind= 1:curr_index
    
       if strcmp(incoming_msg{i}, dict_ind(ind))
           found= 1;
           dec_msg{i}= char(dict_sym(ind));           
           
           if i>1
                    a= dec_msg(i-1);
                    b= dec_msg(i);
                    a= cast(a,'char');
                    b= cast(b,'char');
                    curr_index= curr_index+1;
                    dict_sym{curr_index}= char(strcat(a, b(1))); 
                    dict_ind{curr_index}= num2str(curr_index-1);          
                                                                       
           end                        
         
           break;
           
        end
           
      end
            
       
       if ~found        
            a= dec_msg(i-1);
            a= cast(a,'char');            
            curr_index= curr_index+1;
            dict_sym{curr_index}= char(strcat(a, a(1)));
            dict_ind{curr_index}= num2str(curr_index-1); 
            dec_msg{i}= char(dict_sym(curr_index));                
        
       end    
 
    
       
 
end    
 
dict_sym
dict_ind
dec_msg

temp= ' ';
for i= 1:length(dec_msg)
temp= strcat(temp, char(dec_msg(i)));
end
 
disp(temp)

decoded_msg = temp;


end