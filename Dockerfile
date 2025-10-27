FROM node:18-alpine

WORKDIR /home/node/app

COPY package*.json ./

RUN npm ci

COPY . .

RUN chown -R node:node /home/node/app
USER node

EXPOSE 3000
CMD ["node", "src/app.js"]
