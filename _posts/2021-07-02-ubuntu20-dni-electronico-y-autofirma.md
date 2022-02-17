---
title: "DNI electrónico y autofirma en 2020: cómo NO perder 2 horas para firmar una solicitud"
categories: [Management]
tags: [dnie,dni electrónico,autofirma,ubuntu 20,java]
excerpt: "Cómo usar el DNIe desde Ubuntu para firmar electrónicamente trámites en línea. En este caso se firmaron las solicitudes para optar a las certificaciones de la AESA para ser piloto de drones."
---

Estas últimas semanas, junto con otros compañeros y compañeras, hemos empezado a prepararnos para obtener la formación necesaria para pilotar drones para nuestros proyectos. El primer paso es realizar del CURSO DE FORMACIÓN Y EXAMEN DE PILOTO A DISTANCIA EN CATEGORÍA ABIERTA, SUBCATEGORÍAS A1/A3. Para saber más podéis revisar la información sobre la [Formación de pilotos UAS/drones en categoría ‘abierta’](https://www.seguridadaerea.gob.es/es/ambitos/drones/formacion-pilotos-a-distancia-uas-drones/formacion-de-pilotos-uas-drones-en-categoria-rabiertar). Hay mucha gente hablando de estas cosas y no hace falta que me ponga pesado. Recomiendo el canal de YouTube de [Rafa Ocón](https://www.youtube.com/channel/UCZ-5HNenHNT13aTf7KD0ROg) para oir hablar a un profesional sobre la actualidad del mundo de los drones.

Lo primero es registrarse en la página web de la AESA para realizar una [Nueva solicitud](https://sede.seguridadaerea.gob.es/oficina/tramites/acceso.do?id=106). Una vez firmada y enviada la solicitud se tarda un tiempo en recibir acceso al la plataforma Moodle de la AESA en la que se realiza este primer curso (A1/A3) y el examen para obtener el certificado. El trámite resulta sencillo a no ser que no tengas un certificado electrónico actualizado y todo el software necesario para firmar electrónicamente. En fin, esto no será problemático para la mayoría pero desde Linux todo cuesta un poquito más :)

Bueno, también se dice que se puede enviar por correo postal y esperar la respuesta...


## Firmar la solicitud

El DNIe va cambiando de versiones y resulta que yo tenía uno (de 3 años de antiguedad) con el que ya no se me permitia actualizar los certificados electrónicos. Una vez con el DNIe actualizado y teniendo un **lector de tarjetas inteligentes compatible con Linux**. El que yo tengo ya no está disponible pero supongo que habrá nuevos modelos ([Lector de tarjetas descatalogado](https://www.amazon.es/dp/B01JS2HSAA?psc=1&ref=ppx_pop_dt_b_product_details)).


Lo primero sería leerse las instrucciones e instalar el software que facilitan en el Portal del DNI electrónico del Cuerpo Nacional de Policía (Cómo utilizar el DNI>>Qué hace falta para utilizarlo). En Ubuntu 20.04 hice lo siguiente:

```bash
sudo apt install pcscd pcsc-tools pinentry-gtk2 libccid

#https://www.dnielectronico.es/PortalDNIe/PRF1_Cons02.action?pag=REF_3000
wget https://www.dnielectronico.es/descargas/distribuciones_linux/Ubuntu_libpkcs11-dnie_1.5.3_amd64.deb
sudo dpkg -i libpkcs11-dnie_x.x.x_i386.deb
```

## Autofirma

A continuación hace falta software para firmar PDFs u otros documentos. Nuevamente, esto és más sencillo en Windows con el Adobe Acrobat PDF Pro. En Ubuntu se puede instalar [Autofirma](https://firmaelectronica.gob.es/Home/Descargas.html).

Lo primero és que hay que instalar la versión de Java necesaria para que funcione, unas librerias y después ya se puede instalar AutoFirma:

```bash
sudo apt install openjdk-8-jre
sudo apt install libnss3-tools
mkdir temporal_autofirma
cd temporal_autofirma
# Ir a https://firmaelectronica.gob.es/Home/Descargas.html a comprobar si `1.6.5` es la última versión
wget https://estaticos.redsara.es/comunes/autofirma/1/6/5/AutoFirma_Linux.zip
unzip AutoFirma_Linux.zip
sudo dpkg -i *.deb
cd ..
rm -rf temporal_autofirma
```


Autofirma se puede utilizar desde el escritorio para firmar un PDF normal o también se puede utilizar desde el navegador, lo que "permite la firma en páginas de Administración Electrónica cuando se requiere la firma en un procedimiento administrativo". No obstante, al intentar firmar la petición a la AESA y cerrar mi solicitud, le daba a utilizar AutoFirma pero después no sucedía nada :-S

Una hora sin poder avanzar, desinstalar todo y volver a empezar, pero ***AutoFirma no puede ser desinstalado porque estaba en uso... :-?*** Al repasar [este post](https://www.ubuntuleon.com/2020/12/instala-autofirma-165-para-tramites-en.html) de UbuntuLeon.com, me di cuenta de que no le había prestado atención a la versión de Java que estaba utilizando. Hacía falta utilizar Java8!!!!


Así que se puede configurar haciendo
```bash
sudo update-alternatives --config java
```
y seleccionar la versión 8 de java, si és que se había instalado en los pasos previos.

Al final todo funciona correctamente y pude realizar mi solicitud. Desde entonces he utilizado más amenudo la firma con el DNIe cuando estoy en casa. No obstante, me sigue sorprendiendo que una aplicación de la que tanto dependemos no esté más actualizada con las últimas dependéncias y/o haya un cierto versionado para las configuraciones habituales.


## Una reflexión sobre todo esto
Estamos ya metidos en pleno siglo veintiuno pero parece que hay cosas que no cambian tan rápido como esperabamos hace unos años. Los trámites con la administración són cada vez más sencillos pero hace falta una reflexión. ¿Cuanto tiempo falta hasta que la administración apueste de verdad por el software libre y abierto?---y nos liberemos de tener que pagar el doble (primero nuestros impuestos y después el software para poder realizar nuestros trámites). Sí, aunque no lo pensemos habitualmente y muchas veces los tengamos ya instalados, Windows y los programas de Adobe son de pago.

Desde que me decidí a utilizar principalmente software libre, puedo clasificar mis dias entre:

1. Aquellos en los que me siento orgulloso y feliz por ser más independiente, cuando todo resulta más fácil (80% del tiempo).
2. Los dias en que sufro para hacer algo **pero aprendo** bastante por el camino (18% del tiempo).
3. Otros en que lamento el exceso de tiempo que *pierdo* haciendo cosas que son más sencillas utilizando software propietario (2% del tiempo).

 Hoy sería un dia del tercer tipo pero, afortunadamente, mi fe en el software libre es fuerte.

## Referencias

- [Firma digital en Ubuntu](https://atareao.es/como/firma-digital-en-ubuntu/)
- [Cómo utilizar el DNIe](https://www.dnielectronico.es/PortalDNIe/PRF1_Cons02.action?pag=REF_300&id_menu=15)
- [AutoFirma (04/02/2022)](https://firmaelectronica.gob.es/Home/Descargas.html)
- [INSTALA AUTOFIRMA 1.6.5 (PARA TRÁMITES EN ESPAÑA) EN UBUNTU 20.04](https://www.ubuntuleon.com/2020/12/instala-autofirma-165-para-tramites-en.html)

