# diccionario_Xml

# Sistema de Almacenamiento y Consulta de Diccionario Multilingüe en XML

Este proyecto implementa un diccionario multilingüe utilizando XML como formato de almacenamiento, junto con consultas XQuery y una interfaz de usuario web para acceder a los datos.

## Contenido

1. [Descripción General](#descripción-general)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Instalación](#instalación)
4. [Uso](#uso)
5. [Características](#características)
6. [Desarrollo Técnico](#desarrollo-técnico)
7. [Ejemplos](#ejemplos)
8. [Contribución](#contribución)
9. [Licencia](#licencia)

## Descripción General

Este sistema permite almacenar y consultar definiciones de palabras en múltiples idiomas, junto con sus traducciones, definiciones, sinónimos, antónimos, información de uso y etimología. La base de datos está implementada en XML, con consultas mediante XQuery, y ofrece una interfaz web para facilitar su uso.

## Estructura del Proyecto

```
diccionario-multilingue/
│
├── schema/
│   └── dictionary_schema.xsd     # Esquema XML para validación
│
├── data/
│   └── dictionary.xml            # Base de datos XML principal
│
├── queries/
│   └── queries.xq                # Funciones XQuery predefinidas
│
├── web/
│   ├── index.html                # Interfaz de usuario principal
│   ├── css/
│   │   └── styles.css            # Estilos de la interfaz
│   └── js/
│       └── app.js                # Funcionalidad JavaScript
│
└── README.md                     # Este archivo
```

## Instalación

### Requisitos previos

- Servidor XML con soporte para XQuery (BaseX, eXist-db, etc.)
- Navegador web moderno
- Servidor web (opcional para desarrollo local)

### Instalación en Debian 12

#### 1. Instalar BaseX (Motor de base de datos XML)

```bash
# Actualizar los repositorios
sudo apt update

# Instalar Java (necesario para BaseX)
sudo apt install -y default-jre

# Descargar BaseX
wget https://files.basex.org/releases/10.6/BaseX106.zip

# Descomprimir
unzip BaseX106.zip

# Mover a una ubicación adecuada
sudo mv basex /opt/

# Crear enlaces simbólicos a los binarios
sudo ln -s /opt/basex/bin/basex /usr/local/bin/
sudo ln -s /opt/basex/bin/basexserver /usr/local/bin/
```

#### 2. Iniciar BaseX y cargar el diccionario

```bash
# Iniciar el servidor BaseX (opcional, solo si necesitas el servidor)
basexserver -S

# O usar directamente la línea de comandos para cargar los datos
basex -c "CREATE DB dictionary data/dictionary.xml"
```

#### 3. Configurar un servidor web (opcional - Apache)

```bash
# Instalar Apache
sudo apt install -y apache2

# Copiar archivos web a la carpeta de Apache
sudo cp -r web/* /var/www/html/

# Reiniciar Apache
sudo systemctl restart apache2
```

### Pasos de instalación alternativos

1. Clone este repositorio:
   ```
   git clone https://github.com/usuario/diccionario-multilingue.git
   cd diccionario-multilingue
   ```

2. Configure su servidor XML preferido para cargar el esquema y datos:
   ```
   # Ejemplo para eXist-db en Debian 12
   sudo apt install -y exist-db
   # Importar datos a través de la interfaz web de eXist (http://localhost:8080/exist)
   ```

3. Abra `web/index.html` en su navegador o despliéguela en un servidor web.

## Uso

### Interfaz Web

La interfaz web ofrece tres modos principales:

1. **Búsqueda simple**: Busca palabras específicas en un idioma seleccionado.
2. **Búsqueda avanzada**: Permite buscar por sinónimos, ejemplos de uso o etimología.
3. **Navegación**: Explora el diccionario por idioma y letra inicial.

Para usar la interfaz:

1. Abra `index.html` en su navegador
2. Seleccione el tipo de búsqueda deseado
3. Ingrese el término de búsqueda y seleccione el idioma
4. Explore los resultados o utilice las opciones de exportación

### Consultas XQuery

El sistema incluye cinco funciones XQuery principales:

1. `getTranslations()`: Obtiene traducciones para una palabra en un idioma específico
2. `searchBySynonym()`: Busca palabras relacionadas con un sinónimo
3. `searchByExample()`: Encuentra palabras usadas en contextos específicos
4. `exportWordToJSON()`: Exporta una entrada completa a formato JSON
5. `findRelatedByEtymology()`: Encuentra palabras con orígenes etimológicos relacionados

## Características

- **Multilingüe**: Soporte completo para múltiples idiomas
- **Información completa**: Almacena no solo traducciones sino también definiciones, ejemplos, usos y etimología
- **Búsqueda flexible**: Múltiples métodos de búsqueda avanzada
- **Exportación**: Exportación de datos en XML y JSON
- **Interfaz intuitiva**: Diseño responsivo y fácil de usar
- **Escalable**: La estructura XML permite expansión sin alterar el esquema

## Desarrollo Técnico

### Esquema XML

El esquema XML (`dictionary_schema.xsd`) define la estructura de los datos:

- Entradas de palabras con identificadores únicos
- Soporte para fonética, traducciones, definiciones y ejemplos
- Campos opcionales para sinónimos, antónimos, información de uso y etimología

### Consultas XQuery

Las consultas XQuery (`queries.xq`) implementan funcionalidad para:

- Búsqueda directa por palabra
- Búsqueda indirecta por atributos (sinónimos, ejemplos, etc.)
- Generación de resultados en formatos XML y JSON

### Interfaz Web

La interfaz web combina HTML, CSS y JavaScript para ofrecer:

- Diseño responsivo con Flexbox
- Organización por pestañas para diferentes tipos de búsqueda
- Representación visual clara de los resultados
- Opciones de exportación integradas

## Ejemplos

### Ejemplo de Entrada XML

```xml
<entry id="en_1">
  <word>book</word>
  <phonetic>bʊk</phonetic>
  <language>en</language>
  <translations>
    <translation>
      <language>es</language>
      <word>libro</word>
      <phonetic>ˈli.βɾo</phonetic>
    </translation>
    <!-- Más traducciones... -->
  </translations>
  <definitions>
    <definition>
      <text>A written or printed work consisting of pages glued or sewn together along one side and bound in covers.</text>
      <partOfSpeech>noun</partOfSpeech>
      <examples>
        <example>I'm reading a good book at the moment.</example>
        <!-- Más ejemplos... -->
      </examples>
    </definition>
    <!-- Más definiciones... -->
  </definitions>
  <!-- Más información... -->
</entry>
```

### Ejemplo de Consulta XQuery

```xquery
(: Buscar palabra en español y obtener sus traducciones :)
local:getTranslations("libro", "es")
```

### Resultado JSON de Ejemplo

```json
{
  "word": "libro",
  "language": "es",
  "phonetic": "ˈli.βɾo",
  "translations": [
    {
      "language": "en",
      "word": "book",
      "phonetic": "bʊk"
    },
    {
      "language": "fr",
      "word": "livre",
      "phonetic": "livʁ"
    }
  ],
  "definitions": [
    {
      "text": "Conjunto de hojas de papel, pergamino, vitela, etc., manuscritas o impresas, unidas por uno de sus lados y normalmente encuadernadas.",
      "partOfSpeech": "nombre",
      "examples": [
        "Estoy leyendo un buen libro actualmente.",
        "Ella escribió un libro sobre arte moderno."
      ]
    }
  ],
  "synonyms": ["volumen", "obra", "texto"]
}
```

## Contribución

Las contribuciones son bienvenidas. Para contribuir:

1. Haga un fork del proyecto
2. Cree una rama para su característica (`git checkout -b feature/nueva-caracteristica`)
3. Haga sus cambios y commit (`git commit -am 'Añade nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Cree un Pull Request


## Licencia

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo LICENSE para más detalles.
