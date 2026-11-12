FROM node:20-alpine AS builder

WORKDIR /opt/app

COPY package*.json ./

RUN npm install

COPY *.js ./

FROM node:20-alpine

WORKDIR /opt/app

COPY --from=builder /opt/app/node_modules ./node_modules
COPY --from=builder /opt/app/package*.json ./
COPY --from=builder /opt/app/*.js ./

RUN adduser -D roboshop

ENV MONGO=true \
    MONGO_URL="mongodb://mongodb:27017/catalogue"

USER roboshop

CMD ["node", "server.js"]