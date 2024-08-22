import math
import os

#definition of the xor operation
def xor(bit1, bit2):
    if(bit1 == bit2):
        return '0'
    else:
        return '1'

#utility function used to convert the content of a list into a string
def toString(l):
    s = l[0]+l[1]+l[2]+l[3]+l[4]+l[5]+l[6]+l[7]

    return s

#function used to initialize 𝑀6 as {𝑀[5], 𝑀[7] ⊕ 𝑀[2], 𝑀[3], 𝑀[0], 𝑀[4] ⊕ 𝑀[1], 𝑀[6]}
def init_M_six(c):

    #converting the character into its binary rapresentation
    c_bits = bin(ord(c)).replace('b','')

    #result containing the value that will be taken from M_six
    res = [None] * 6

    #compression function
    res[5] = c_bits[2]
    res[4] = xor(c_bits[0], c_bits[5])
    res[3] = c_bits[4] 
    res[2] = c_bits[7]
    res[1] = xor(c_bits[3], c_bits[6]) 
    res[0] = c_bits[1] 

    return res

#function used to initialize the H vector with the default values
def init_H():
    H_temp = [None] * 8

    #initialization of H with the init values rappresented in 4 bits
    H_temp[7] = "1111"       #4'hF     
    H_temp[6] = "0011"       #4'h3
    H_temp[5] = "1100"       #4'hC
    H_temp[4] = "0010"       #4'h2
    H_temp[3] = "1001"       #4'h9
    H_temp[2] = "1101"       #4'hD
    H_temp[1] = "0100"       #4'h4    
    H_temp[0] = "1011"       #4'hB
    
    return H_temp

#function used to compute the SBox
def compute_sBox(M_six, sBox):

    row = int(M_six[5]+M_six[0], 2)
    column = int(M_six[4]+M_six[3]+M_six[2]+M_six[1], 2)

    return sBox[row][column]

def compute_round(H, sBox_result, left):

    temp = [None] * 4

    temp[3] = xor(H[0], sBox_result[0])
    temp[2] = xor(H[1], sBox_result[1])
    temp[1] = xor(H[2], sBox_result[2])
    temp[0] = xor(H[3], sBox_result[3])

    round_res = ""

    #implementation of the left rotation
    for i in range (0, 4):
        round_res += temp[3-(i+left)]

    return round_res

#implementation of the light hash DES algorithm as a function
def lightHashDES(test, sBox, H):
    #declaration and initialization of the message from std input
    M = test

    temp_res = [None] * 8
    H_out = [None] * 8

    if test == '':
        return H

    #implementation of the Light Hash DES Algorithm                                 
    for c in M:
        M_six = init_M_six(c)
        sBox_result = compute_sBox(M_six, sBox)

        for r in range (0, 4):
            if r == 0 :
                H_out[7] = compute_round(H[5], sBox_result, math.floor(0/2))
                H_out[6] = compute_round(H[4], sBox_result, math.floor(1/2))
                H_out[5] = compute_round(H[3], sBox_result, math.floor(2/2))
                H_out[4] = compute_round(H[2], sBox_result, math.floor(3/2))
                H_out[3] = compute_round(H[1], sBox_result, math.floor(4/2))
                H_out[2] = compute_round(H[0], sBox_result, math.floor(5/2))
                H_out[1] = compute_round(H[7], sBox_result, math.floor(6/2))
                H_out[0] = compute_round(H[6], sBox_result, math.floor(7/2))
            else:
                H_out[7] = compute_round(temp_res[5], sBox_result, math.floor(0/2))
                H_out[6] = compute_round(temp_res[4], sBox_result, math.floor(1/2))
                H_out[5] = compute_round(temp_res[3], sBox_result, math.floor(2/2))
                H_out[4] = compute_round(temp_res[2], sBox_result, math.floor(3/2))
                H_out[3] = compute_round(temp_res[1], sBox_result, math.floor(4/2))
                H_out[2] = compute_round(temp_res[0], sBox_result, math.floor(5/2))
                H_out[1] = compute_round(temp_res[7], sBox_result, math.floor(6/2))
                H_out[0] = compute_round(temp_res[6], sBox_result, math.floor(7/2))

            for k in range (0, 8):
                temp_res[k] = H_out[k]

        for k in range (0, 8):
            H[k] = H_out[k]
    
    return H_out

#declaration of the S-Box 
sBox = 4*[16*[0]]

#initialization of the S-Box by rows
sBox[0] = ( "0010", "1100", "0100", "0001", "0111", "1010", "1011", "0110", 
            "1000", "0101", "0011", "1111", "1101", "0000", "1110", "1001" )

sBox[1] = ( "1110", "1011", "0010", "1100", "0100", "0111", "1101", "0001", 
            "0101", "0000", "1111", "1100", "0011", "1001", "1000", "0110" )

sBox[2] = ( "0100", "0010", "0001", "1011", "1100", "1101", "0111", "1000", 
            "1111", "1001", "1100", "0101", "0110", "0011", "0000", "1110" )

sBox[3] = ( "1011", "1000", "1100", "0111", "0001", "1110", "0010", "1101", 
            "0110", "1111", "0000", "1001", "1100", "0100", "0101", "0011" )

#declaration of H
H = init_H()

testbench = []

f = open("modelsim/tv/testbench.txt", 'r', encoding='utf-8')
out = open("modelsim/tv/test_results.txt", 'wb')                       #create the test file if it does not exists

for str in f.readlines():
    testbench.append(str.replace("\n", ""))

f.close()

#Test 1: empty string
res_test1 = lightHashDES(testbench[0], sBox, H)

res = toString(res_test1)

#writing in output file the first result
out.write(res.encode())
out.close()

#reopening the file to append the rest
out = open("modelsim/tv/test_results.txt", 'ab')

#Test 2: single character
H = []
H = init_H()

out.write(b'\n')
res_test2 = lightHashDES(testbench[1], sBox, H)

out.write(toString(res_test2).encode("utf-8"))
out.write(b'\n')

#Test 3: hash of two equal strings (Testing_equal_strings)
H = []
H = init_H()
res_test3 = lightHashDES(testbench[2], sBox, H)

out.write(toString(res_test3).encode("utf-8"))
out.write(b'\n')

H = []
H = init_H()
res_test4 = lightHashDES(testbench[3], sBox, H)

out.write(toString(res_test4).encode("utf-8"))
out.write(b'\n')

#Test 4: hash of two different strings (Testing_equal_strings, Testing_different)
H = []
H = init_H()
res_test5 = lightHashDES(testbench[4], sBox, H)

out.write(toString(res_test5).encode("utf-8"))
out.write(b'\n')

#Test 5: hash of strings that have different lenghts (Testing_equal_strings, Testing_equal_string)
H = []
H = init_H()
res_test6 = lightHashDES(testbench[5], sBox, H)

out.write(toString(res_test6).encode("utf-8"))
out.write(b'\n')
out.close()