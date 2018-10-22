def getOperando():
    while True:

        a = raw_input("Ingrese el operando (Recuerde que se trabaja con variables de 8 bits): ")

        try:
            print int(a, 2)
            if int(a, 2) not in range(256):
                print("Error, \"{}\" es un valor fuera de rango".format(a))

            else:
                return int(a, 2)

        except:
            print ("Error, %s no es un valor valido" % a)


def getOperador():
    codes = {
        '+': 0b100000,
        '-': 0b100010,
        '&': 0b100100,
        '|': 0b100101,
        '^': 0b100110,
        '}': 0b000011,
        ']': 0b000010,
        '~': 0b100111
    }

    while True:
        print(" ADD : + \n "
              " SUB : - \n "
              " AND : & \n "
              " OR  : | \n "
              " XOR : ^ \n "
              " SRA : } \n "
              " SRL : ] \n "
              " NOR : ~")

        user_op = raw_input("Ingrese el operador: ")

        if (user_op in codes):
            return codes[user_op]

        else:
            print("Operando incorrecto, los valores posibles son:")
            print(" ADD : + \n "
                  " SUB : - \n "
                  " AND : & \n "
                  " OR  : | \n "
                  " XOR : ^ \n "
                  " SRA : } \n "
                  " SRL : ] \n "
                  " NOR : ~"
                  )


import serial  # PySerial

''' Main program'''

ser = serial.Serial('/dev/ttyUSB1')  # abro puerto
print ('Puerto abierto: ', ser.name)

ope1 = getOperando()  # obtengo op1, op2, y opcode
sent = ser.write(chr(ope1))  # envio op1, op2, opcode
ope2 = getOperando()
sent = ser.write(chr(ope2))  # envio op1, op2, opcode
opcode = getOperador()
sent = ser.write(chr(opcode))

print(" a = {} \n b = {} \n op = {}".format(bin(ope1), bin(ope2), bin(opcode)))

out_fpga = ser.read()  # leo salida de placa
# print(x)
print "Resultado = ", bin(ord(out_fpga))
ser.close()

'''
Para testing, descomentar


a = 0b01010101
b = 0b11111111
op = 0b100100


while(1):

    print(" a = {} \n b = {} \n op = {}".format(bin(a),bin(b),bin(op)))

    sent = ser.write(chr(a))
    sent = ser.write(chr(b))
    sent = ser.write(chr(op))


    x = ser.read()
    #print(x)
    print "Resultado = ", bin(ord(x))
    ser.flush()





ser.close()
'''
