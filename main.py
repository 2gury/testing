import random
import base64

IP = [58, 50, 42, 34, 26, 18, 10, 2,
      60, 52, 44, 36, 28, 20, 12, 4,
      62, 54, 46, 38, 30, 22, 14, 6,
      64, 56, 48, 40, 32, 24, 16, 8,
      57, 49, 41, 33, 25, 17, 9,  1,
      59, 51, 43, 35, 27, 19, 11, 3,
      61, 53, 45, 37, 29, 21, 13, 5,
      63, 55, 47, 39, 31, 23, 15, 7]

B = [57, 49, 41, 33, 25, 17, 9,
     1,  58, 50, 42, 34, 26, 18,
     10, 2,  59, 51, 43, 35, 27,
     19, 11, 3,  60, 52, 44, 36,
     63, 55, 47, 39, 31, 23, 15,
     7,  62, 54, 46, 38, 30, 22,
     14, 6,  61, 53, 45, 37, 29,
     21, 13, 5,  28, 20, 12, 4]

CP = [14, 17, 11, 24, 1,  5,  3,  28,
      15, 6,  21, 10, 23, 19, 12, 4,
      26, 8,  16, 7,  27, 20, 13, 2,
      41, 52, 31, 37, 47, 55, 30, 40,
      51, 45, 33, 48, 44, 49, 39, 56,
      34, 53, 46, 42, 50, 36, 29, 32]

E = [32, 1,  2,  3,  4,  5,
     4,  5,  6,  7,  8,  9,
     8,  9,  10, 11, 12, 13,
     12, 13, 14, 15, 16, 17,
     16, 17, 18, 19, 20, 21,
     20, 21, 22, 23, 24, 25,
     24, 25, 26, 27, 28, 29,
     28, 29, 30, 31, 32, 1]

S = [[[14, 4,  13, 1, 2,  15, 11, 8,  3,  10, 6,  12, 5,  9,  0, 7],
      [0,  15, 7,  4, 14, 2,  13, 1,  10, 6,  12, 11, 9,  5,  3, 8],
      [4,  1,  14, 8, 13, 6,  2,  11, 15, 12, 9,  7,  3,  10, 5, 0],
      [15, 12, 8,  2, 4,  9,  1,  7,  5,  11, 3,  14, 10, 0,  6, 13],],

     [[15, 1,  8,  14, 6,  11, 3,  4,  9,  7, 2,  13, 12, 0, 5,  10],
      [3,  13, 4,  7,  15, 2,  8,  14, 12, 0, 1,  10, 6,  9, 11, 5],
      [0,  14, 7,  11, 10, 4,  13, 1,  5,  8, 12, 6,  9,  3, 2,  15],
      [13, 8,  10, 1,  3,  15, 4,  2,  11, 6, 7,  12, 0,  5, 14, 9],],

     [[10, 0,  9,  14, 6, 3,  15, 5,  1,  13, 12, 7,  11, 4,  2,  8],
      [13, 7,  0,  9,  3, 4,  6,  10, 2,  8,  5,  14, 12, 11, 15, 1],
      [13, 6,  4,  9,  8, 15, 3,  0,  11, 1,  2,  12,  5, 10, 14, 7],
      [1,  10, 13, 0,  6, 9,  8,  7,  4,  15, 14, 3,  11, 5,  2,  12],],

     [[7,  13, 14, 3, 0,  6,  9,  10, 1,  2, 8, 5,  11, 12, 4,  15],
      [13, 8,  11, 5, 6,  15, 0,  3,  4,  7, 2, 12, 1,  10, 14, 9],
      [10, 6,  9,  0, 12, 11, 7,  13, 15, 1, 3, 14, 5,  2,  8,  4],
      [3,  15, 0,  6, 10, 1,  13, 8,  9,  4, 5, 11, 12, 7,  2,  14],],

     [[2,  12, 4,  1,  7,  10, 11, 6,  8,  5,  3,  15, 13, 0, 14, 9],
      [14, 11, 2,  12, 4,  7,  13, 1,  5,  0,  15, 10, 3,  9, 8,  6],
      [4,  2,  1,  11, 10, 13, 7,  8,  15, 9,  12, 5,  6,  3, 0,  14],
      [11, 8,  12, 7,  1,  14, 2,  13, 6,  15, 0,  9,  10, 4, 5,  3],],

     [[12, 1,  10, 15, 9, 2,  6,  8,  0,  13, 3,  4,  14, 7,  5,  11],
      [10, 15, 4,  2,  7, 12, 9,  5,  6,  1,  13, 14, 0,  11, 3,  8],
      [9,  14, 15, 5,  2, 8,  12, 3,  7,  0,  4,  10, 1,  13, 11, 6],
      [4,  3,  2,  12, 9, 5,  15, 10, 11, 14, 1,  7,  6,  0,  8,  13],],

     [[4,  11, 2,  14, 15, 0, 8,  13, 3,  12, 9, 7,  5,  10, 6, 1],
      [13, 0,  11, 7,  4,  9, 1,  10, 14, 3,  5, 12, 2,  15, 8, 6],
      [1,  4,  11, 13, 12, 3, 7,  14, 10, 15, 6, 8,  0,  5,  9, 2],
      [6,  11, 13, 8,  1,  4, 10, 7,  9,  5,  0, 15, 14, 2,  3, 12],],

     [[13, 2,  8,  4, 6,  15, 11, 1,  10, 9,  3,  14, 5,  0,  12, 7],
      [1,  15, 13, 8, 10, 3,  7,  4,  12, 5,  6,  11, 0,  14, 9,  2],
      [7,  11, 4,  1, 9,  12, 14, 2,  0,  6,  10, 13, 15, 3,  5,  8],
      [2,  1,  14, 7, 4,  10, 8,  13, 15, 12, 9,  0,  3,  5,  6,  11],]]

