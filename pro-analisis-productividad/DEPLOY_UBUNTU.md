# Guía de Despliegue en Ubuntu Server con Docker

Esta guía explica los pasos para levantar el proyecto **Arku-Pro** en una máquina virtual con **Ubuntu Server** utilizando Docker y Docker Compose.

---

## 1. Instalar Docker y Docker Compose en Ubuntu Server

Si aún no tienes Docker instalado en tu máquina virtual de Ubuntu Server, ejecuta los siguientes comandos en la terminal de Ubuntu:

```bash
# Actualizar repositorios del sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
sudo apt install -y ca-certificates curl gnupg lsb-release git

# Agregar la clave GPG oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Configurar el repositorio de Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker Engine y Docker Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permitir usar docker sin sudo (opcional pero recomendado)
sudo usermod -aG docker $USER
newgrp docker
```

Verifica la instalación:
```bash
docker --version
docker compose version
```

---

## 2. Clonar o subir el proyecto a Ubuntu Server

En tu Ubuntu Server, puedes clonar el repositorio Git (o transferirlo vía SCP / SFTP):

```bash
git clone <URL_DE_TU_REPOSITORIO>
cd arku_prueba/Arku-Pro/pro-analisis-productividad
```

---

## 3. Configurar las variables de entorno (`.env`)

Copia el archivo de plantilla para Docker:

```bash
cp .env.docker.example .env
```

Si necesitas cambiar el puerto o usar MySQL en lugar de SQLite, edita el archivo:
```bash
nano .env
```
*(Guarda con `Ctrl + O`, `Enter` y sal con `Ctrl + X`)*.

---

## 4. Construir y levantar los contenedores

Ejecuta el siguiente comando para compilar las imágenes e iniciar los contenedores en segundo plano:

```bash
docker compose up -d --build
```

Revisa que los contenedores estén corriendo (`Up`):
```bash
docker compose ps
```

---

## 5. Ejecutar migraciones y datos iniciales (Seeders)

Una vez que los contenedores estén activos, ejecuta dentro del contenedor `arku_app`:

```bash
# Ejecutar migraciones
docker compose exec app php artisan migrate --force

# Ejecutar seeders iniciales
docker compose exec app php artisan db:seed --force

# Optimizar caché de Laravel para producción
docker compose exec app php artisan optimize
```

---

## 6. Acceder a la aplicación

Abre tu navegador desde cualquier equipo en la misma red que tu máquina virtual y entra a la IP de Ubuntu Server:

```text
http://<IP_DE_TU_UBUNTU_SERVER>:8000
```
*(Puedes obtener la IP de Ubuntu Server ejecutando: `ip a` o `hostname -I`)*.

### Credenciales de prueba:
* **Email:** `test@example.com`
* **Contraseña:** `password`

---

## Comandos útiles de mantenimiento

* **Ver logs en tiempo real:**
  ```bash
  docker compose logs -f
  ```
* **Entrar a la terminal del contenedor Laravel:**
  ```bash
  docker compose exec app bash
  ```
* **Reiniciar contenedores:**
  ```bash
  docker compose restart
  ```
* **Detener contenedores:**
  ```bash
  docker compose down
  ```

