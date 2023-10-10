# coding: utf-8

#numeros aleatorios
def randgauss rr
  theta = 2 * Math::PI * rr.rand #generacion uniforme
  rho = Math.sqrt(-2*Math.log(1 - rr.rand))
  x = rho*Math.cos(theta) #Un valor aleatorio x
  y = rho*Math.sin(theta) #Un valor aleatorio y
  #puts "Salida 1:#{x}, salida 2: #{y}"
  return x, y
end

#energia critica
def ecrit zm
  enec= 800/(zm + 1.2) #energia critica en MeV
  return enec
end

#longitud de radiacion

def longr am,zm,dm
  lor = dm*716.4*am/(zm*(zm+1)*Math.log(287/Math.sqrt(zm))) #cm
  par = (9.0/7.0)*lor
  return lor
end

#radio de Moliere
def rmo am,zm,dm
  rm = longr(am,zm,dm)*21.2/ecrit(zm) #en las unidades de longr
  return rm
end

def mayorz z1,z2 #elige mayor entre dos numeros
  if z1 >= z2
    return z1
  else
    return z2
  end
end

def menorz z1,z2 #elige menor entre dos numeros
  if z1 <= z2
    return z1
  else
    return z2
  end
end

#Tabla de medios
def med medio
  zmedfe=26 #Z del hierro
  amedfe=56 #A del hierro
  denfe=7.874 #gr/cm^3 densidad Fe

  zmedcu=29 #Z del cobre
  amedcu=63 #A del cobre
  dencu=8.96 #gr/cm^3 densidad Cu

  zmedn= 7 #Z del nitrogeno
  amedn= 14 #A del nitrogeno
  denn= 0.0012506 #gr/cm^3 densidad N

  if medio == "fe"
    return zmedfe,amedfe,denfe
  elsif medio == "cu"
    return zmedcu,amedcu,dencu
  elsif medio == "n"
    return zmedn,amedn,denn
  else
    return zmedfe,amedfe,denfe #material default
  end
end


#------#
# main #
#------#

rr=Random.new #generamos la variable aleatoria

#elegir fe,cu,n
zm,am,dm = med("fe")


epart=10e3 #MeV energía del electron >>30MeV
alt=0  #la profundidad recorrida
ee=epart  #energía inicial
x0 = longr(zm,am,dm) #longitud de radiacion
rad = rmo(am,zm,dm) #radio de Moliere
while ee > ecrit(zm)
  r1,r2 = randgauss(rr)
  rho1 = r1+ x0
  tet1 = 2*Math::PI*rr.rand
  phi1 = Math.tan(rad/rho1)*rr.rand
  rho2 = r2+x0
  tet2 = 2*Math::PI*rr.rand
  phi2 = Math.tan(rad/rho2)*rr.rand
  x1= rho1*Math.cos(tet1)*Math.sin(phi1)
  y1= rho1*Math.sin(tet1)*Math.sin(phi1)
  z1= rho1*Math.cos(phi1)
  x2= rho2*Math.cos(tet2)*Math.sin(phi2)
  y2= rho2*Math.sin(tet2)*Math.sin(phi2)
  z2= rho2*Math.cos(phi2)
  alt+=mayorz(z1,z2)
  ee=ee.to_f/2
  puts "#{ee} cords (#{x1},#{y1},#{z1}) (#{x2},#{y2},#{z2})"
end 
puts"Profundidad= #{alt} cm., E_c = #{ecrit(zm)}"