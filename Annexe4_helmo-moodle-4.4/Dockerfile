# Utilisation de l'image officielle de PHP avec Apache
FROM php:8.3-apache

# Installation des dépendances nécessaires pour Moodle et les extensions PHP
RUN apt-get update && \
    apt-get install -y wget unzip libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libicu-dev libxml2-dev openssl cron && \
    rm -rf /var/lib/apt/lists/*

# Installation des extensions PHP nécessaires
RUN docker-php-ext-install zip mysqli gd intl soap exif && \
    docker-php-ext-enable intl soap exif

# Installation et configuration de OPcache
RUN docker-php-ext-install opcache && \
    docker-php-ext-enable opcache

# Configuration de OPcache
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini && \
    echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/opcache.ini

# Configuration de PHP pour Moodle
RUN echo "max_input_vars=5000" >> /usr/local/etc/php/conf.d/moodle.ini

# Téléchargement et extraction de Moodle
RUN wget https://github.com/moodle/moodle/archive/refs/tags/v4.4.0.zip -O /tmp/moodle.zip && \
    unzip /tmp/moodle.zip -d /tmp && \
    mv /tmp/moodle-4.4.0/* /var/www/html/ && \
    rm -rf /tmp/moodle-4.4.0 /tmp/moodle.zip


# Création des répertoires nécessaires
RUN mkdir -p /mnt/learnData/moodle-data/

# Copie du fichier de configuration dans le répertoire web de Moodle
COPY config.php /var/www/html/

# Copie du répertoire /boost_helmo local dans le répertoire web de Moodle
COPY boost_helmo /var/www/html/theme/boost_helmo/

# Copie du plugin streampad dans le répertoire mod de Moodle
COPY streampad /var/www/html/mod/streampad/

# Copie des scripts
COPY install_plugin.sh /usr/local/bin/install_plugin.sh
COPY script_upgrade.sh /usr/local/bin/script_upgrade.sh
COPY backup-cours.sh   /usr/local/bin/backup-cours.sh
COPY archive-backup.sh /usr/local/bin/archive-backup.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/install_plugin.sh /usr/local/bin/script_upgrade.sh /usr/local/bin/backup-cours.sh /usr/local/bin/archive-backup.sh /usr/local/bin/entrypoint.sh

# Utilisation du script pour installer des plugins
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31735/mod_checklist_moodle44_2024040201.zip checklist mod
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/30516/mod_etherpadlite_moodle44_2023101501.zip etherpadlite mod
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/30905/mod_lightboxgallery_moodle44_2024012301.zip lightboxgallery mod
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31736/mod_realtimequiz_moodle44_2024040400.zip realtimequiz mod
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31996/block_massaction_moodle44_2024050700.zip massaction blocks
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31773/block_xp_moodle44_2024042104.zip xp blocks
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31775/qtype_gapfill_moodle44_2024042300.zip gapfill question/type
#RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31925/qtype_regexp_moodle44_2024050300.zip regexp question/type
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31860/qtype_wordselect_moodle44_2024042900.zip wordselect question/type
RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/32105/format_onetopic_moodle44_2024050901.zip onetopic course/format

#RUN /usr/local/bin/install_plugin.sh https://moodle.org/plugins/download.php/31757/mod_wooclap_moodle43_2024042200.zip wooclap mod


# Attribution des permissions et des autorisations
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 0755 /var/www/html/ && \
    find /var/www/html/ -type d -exec chmod 755 {} ";" && \
    find /var/www/html/ -type f -exec chmod 644 {} ";" && \
    chown -R www-data:www-data /mnt/learnData/moodle-data && \
    chmod -R 770 /mnt/learnData/moodle-data && \
    find /mnt/learnData/moodle-data/ -type d -exec chmod 700 {} ";" && \
    find /mnt/learnData/moodle-data/ -type f -exec chmod 600 {} ";"

# Ajout des tâches cron dans la crontab
RUN echo '0 1 * * * root /usr/local/bin/backup-cours.sh' >> /etc/crontab && \
    echo '*/1 * * * * www-data /usr/bin/php /var/www/html/admin/cli/cron.php > /dev/null' >> /etc/crontab && \
    echo '* * * * * root echo "Cron is working" >> /var/log/cron.log' >> /etc/crontab

# Exposition des ports HTTP
EXPOSE 80

# Commande d'exécution par défaut (Apache)
CMD ["/usr/local/bin/entrypoint.sh"]
