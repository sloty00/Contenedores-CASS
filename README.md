# ASBUILD y Despliegues en Contenedores

Este repositorio contiene la documentación y los archivos de configuración YAML para diversos servicios implementados en contenedores por **José Vargas Oyarzun**. A continuación, se presenta una descripción de cada servicio y su configuración.

## Servicios Implementados

### Bind DNS
Bind DNS se configuró para permitir que los servicios internos sean accesibles desde fuera de la intranet. Esto facilita la gestión y acceso remoto a los recursos y servicios internos de la organización. (Produccion).
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/ae922666-5a06-4831-bfca-7cd9d819c113)
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/1a484022-0147-4b5c-bd6d-d2856196d68e)

### Documize
Documize se utiliza como una base de conocimiento para la organización. Proporciona un espacio centralizado para almacenar, organizar y acceder a la información y documentación crítica. (Interno Produccion).
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/2bfe7363-5c69-414e-b85b-9b0c88772203)
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/48212cef-3796-449f-b71a-3d3e59d40cc7)

### GLPI
GLPI se configuró como un sistema de Helpdesk y para el levantamiento en terreno de máquinas con notificaciones por correo electrónico. Se crearon dos ecosistemas: uno para CASS y otro para clientes. Cada caso de soporte se asigna a su correspondiente entidad/grupo cliente, y todos los datos se capturan desde el Active Directory (AD). (Produccion).
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/2820278b-b7c5-4909-8388-06d5b2e84c27)

### Rocketchat
Rocketchat es una plataforma de comunicación en tiempo real, similar a Slack. Facilita la colaboración y la comunicación entre equipos mediante canales, mensajes directos y más. (Porduccion).
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/20caed76-1d1c-410e-ae53-c45b972eff85)

### Rustdesk
Rustdesk es una solución de escritorio remoto de código abierto. Permite el acceso remoto y la asistencia técnica a los equipos, facilitando el soporte y la gestión remota de los dispositivos. (Produccion).
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/4539b3b5-5d42-4751-b47e-5966836aaa48)
![image](https://github.com/sloty00/Contenedores-CASS/assets/22121541/9ee02bff-6b6b-49ce-be15-2e53257819b9)

### Nagios Monitoring System
Esteste proyecto contiene la configuración y los scripts necesarios para implementar un sistema de monitoreo utilizando Nagios. A continuación, se detallan las funcionalidades y la arquitectura del sistema.

#### Funcionalidades

1. **Notificaciones**:
   - **Correo electrónico**: Notificaciones enviadas a través de email para alertas críticas y advertencias.
   - **Telegram**: Integración con Telegram para enviar notificaciones instantáneas a través de un bot.

2. **Gráficos y Visualización**:
   - **PNP4Nagios**: Implementación de PNP4Nagios para generar gráficos detallados y visualizar el rendimiento histórico de los servicios monitoreados.

#### Arquitectura por Capas

El sistema de monitoreo está estructurado por capas para organizar los diferentes tipos de dispositivos y sistemas que se están monitoreando:

1. **Linux**: Monitoreo de servidores y servicios Linux utilizando SNMP, NRPE y agentes específicos.
2. **Windows**: Monitoreo de servidores y servicios Windows utilizando NSClient++ (NSCP) y otros protocolos de monitoreo.
3. **Dispositivos**: Monitoreo de dispositivos de red y otros equipos utilizando SNMP.
4. **Firewall**: Monitoreo de firewalls para asegurar la integridad y seguridad de la red.
5. **Switch**: Monitoreo de switches para asegurar la conectividad y el rendimiento de la red.
6. **Router**: Monitoreo de routers para asegurar la disponibilidad y el rendimiento de las rutas de red.

#### Protocolos de Monitoreo

El sistema utiliza varios protocolos para recopilar datos de los dispositivos y servicios monitoreados:

- **SNMP (Simple Network Management Protocol)**: Utilizado para monitorear dispositivos de red, servidores y otros equipos.
- **NRPE (Nagios Remote Plugin Executor)**: Utilizado para ejecutar plugins de Nagios en servidores Linux remotos.
- **NSClient++ (NSCP)**: Utilizado para monitorear servidores Windows.

#### Configuración

Para configurar el sistema de monitoreo, sigue estos pasos:

1. **Instalación de Nagios**: Instalar Nagios Core en el servidor de monitoreo.
2. **Configuración de Notificaciones**: Configurar las notificaciones por correo electrónico y Telegram en los archivos de configuración de Nagios.
3. **Implementación de PNP4Nagios**: Instalar y configurar PNP4Nagios para la generación de gráficos.
4. **Configuración de SNMP, NRPE y NSCP**: Configurar los agentes y servicios necesarios en los dispositivos y servidores a monitorear.



## Configuración y Despliegue

Los archivos de configuración `.yml` en este repositorio muestran cómo se han configurado estos servicios en contenedores. Cada archivo está documentado con detalles específicos sobre los parámetros de configuración y los pasos necesarios para su despliegue.

Las YAML configuradas son de mi ejecutoria y demuestran un profundo conocimiento y experiencia en el manejo de contenedores y la implementación de infraestructura como código.

He mostrado una notable habilidad para diseñar y configurar entornos de desarrollo y producción, asegurando la eficiencia y escalabilidad de las aplicaciones. Su enfoque meticuloso y detallado se refleja en la claridad y precisión de sus archivos .yml, los cuales facilitan el entendimiento y la replicación de los despliegues.

Además, su capacidad para documentar de manera efectiva sus procesos garantiza que otros desarrolladores puedan seguir sus pasos con facilidad, promoviendo buenas prácticas en el desarrollo y la implementación de aplicaciones en contenedores.
