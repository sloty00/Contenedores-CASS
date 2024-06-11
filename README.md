# ASBUILD y Despliegues en Contenedores

Este repositorio contiene la documentación y los archivos de configuración YAML para diversos servicios implementados en contenedores por **José Vargas Oyarzun**. A continuación, se presenta una descripción de cada servicio y su configuración.

## Servicios Implementados

### Bind DNS
Bind DNS se configuró para permitir que los servicios internos sean accesibles desde fuera de la intranet. Esto facilita la gestión y acceso remoto a los recursos y servicios internos de la organización.

### Documize
Documize se utiliza como una base de conocimiento para la organización. Proporciona un espacio centralizado para almacenar, organizar y acceder a la información y documentación crítica.

### GLPI
GLPI se configuró como un sistema de Helpdesk y para el levantamiento en terreno de máquinas con notificaciones por correo electrónico. Se crearon dos ecosistemas: uno para CASS y otro para clientes. Cada caso de soporte se asigna a su correspondiente entidad/grupo cliente, y todos los datos se capturan desde el Active Directory (AD).

### Rocketchat
Rocketchat es una plataforma de comunicación en tiempo real, similar a Slack. Facilita la colaboración y la comunicación entre equipos mediante canales, mensajes directos y más.

### Rustdesk
Rustdesk es una solución de escritorio remoto de código abierto. Permite el acceso remoto y la asistencia técnica a los equipos, facilitando el soporte y la gestión remota de los dispositivos.

## Configuración y Despliegue

Los archivos de configuración `.yml` en este repositorio muestran cómo se han configurado estos servicios en contenedores. Cada archivo está documentado con detalles específicos sobre los parámetros de configuración y los pasos necesarios para su despliegue.

Las YAML presentadas son de su autoría y demuestran un profundo conocimiento y experiencia en el manejo de contenedores y la implementación de infraestructura como código.

He mostrado una notable habilidad para diseñar y configurar entornos de desarrollo y producción, asegurando la eficiencia y escalabilidad de las aplicaciones. Su enfoque meticuloso y detallado se refleja en la claridad y precisión de sus archivos .yml, los cuales facilitan el entendimiento y la replicación de los despliegues.

Además, su capacidad para documentar de manera efectiva sus procesos garantiza que otros desarrolladores puedan seguir sus pasos con facilidad, promoviendo buenas prácticas en el desarrollo y la implementación de aplicaciones en contenedores.
