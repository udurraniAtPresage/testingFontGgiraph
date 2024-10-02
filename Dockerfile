# Use the rocker/shiny base image, which includes R and Shiny server
FROM rocker/shiny:4.3.2

# Install system dependencies for ragg, showtext, and ggiraph
RUN apt-get update && apt-get install -y \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('ggiraph', 'ggplot2', 'ragg', 'showtext'), repos = 'https://cloud.r-project.org')"

# Copy the Shiny app files to /srv/shiny-server/
COPY . /srv/shiny-server/

# Make sure the app folder contains the www folder with the custom font
WORKDIR /srv/shiny-server/

# Copy the font to system fonts directory
RUN mkdir -p /usr/share/fonts/truetype/custom \
    && cp www/Airnon.ttf /usr/share/fonts/truetype/custom/Airnon.ttf \
    && fc-cache -fv

# Set permissions for shiny-server
RUN chown -R shiny:shiny /srv/shiny-server

# Expose port 3838 for Shiny
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server', host = '0.0.0.0', port = 3838)"]
