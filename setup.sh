# Necesitas tener Firefox instalado. Y crear un entorno virtual antes de empezar
# Ejecutar en la carpeta del proyecto los siguientes comandos:
# python -m venv .env
# source .env/bin/activate

# Vas a necesitar las siguientes utilidades, puedes instalarlas con brew: 
# En MacOS: brew install yq hugo


echo "Iniciando Setup"

# Install dependendecies
pip install --no-build-isolation --force-reinstall \
    "boto3>=1.28.57" \
    "awscli>=1.29.57" \
    "botocore>=1.31.57" \
    "ipywidgets>=8.1.2"

pip install selenium webdriver_manager langchain_core langchain_community Pillow


# Nueva URL base
nueva_url_base="https://demo.com"
# Nueva ruta para favicon_image
nueva_ruta_favicon="/uploads/illustrations/demo/logo.png"
# Nueva frase para logo_subtitle
nueva_frase="AWS Gen AI"
#Nueva frase para el titulo
nuevo_titulo="Demo Day BCN"
#Nueva frase para la descripcion
nueva_descripcion="Demo Day BCN"


rm -rf hugobricks

git clone https://github.com/jhvanderschee/hugobricks

cd hugobricks

echo "Eliminando ficheros innecesarios"

rm -v README.md
rm -v hugobricks.jpg
rm -v features_index.md
rm -v static/google50d887eee3ca04cf.html

rm -rfv .git
rm -v .gitignore
rm -rv content/en/bricks
rm -rv content/en/docs
rm -rv content/en/posts
rm -rv content/en/products
rm -v content/en/about.md
rm -v content/en/contact.md
rm -v content/en/elements.md
rm -v content/en/faqs.md
rm -v content/en/team.md
rm -v content/en/basic.md
rm -v content/en/basic2.md
rm -v content/en/bgimage.md
rm -v content/en/bgimage2.md
rm -v content/en/bgimage3.md
rm -v content/en/faq.md

rm -v data/en/newsletterform.yaml
rm -v data/en/openinghours.yaml
rm -v data/en/people.yaml
rm -v data/en/faqs.yaml
rm -v data/en/features.yaml
rm -v data/en/reviews.yaml

echo "Configuración config."

archivo_config="config.yaml"

# Cambiar el valor de baseURL
sed -i '' "s|baseURL: .*|baseURL: $nueva_url_base|" "$archivo_config"

# Eliminar el nodo 'nl' y su contenido
sed -i '' '/nl:/,/^$/d' "$archivo_config"

echo "Configuración settings."

# Ruta al archivo de configuración
archivo_config="data/settings.yaml"

# Cambiar el valor de favicon_image
sed -i '' "s|favicon_image: .*|favicon_image: $nueva_ruta_favicon|" "$archivo_config"

# Cambiar el valor de active dentro del bloque preheader de true a false
sed -i '' '/preheader:/,/text:/ s/active: true/active: false/' "$archivo_config"

echo "Configuración general."

# Ruta al archivo de configuración
archivo_config="data/en/general.yaml"

# Cambiar el valor de logo_subtitle
sed -i '' "s|title:.*|title: $nuevo_titulo|" "$archivo_config"
sed -i '' "s|description:.*|description: $nueva_descripcion|" "$archivo_config"

echo "Configuración header."

# Ruta al archivo de configuración
archivo_config="data/en/header.yaml"

# Cambiar el valor de logo_subtitle
sed -i '' "s|logo_subtitle:.*|logo_subtitle: $nueva_frase|" "$archivo_config"

# Eliminar el contenido del nodo menuitems
# Source: https://stackoverflow.com/questions/6287755/using-sed-to-delete-all-lines-between-two-matching-patterns
sed -i '' '/menuitems:/,/cta:/{//!d;}' "$archivo_config"
#sed -i '' '/menuitems:/s/menuitems:.*/menuitems:/' "$archivo_config"

echo "Configuración Footer"

# Ruta al archivo de configuración YAML
archivo_config="data/en/footer.yaml"

# URLs configurables
export url_linkedin="https://linkedin.com/doit"
export url_twitter="https://twitter.com/doit"
export url_instagram="https://instagram.com/doit"

# Actualizar la sección de menuitems para dejar solo Privacy Policy
yq eval 'del(.menuitems[] | select(.title != "Privacy policy"))' -i "$archivo_config"

# Eliminar el bloque de Mastodon de socials
yq eval 'del(.socials[] | select(.title == "Mastodon"))' -i "$archivo_config"

# Sustituir Facebook por LinkedIn en socials y actualizar la URL y la imagen
yq eval '(.socials[] | select(.title == "Facebook") | .title) = "LinkedIn"' -i "$archivo_config"
yq eval '(.socials[] | select(.title == "LinkedIn") | .link) = strenv(url_linkedin)' -i "$archivo_config"
yq eval '(.socials[] | select(.title == "LinkedIn") | .logo_image) = "/img/linkedin.svg"' -i "$archivo_config"

# Actualizar URLs de Twitter e Instagram
yq eval '(.socials[] | select(.title == "Twitter") | .link) = strenv(url_twitter)' -i "$archivo_config"
yq eval '(.socials[] | select(.title == "Instagram") | .link) = strenv(url_instagram)' -i "$archivo_config"

# Vaciar el contenido de footer_text
yq eval '(.footer_text) = ""' -i "$archivo_config"

echo "Eliminar mapa"
# Ruta al archivo
archivo="content/en/get-started.md"

# Comando para eliminar la línea específica
sed -i '' '/{{< brick_map >}}{{< \/brick_map >}}/d' "$archivo"

echo "Limpiando anterior demo"

cd ..
rm -v target.css
rm -v target_snapshot.png
rm -v target_index.md
rm -v target_images_concepts.json
rm -rv demo_images/

echo "Configuración actualizada."

echo "Setup finalizado."