P = [16, 7,  20, 21, 29, 12, 28, 17,
     1,  15, 23, 26, 5,  18, 31, 10,
     2,  8,  24, 14, 32, 27, 3,  9,
     19, 13, 30, 6,  22, 11, 4,  25]

IP_1 = [40, 8, 48, 16, 56, 24, 64, 32,
        39, 7, 47, 15, 55, 23, 63, 31,
        38, 6, 46, 14, 54, 22, 62, 30,
        37, 5, 45, 13, 53, 21, 61, 29,
        36, 4, 44, 12, 52, 20, 60, 28,
        35, 3, 43, 11, 51, 19, 59, 27,
        34, 2, 42, 10, 50, 18, 58, 26,
        33, 1, 41, 9,  49, 17, 57, 25]

Shift = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

def str_to_bits(text):
    array = list()
    for char in text:
        bits = chr_to_bits(char)
        for i in range(8):
            array.append(int(bits[i]))
    return array


def chr_to_bits(val):
    bits = bin(ord(val))[2:]
    return '0' * (8 - len(bits)) + bits

def int_to_bits(val):
    bits = bin(val)[2:]
    return '0' * (4 - len(bits)) + bits

def bits_to_str(array):
    res = ''
    bytes = split_into_n(array, 8)
    for i in range(len(bytes)):
        char = ''
        for j in range(len(bytes[i])):
            char += str(bytes[i][j])
        res += chr(int(char, 2))
    return res

def split_into_n(s, n):
    splited_list = []
    for i in range(0, len(s), n):
        splited_list.append(s[i : i + n])
    return splited_list

def permutation( block, table):
    new_block = []
    for i in table:
        new_block.append(block[i - 1])
    return new_block

def generate_rkeys(key):
    keys = []
    key = str_to_bits(key)
    key = permutation(key, B)
    C, D = split_into_n(key, 28)
    for i in range(16):
        C = shift(C, Shift[i])
        D = shift(D, Shift[i])
        tmp = C + D
        keys.append(permutation(tmp, CP))
    return keys

def generate_key():
    key = ""
    for i in range(8):
        key += chr(random.randint(0, 256))
    return key

def shift(array, n):
    return array[n:] + array[:n]

def Feistel(R, key):
    #Расширяющая перестановка E (32->48 бит)
    eR = permutation(R, E)
    tmp = xor(key, eR)
    subblocks = split_into_n(tmp, 6)
    result = []
    for i in range(8):
        block = subblocks[i]
        row = int(str(block[0]) + str(block[5]), 2)
        num = ''
        for j in range(1, 5):
            num += str(block[j])
        column = int(num, 2)
        val = S[i][row][column]
        bin = int_to_bits(val)
        for i in range(len(bin)):
            result.append(int(bin[i]))
    return permutation(result, P)

def cipher(text, key):
    if len(text) % 8 != 0:
        text += (8 - len(text) % 8) * ' '
    rkeys = generate_rkeys(key)
    text_blocks =  split_into_n(text, 8)
    result = []
    for block in text_blocks:
        block = str_to_bits(block)
        #Начальная перестановка IP (64 бит)
        block = permutation(block, IP)

        #Разделение на левую (L) и правую (R) половины (32 бит)
        L, R = split_into_n(block, 32)
        for i in range(16):
            tmp = Feistel(R, rkeys[i])
            tmp = xor(L, tmp)
            L = R
            R = tmp

        #Конечная перестановка IP-1
        result += permutation(R + L, IP_1)
    return bits_to_str(result)

def decipher(text, key):
    rkeys = generate_rkeys(key)
    text_blocks = split_into_n(text, 8)
    result = []
    for block in text_blocks:
        block = str_to_bits(block)
        # Начальная перестановка IP (64 бит)
        block = permutation(block, IP)

        # Разделение на левую (L) и правую (R) половины (32 бит)
        L, R = split_into_n(block, 32)
        for i in range(15, -1, -1):
            tmp = Feistel(R, rkeys[i])
            tmp = xor(L, tmp)
            L = R
            R = tmp

        # Конечная перестановка IP-1
        result += permutation(R + L, IP_1)
    return bits_to_str(result)

def xor(first, second):
    xored = []
    for i in range(len(first)):
        xored.append(first[i] ^ second[i])
    return xored

if __name__ == "__main__":
    key = "12345678"
    file = "message.txt"
    #file = "zip.zip"
    message = ""

    while (True):
        print("[1] - Cipher message\n"
              "[2] - Decipher message\n"
              "[3] - Generate key\n"
              "[0] - Exit\n")
        command = input("Input:").replace(" ", "")
        if command == '0':
            break;
        elif command == '1':
            message = ""
            f = open(file, "rb");
            message = f.read();
            base64_bytes = base64.b64encode(message)
            base64_message = base64_bytes.decode('ascii')
            f.close()
            message = cipher(str(base64_message), key)
            f = open(file, "w");
            f.write(message);
            f.close()
        elif command == '2':
            deciphered = decipher(str(message), key)
            base64_bytes = base64.b64decode(deciphered)
            f = open(file, "wb");
            f.write(base64_bytes);
            f.close()
        elif command == '3':
            key = generate_key()
            print(key)
        print("\n")

