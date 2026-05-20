# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run docs:build

# Stage 2: Export (for bake docs-export target)
FROM scratch AS out
COPY --from=build /app/docs/.vitepress/dist /

# Stage 3: Serve
FROM nginx:alpine AS server

COPY --from=build /app/docs/.vitepress/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
