#!/usr/bin/python
##################################################################################################################
#                                                                                                                #
#    Script para enviar datos del RPi y el hat UPS Pico HV3.0 al emoncms a traves metodo GET de HTML             #
#                                                                                                                #
# Date:     10/04/18                                                                                             #
# Author:   Juan Taba Gasha                                                                                      #
# Last rev: 20/04/18                                                                                             #
##################################################################################################################

import subprocess
import smbus
import pycurl

def post_data_emoncms():

	try:
                data=[0 for i in range(12)]
		# data[0] Cantidad de memoria libre y usada del sistema  (Memoria RAM disponible = RAM libre + buffer + cache)
		p1=subprocess.Popen(['free','-m'],stdout=subprocess.PIPE) 
		p2=subprocess.Popen(['grep','Me'],stdin=p1.stdout,stdout=subprocess.PIPE) 
		p1.stdout.close() 
		mem = p2.communicate()[0].split() 
		data[0]= str(int(mem[3])+int(mem[5]))    

		# data[1] Temperatura del CPU
		tempFile=open("/sys/class/thermal/thermal_zone0/temp")
		CPU_temp=tempFile.read()
		tempFile.close()
		data[1]=str(float(CPU_temp)/1000)

		# data[2] Porcentaje de utilizacion de la CPU
		p1=subprocess.Popen(['top','-b','-n','2'],stdout=subprocess.PIPE)
		p2=subprocess.Popen(['grep','Cpu(s)'],stdin=p1.stdout,stdout=subprocess.PIPE)
		p1.stdout.close()
		p3=subprocess.Popen(['sed',r's/.*, *\([0-9.]*\)%* id.*/\1/'],stdin=p2.stdout,stdout=subprocess.PIPE)
		p2.stdout.close()
		data[2]=str(100-float(p3.communicate()[0].split("\n")[1].strip()))

		# data[3] Tiempo que lleva encendido el RPi
		p1=subprocess.Popen(['top','-b','-n','1'],stdout=subprocess.PIPE)
		p2=subprocess.Popen(['grep','load'],stdin=p1.stdout,stdout=subprocess.PIPE)
		p1.stdout.close()
		p3=subprocess.Popen(['sed',r's/.* up *\([0-9.]*\)* day.*/\1/; t; s/.*/0/'],stdin=p2.stdout,stdout=subprocess.PIPE)
		p2.stdout.close()
		data[3]=str(p3.communicate()[0].strip())
 

		i2c=smbus.SMBus(1)
		# data[4] Modo de alimentacion de RPi alimentado por cable/bateria
		i2c_data=i2c.read_byte_data(0x69,0x00)
		i2c_data=i2c_data & ~(1<<7)
		if (i2c_data==1): data[4]='0'
		else: data[4]='1'

		# data[5] Nivel de carga de la bateria en voltios(V)
		i2c_data=i2c.read_word_data(0x69,0x08)
		i2c_data=format(i2c_data,"02x")
		data[5]=str((float(i2c_data)/100))

		# data[6] Nivel de carga de la bateria en porcentaje(%)
		i2c_data=i2c.read_word_data(0x69,0x08)
		i2c_data=float(format(i2c_data,"02x"))/100
		if i2c_data>4.2:  data[6]= '100'
		elif 3.4<=i2c_data<=4.2: data[6]= str((i2c_data-3.4)/0.8*100)
		else: data[6]= '0'

		# data[7] Nivel de voltaje del RPi(V)
		i2c_data=i2c.read_word_data(0x69,0x0a)
		i2c_data=format(i2c_data,"02x")
		data[7]= str(float(i2c_data)/100)

		# data[8] Temperatura de la bateria NTC1(C)
		i2c_data=i2c.read_byte_data(0x69,0x1b)
		data[8]= str(format(i2c_data,"02x"))

		# data[9] Temperatura TO92(C)
		i2c_data=i2c.read_byte_data(0x69,0x1c)
		data[9]=str(format(i2c_data,"02x"))

		# data[10] Estado del ventilador (ON/OFF)
		i2c_data=i2c.read_byte_data(0x6b,0x11)
		data[10]=str(i2c_data)

		# data[11] Velocidad del ventilador)(%)
		i2c_data=i2c.read_word_data(0x6b,0x12)
		data[11]=str(i2c_data)
		i2c.close()

		nodeid="EmonPi"
		apikey="c098d7fc84b0708560253f4d42a04f70"
		target="localhost/emoncms"

		url='http://'+target+'/input/post.json?json={'\
                'Mem_free:'+data[0]+\
		',CPU_temp:'+data[1]+\
		',CPU_usage:'+data[2]+\
		',Time_on:'+data[3]+\
		',Pwr_mode:'+data[4]+\
		',Bat_volt:'+data[5]+\
		',Bat_level:'+data[6]+\
		',RPi_volt:'+data[7]+\
		',Bat_temp:'+data[8]+\
		',To92_temp:'+data[9]+\
		',Fan_on:'+data[10]+\
		',Fan_vel:'+data[11]+\
		'}&node='+nodeid+'&apikey='+apikey

		c=pycurl.Curl()
		c.setopt(c.URL,url)
		devnull=open('/dev/null','w')
		c.setopt(c.WRITEFUNCTION,devnull.write)
		c.perform()
		c.close

	except:
		raise
