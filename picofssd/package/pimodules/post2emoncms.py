#!/usr/bin/python
##################################################################################################################
#                                                                                                                #
#    Script para enviar datos del RPi y el hat UPS Pico HV3.0 al emoncms a traves metodo GET de HTML             #
#                                                                                                                #
# Date:     10/04/18                                                                                             #
# Author:   Juan Taba Gasha                                                                                      #
# Last rev: 15/11/18                                                                                             #
##################################################################################################################

import subprocess
import pycurl

def post_data_emoncms():

	try:
        	data=[0 for i in range(4)]
		# data[0] Cantidad de memoria libre y usada del sistema  (Memoria RAM disponible = RAM libre + buffer + cache)
		p1=subprocess.Popen(['free','-m'],stdout=subprocess.PIPE) 
		p2=subprocess.Popen(['grep','Me'],stdin=p1.stdout,stdout=subprocess.PIPE) 
		p1.stdout.close() 
		mem = p2.communicate()[0].split() 
		data[0]= str(int(mem[3])+int(mem[5])+int(mem[6]))   

		# data[1] Temperatura del CPU
		tempFile=open("/sys/class/thermal/thermal_zone0/temp")
		CPU_temp=tempFile.read()
		tempFile.close()
		data[1]=str(float(CPU_temp)/1000)

		# data[2] Porcentaje de utilizacion de la CPU
		p1=subprocess.Popen(['top','-b','-n','1'],stdout=subprocess.PIPE)
		p2=subprocess.Popen(['grep','Cpu(s)'],stdin=p1.stdout,stdout=subprocess.PIPE)
		p1.stdout.close()
		p3=subprocess.Popen(['sed',r's/.*, *\([0-9.]*\)%* id.*/\1/'],stdin=p2.stdout,stdout=subprocess.PIPE)
		p2.stdout.close()
		data[2]=str(100-float(p3.communicate()[0].strip()))

		# data[3] Tiempo que lleva encendido el RPi
		p1=subprocess.Popen(['top','-b','-n','1'],stdout=subprocess.PIPE)
		p2=subprocess.Popen(['grep','load'],stdin=p1.stdout,stdout=subprocess.PIPE)
		p1.stdout.close()
		p3=subprocess.Popen(['sed',r's/.* up *\([0-9.]*\)* day.*/\1/; t; s/.*/0/'],stdin=p2.stdout,stdout=subprocess.PIPE)
		p2.stdout.close()
		data[3]=str(p3.communicate()[0].strip())
 
		nodeid="EmonPi"
		apikey="c098d7fc84b0708560253f4d42a04f70"
		target="localhost/emoncms"

		url='http://'+target+'/input/post.json?json={'\
                'Mem_free:'+data[0]+\
		',CPU_temp:'+data[1]+\
		',CPU_usage:'+data[2]+\
		',Time_on:'+data[3]+\
		'}&node='+nodeid+'&apikey='+apikey

		c=pycurl.Curl()
		c.setopt(c.URL,url)
		devnull=open('/dev/null','w')
		c.setopt(c.WRITEFUNCTION,devnull.write)
		c.perform()
		c.close

	except:
		raise
