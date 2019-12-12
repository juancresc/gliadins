
### set up dependencies
```
mkdir sw

#download and set-up SPAdes
wget http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz -P sw/
tar xvzf sw/SPAdes-3.13.0-Linux.tar.gz -C sw
export PATH=$PATH:$PWD/sw/SPAdes-3.13.0-Linux/bin


#download and set-up bigdatascript
wget https://github.com/pcingola/BigDataScript/blob/master/distro/bds_Linux.tgz -P sw/
tar xvzf sw/bds_Linux.tgz?raw=true -C sw
export PATH=$PATH:$PWD/sw/.bds

#download and set-up cutadapt
wget https://github.com/marcelm/cutadapt/archive/v2.7.tar.gz -P sw/
tar xvzf sw/v2.7.tar.gz -C sw
export PATH=$PATH:$PWD/sw/cutadapt-2.7

#download and set-up fastqc
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip -P sw/
unzip sw/fastqc_v0.11.8.zip -d sw/
export PATH=$PATH:$PWD/sw/FastQC
chmod +x sw/FastQC/fastqc


#download and set-up trim galore
wget https://github.com/FelixKrueger/TrimGalore/archive/0.6.5.tar.gz -P sw/
tar xvzf sw/0.6.5.tar.gz -C sw
export PATH=$PATH:$PWD/sw/TrimGalore-0.6.5/

```

### Information about sequences

Hola Juan!
Los/el amplicon(es) se secuenciaron con tecnología Illumina, en concreto con un equipo MiSeq, en formato pair end (PE) con lecturas de 150 pb de largo. Eso quiere decir que hay una lectura "forward" y una lectura "reverse", que según el tamaño del amplicón se van a solapar en el centro o no (o sea, si los amplicones son de 200 bases, 150 bases están en las lecturas "forward", 150 bases están en las lecturas "reverse" y hay un solapamiento de 100 bases leidas por las dos orientaciones de las lecturas; si los amplicones son de 300 bases no hay solapamiento, porque cada lectura desde cada extremo llega hasta 150 bases). Estas lecturas son las que les interesan a ustedes porque dan información directa de la secuencia y corresponden a los archivos R1 y R2 del adjunto que les mandó Andrea. Entretanto, las lecturas I2 corresponden a los índices utilizados y sólo sirven para el reconocimiento de la muestra. En la mayoría de los casos no es necesario este archivo, ya que la información de interés está en los otros dos.
Yo realizo el análisis bioinformático con linux, y constan de tres pasos básicos: chequeo de calidad, mapeo a una referencia e identificación de variantes respecto de la referencia. Para el primer paso utilizo el programa FastQC para un chequeo inicial de calidad de las secuencias. No miré las secuencias de ustedes así que no tengo información al respecto. Conviene hacer en este paso si fuera necesario un recorte de bases de baja calidad o de adaptadores. Para eso uso el programa Trimmomatic, pero hay otros programas disponibles también. Los adaptadores utilizados en el caso de ustedes son: 
 
R94: CAAGCAGAAGACGGCATACGAGATTATCGGGAGTGACTGGAGTTCAGACGTG
F6: AATGATACGGCGACCACCGAGATCTACACACTGCATAACACTCTTTCCCTACACGA
Al aplicar el programa Trimmomatic se pueden eliminar adaptadores que eventualmente hayan sido secuenciados junto con las lecturas de la región de interés, aunque no siempre es el caso. Yo lo metería por las dudas, sobre todo si no tienen mucha experiencia en visualización de calidad con FastQC.
 
En la etapa de mapeo uso programas como BWA-mem o Bowtie2. El archivo de referencia en el caso de ustedes debería ser el genoma de trigo, ya que buscan una familia multigénica. De esa forma se garantizan mapear todo lo que haya sido amplificado en las distintas regiones del genoma posibles.
Después del mapeo pueden visualizar los resultados con programas como Tablet, lo que les va a dar una aproximación más amigable de las diferentes cosas que mapearon.
Finalmente queda la identificación de variantes, de interesarles, lo que igual en principio entiendo que no es lo que más les interesa, pero que sería interesante evaluar a la larga. Para eso también existen diferentes programas como GATK, VarScan y otros.
Imagino que tendrán algun contacto que les pueda dar alguna asistencia para el análisis bioinformático si es que todavía no están familiarizados. Este mail sirve como primera aproximación y un ejemplo en este caso de cómo suelo manejar yo este tipo de datos, pero por supuesto existen otras posibilidades.
Cualquier cosa estamos en contacto.
Saludos,
Mónica
