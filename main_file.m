%%
close all;
clear all;
clc;

%reading from source data
%tic()
message = fileread('test.txt');
source_length = length(message);
%message = message(1:floor(source_length/2));

%%
%computing source_data statistics
[ symbs, freq , prob_arr, location] = source_stat(message);

dict_trial = cell(1, length(symbs));
dict_ind = cell(1, length(symbs));
for i = 1:length(symbs)
    dict_trial{i} = symbs(i);
    dict_ind{i} = num2str(i-1);
end

[enc, max] = limpel_ziv(message, dict_trial, dict_ind);

%%

[decoded_msg] = limpel_ziv_decode(enc, dict_trial, dict_ind, max)

%%
tic()
%flag_to_turn_on_huffman_coding = 1;

source_encoding_method = 1; % 1 for huffman, 0 for limpelziv

[source_encoded_msg,dict]= source_code(dictionay,prob_arr,location, source_encoding_method);





toc()
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Convolutional Coding part                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
number_of_output_bit_per_block = 4;
number_of_shifted_bits = 2;
block_size = 3;
number_of_bits_before_convolution = length(source_encoded_msg);
generators = [1 0 1 ; 1 1 1; 0 1 1; 1 0 0];

flag_to_turn_on_convolution_coding = 0;

if flag_to_turn_on_convolution_coding
    convolutional_coded_stream_signal = conv_code(source_encoded_msg,generators, number_of_shifted_bits);
else
    convolutional_coded_stream_signal = source_encoded_msg;
end

convolutional_coded_stream_signal =(convolutional_coded_stream_signal ==1);
toc()








%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           Line Coding Part                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
bit_rate = 51;
method = 'GMSK';
number_of_bits_before_line_coding = length(convolutional_coded_stream_signal);
modulated_signal  = line_code(convolutional_coded_stream_signal, bit_rate, method );
clear convolutional_coded_stream_signal;

toc()

display([ method ' Line Coding is Done' ])







%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              AWGN Channel                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
% SNR = -40:5:10;
% for i =1:length(SNR)
SNR  = -10;
%display([ method ' Signal is in channel ... ' dec2base(int16(i),10) ])
received_signal  = awgn_channel( modulated_signal, SNR );
% clear modulated_signal;
toc()








%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          Line Deoding Part                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
%display([ method ' Line Decoding Part is running ... ' dec2base(int16(i),10) ])
demodulated_signal  = line_decode( received_signal,bit_rate, method, number_of_bits_before_line_coding );
clear received_signal;
toc()






%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      Viterby Decoder part                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()

%display([ method ' Viterby Decoding Part is running ... ' dec2base(int16(i),10) ])
if flag_to_turn_on_convolution_coding
    viterby_decoded_stream = conv_decode(demodulated_signal,generators,number_of_shifted_bits,number_of_bits_before_convolution);
else
    viterby_decoded_stream = demodulated_signal;
end
clear demodulated_signal;
toc()










%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Huffman decoding part                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic()
%display([ method ' Source Decoding Part is running ... ' dec2base(int16(i),10) ])
if flag_to_turn_on_huffman_coding
    source_decoded_msg = huffman_decode(viterby_decoded_stream, dict, symbs);
else
    decoded_stream = reshape(viterby_decoded_stream, ceil(log2(N)),length(viterby_decoded_stream) / ceil(log2(N)))';
    decoded_stream = bin2dec(char(decoded_stream + '0'));
    source_decoded_msg = symbs(decoded_stream +1);
end

toc()











%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Output Testing                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc()

BER_GMSK_w_cc(i) = mean(abs(viterby_decoded_stream - source_encoded_msg));
% name_of_file = [method 'received_SNR' dec2base(int16(i),10) '.txt'];
% fileID = fopen(name_of_file,'w');
% fprintf(fileID,source_decoded_msg);
% fclose(fileID);


% end

display('finished')