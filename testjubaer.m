clear all;
clc;
close all;
 
msg= 'ABABCABCBAAAAB';
max_enc = 0;

dict_sym{1}= 'A'; dict_sym{2}= 'B'; dict_sym{3}= 'C';
dict_ind{1}= '0'; dict_ind{2}= '1'; dict_ind{3}= '2';
 
enc_msg= cell(1, 9);
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
           index= ind         
           
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

enc_array = cell2mat(enc_msg); %convert cell to array


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



binary= dec2bin(str2num(char(enc_msg)));% Converts to fixed length but variable binary codes
binary
binary = binary';
binary = (binary(:))';


 
bits= floor(log2(max_enc)) + 1; % This quantity is changed according to the number of bits required to encode each decimal index. %

%%%% Binary to decimal index conversion %%%%
k= 1;
for i= 1:bits:length(binary)-bits+1
    
    temp= (bin2dec(binary(i:i+bits-1)))
    
    incoming_msg{k} = (num2str(temp))
    disp('hahahahaaaaaaaaaaaaaaaa')
    
    k= k+1;
    
end



 


dec_msg= cell(1,8);
curr_index= 3; 
 
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
 
%disp(temp)


if strcmp(temp, msg)
    disp('successful')
else 
    disp('not')
end

