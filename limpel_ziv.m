function [encoded, max] = limpel_ziv(msg, dict, ind)
dict_sym = dict;
dict_ind = ind;

msg = msg;
max_enc = 0; %store the maximum encoded value
enc_msg= cell(1, 10);
curr_index= length(dict_ind); 
 
k= 1;
temp= ' ';
j= 1; 
 
while j<=length(msg)
    
    temp= '';
    found= 0;
    
 
for i= j:length(msg)   
    
    temp= strcat(temp, msg(i));
    found= 0;
    
    for ind= 1:curr_index
    
       if strcmp(temp, dict_sym(ind))
           found= 1;
           index= ind;           
           
       end       
           
        
    end



    
    if ~found       
        curr_index= curr_index+1;
        dict_sym{curr_index}= temp;
        len= length(temp);
        dict_ind{curr_index}= num2str(curr_index-1);        
        break;       
    end  
    
end
 
j= j+len-1;
enc_msg{k}= dict_ind{index};
k= k+1;       
 
end 

enc_array = cell2mat(enc_msg);

for i = 1:length(enc_array)
    tmp = str2num(enc_array(i))
    if tmp > max_enc
        disp('inside......')
        max_enc = tmp
    end
end

 
dict_sym
dict_ind
enc_msg

binary= dec2bin(str2num(char(enc_msg))); % Converts to fixed length but variable binary codes
binary = binary';
binary = (binary(:))';

encoded = binary;
max = max_enc;

end
