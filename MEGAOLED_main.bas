'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'


$regfile = "m2560def.dat"
$crystal = 16000000
$baud = 9600


$hwstack = 80
$swstack = 80
$framesize = 80


'Declaracion de constantes



'Configuracion de entradas/salidas
Led1 Alias Portb.7                                          'LED ROJO
Config Led1 = Output


'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
Enable Timer0
Start Timer0

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc

$lib "i2c_twi.lbx"
Config Sda = Portd.1
Config Scl = Portd.0
Config I2cdelay = 5
Config Twi = 400000

Dim Lcd_auto As Byte


$lib "glcdSSD1306-I2C.lib"
'Lcd_auto = 1
'$lib "glcdSSD1306-I2C-BUF.lib"
Config Graphlcd = Custom , Cols = 128 , Rows = 64 , Lcdname = "SSD1306"
i2cinit

Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "MEGAOLED_archivos.bas"



'Programa principal

Call Inivar()

Print #1 , "OLED"
Cls
Showpic 0 , 0 , Pic
Wait 1
Cls
Setfont Font8x8tt
Lcdat 1 , 1 , "**  MEGA 2020 **"
Lcdat 3 , 1 , Version(1)
Lcdat 5 , 1 , Version(2)
Lcdat 7 , 1 , Version(3)

setfont font12x16
Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If
   if newsec=1 then
      reset newsec
      cls
      lcdat 1,1,tmpb
      incr tmpb
   endif

Loop
