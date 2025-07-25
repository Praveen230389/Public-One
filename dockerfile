# Use lightweight and secure Nginx image
FROM nginx:alpine

# Remove the default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files into the nginx public folder
COPY . /usr/share/nginx/html
