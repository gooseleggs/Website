# Dependency installer
FROM node:22-alpine AS dependencies

WORKDIR /app
COPY package*.json ./
RUN npm ci




# Builder
FROM node:22-alpine AS builder

WORKDIR /app

##############################################################
##################Install Optimization Tools##################
##############################################################

RUN apk add brotli zstd py3-fonttools py3-brotli py3-beautifulsoup4 zopfli

RUN npm install postcss postcss-cli autoprefixer cssnano postcss-calc purgecss


##############################################################
########################Build the Site########################
##############################################################

COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm run build 
RUN ln -s _site out


##############################################################
########################CSS Purging###########################
##############################################################
RUN echo "module.exports = {" \
  "  content: ['/app/_site/**/*.html']," \
  "  css: ['/app/_site/**/*.css']," \
  "  output: '/app/_site/css'," \
  "  variables: true," \
  "  keyframes: true," \
  "  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []" \
  "};" > /app/config.js
RUN npx purgecss --config config.js

##############################################################
###########CSS Vendor Prefixing and Minification##############
##############################################################
RUN npx postcss /app/_site/**/*.css --use autoprefixer cssnano postcss-calc --replace --verbose --no-map


##############################################################
#################HTML and JS Minification#####################
##############################################################
RUN npm install --no-save html-minifier-terser terser
ENV PATH="/app/node_modules/.bin:${PATH}"

# minify HTML
RUN find /app/_site -type f -name "*.html" -print0 | \
    xargs -0 -I{} sh -c \
      'html-minifier-terser \
        --collapse-whitespace \
        --sort-attributes \
        --remove-comments \
        --remove-empty-attributes \
        --remove-attribute-quotes \
        --remove-redundant-attributes \
        --remove-script-type-attributes \
        --remove-style-link-type-attributes \
        --minify-css true \
        --minify-js true \
        --sort-class-name \
        --decode-entities \
        --use-short-doctype \
        --minify-urls true \
        -o "{}" "{}"'

# minify JS
RUN find /app/_site -type f -name "*.js" -print0 | \
    xargs -0 -I{} sh -c \
      'terser "{}" \
        --compress passes=3,unsafe=true,unsafe_arrows=true,unsafe_methods=true,drop_console=true \
        --mangle toplevel,properties \
        --ecma 2024 \
        -o "{}"'




##############################################################
#####################Font Subsetting##########################
##############################################################

#RUN python glyph_extractor.py

# subsetting of the fonts
#RUN pyftsubset ./layout/font/lexend/Lexend-SemiBold-Font.woff2 \
#    --output-file=/app/_site/font/lexend/Lexend-SemiBold-Font.woff2 \
#    --flavor=woff2 \
#    --no-hinting \
#    --text-file=/semibold.txt

#RUN pyftsubset ./layout/font/lexend/Lexend-Regular-Font.woff2 \
#    --output-file=/app/_site/font/lexend/Lexend-Regular-Font.woff2 \
#    --flavor=woff2 \
#    --no-hinting \
#    --text-file=/regular.txt



##############################################################
######################Cache Busting###########################
##############################################################

RUN python cache_buster.py


##############################################################
####################Static Compression########################
##############################################################

# Step to generate gzip and Brotli compressed files
RUN find /app/_site -type f \
    -exec zopfli -k -15 {}   \; \
    -exec sh -c 'gzipfile="{}.gz"; \
    if [ -f "$gzipfile" ] && [ $(stat -c%s "$gzipfile") -ge $(stat -c%s "{}") ]; then \
        rm "$gzipfile"; echo "$gzipfile discarded (larger than original)" >&2; \
    fi' \;

RUN find /app/_site -type f \
    ! -name '*.gz'        \
    -exec brotli -k -Z {} \; \
    -exec sh -c 'brotlifile="{}.br"; \
    gzipfile="{}.gz"; \
    origfile="{}"; \
    # Check if Brotli is larger than the original file \
    if [ -f "$brotlifile" ] && [ $(stat -c%s "$brotlifile") -ge $(stat -c%s "$origfile") ]; then \
        rm "$brotlifile"; \
        echo "$brotlifile discarded (larger than original)" >&2; \
    elif [ -f "$brotlifile" ] && [ -f "$gzipfile" ] && [ $(stat -c%s "$brotlifile") -ge $(stat -c%s "$gzipfile") ]; then \
        rm "$brotlifile"; \
        echo "$brotlifile discarded (larger than gzip)" >&2; \
    fi' \;

RUN find /app/_site -type f \
    ! -name '*.gz'        \
    ! -name '*.br'        \
    -exec zstd -k --ultra -22 {} \; \
    -exec sh -c 'zstdfile="{}.zst"; gzipfile="{}.gz"; brotlifile="{}.br"; origfile="{}"; \
    if [ -f "$zstdfile" ] && [ $(stat -c%s "$zstdfile") -ge $(stat -c%s "$origfile") ]; then \
        rm "$zstdfile"; \
        echo "$zstdfile discarded (larger than original)" >&2; \
    elif [ -f "$zstdfile" ] && [ -f "$gzipfile" ] && [ $(stat -c%s "$zstdfile") -ge $(stat -c%s "$gzipfile") ]; then \
        rm "$zstdfile"; \
        echo "$zstdfile discarded (larger than gzip)" >&2; \
    elif [ -f "$zstdfile" ] && [ -f "$brotlifile" ] && [ $(stat -c%s "$zstdfile") -ge $(stat -c%s "$brotlifile") ]; then \
        rm "$zstdfile"; \
        echo "$zstdfile discarded (larger than brotli)" >&2; \
    fi' \;



# Runner
FROM alpine

RUN apk add brotli nginx-mod-http-brotli nginx-mod-http-zstd nginx

# copy files from the builder
COPY --from=builder /app/_site /usr/share/nginx/html
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
