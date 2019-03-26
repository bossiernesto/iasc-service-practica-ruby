# Instalacion

Para poner en marcha este pequeño servicio, solo hay que tener instalado

- Python 3
- Venv (Python 3 virtual env)

Primero hay que crear un nuevo entorno virtual para que se instalen las dependencias y correr este servicio

```
python3 -m venv venv
```

una vez creado hay que activar el mismo

```
source ./venv/bin/activate
```

esto permite ahora que el pip3 que se use es el que apunta en el entorno virtual, hay que setear dos variables que flask, el framework web, toma como parametro de las variables de entorno

```
export FLASK_ENV=development
export FLASK_APP=app.py
```

despues solo hay que instalar las dependencias a traves del archivo de requiremets.txt

```
pip3 install -r requiremets.txt
```

Finalmente se puede correr 

```bash
flask run
```

Esto levantara el servidor en *localhost:5000*
