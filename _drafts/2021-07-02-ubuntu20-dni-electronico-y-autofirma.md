---
title: "DNI electrónico y autofirma en 2020: cómo no perder 2 horas para firmar una solicitud"
categories: [Management]
tags: [dnie,dni electrónico,autofirma,ubuntu 20,java]
---

# Inscripción a la formación de pilotos de drones de la AESA

Estas últimas semanas, junto con otros compañeros y compañeras, hemos empezado a prepararnos para obtener la formación necesaria para pilotar drones para nuestros proyectos. El primer paso es realizar del CURSO DE FORMACIÓN Y EXAMEN DE PILOTO A DISTANCIA EN CATEGORÍA ABIERTA, SUBCATEGORÍAS A1/A3. Para saber más podéis revisar la información sobre la [Formación de pilotos UAS/drones en categoría ‘abierta’](https://www.seguridadaerea.gob.es/es/ambitos/drones/formacion-pilotos-a-distancia-uas-drones/formacion-de-pilotos-uas-drones-en-categoria-rabiertar). Hay mucha gente hablando de estas cosas y no hace falta que me ponga pesado. Recomiendo el canal de YouTube de ... para oir hablar a un profesional sobre la actualidad del mundo de los drones.

Lo primero es registrarse en la página web de la AESA para realizar una [Nueva solicitud](https://sede.seguridadaerea.gob.es/oficina/tramites/acceso.do?id=106). Una vez firmada y enviada la solicitud se tarda un tiempo en recibir acceso al la plataforma Moodle de la AESA en la que se realiza este primer curso (A1/A3) y el examen para obtener el certificado. El trámite resulta sencill a no 

# Firmar la solicitud

DNIe + Lector

Cl@ve



## Autofirma

Instalar la versión de Java necesaria, librerias y después ya se puede instalar AutoFirma:

```bash
sudo apt install openjdk-8-jre
sudo apt install libnss3-tools
mkdir temporal_autofirma
cd temporal_autofirma
wget http://estaticos.redsara.es/comunes/AutoFirma_Linux.zip
unzip AutoFirma_Linux.zip
sudo dpkg -i *.deb
cd ..
rm -rf temporal_autofirma
```

Al intentar firmar la petición y cerrar mi solicitud, le daba a utilizar AutoFirma pero después no sucedía nada.

Una hora sin darme cuenta... desinstalar todo y volver a empezar, pero AutoFirma no puede ser desinstalado porque està en uso...


[este post](https://www.ubuntuleon.com/2020/12/instala-autofirma-165-para-tramites-en.html)

Java8!!!!



```bash
sudo update-alternatives --config java
```

y seleccionar la versión 8 de java. :-S

Al final todo funciona correctamente y pude realizar mi solicitud. No obstante, me sigue sorprendiendo que una aplicación de la que tanto dependemos no esté más actualizada con las últimas dependéncias y/o haya un cierto versionado para las configuraciones habituales.



# Una reflexión sobre todo esto
Estamos ya metidos en el siglo veintiuno pero parece que hay cosas que no cambian tan rápido como esperabamos hace unos años. Los trámites con la administración són cada vez más sencillos pero hace falta una reflexión...

¿Cuanto tiempo falta hasta que la administración apueste de verdad por el software libre y abierto?---y nos liberemos de tener que pagar el doble (primero nuestros impuestos y después el software para poder realizar nuestros trámites).

Desde que me decidí a utilizar principalmente software libre, puedo clasificar mis dias entre:

1. Aquellos en los que me siento orgulloso y feliz por ser más independiente, cuando todo resulta más fácil (80% del tiempo).
2. Los dias en que sufro para hacer algo **pero aprendo** bastante por el camino (18% del tiempo).
3. Otros en que lamento el exceso de tiempo que *pierdo* haciendo cosas que son más sencillas utilizando software propietario (2% del tiempo).

Afortunadamente, mi fe en el software libre es muy fuerte.

# Referencias

[Firma digital en Ubuntu](https://atareao.es/como/firma-digital-en-ubuntu/)
