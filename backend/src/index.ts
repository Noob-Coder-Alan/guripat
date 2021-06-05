import { createConnection } from "typeorm";
import express = require('express');
import { ApolloServer } from 'apollo-server-express';
import { createSchema } from "./utils/createSchema";
require('dotenv').config();

const startServer = async () => {
  const app = express()
  const port = Number(process.env.PORT) || 5000;
  const connection = await createConnection()


  const schema = await createSchema();

  const server = new ApolloServer({ 
    schema, 
    context: ({req, res}) => ({
      req, 
      res
    }),
  });

  app.use(express.json());
  app.use(express.urlencoded({extended: false}));

  server.applyMiddleware({app});

  app.listen({ port }, () => {
    console.log(`Server is up on http://localhost:${port}${server.graphqlPath}`);
  }).on('close', () => {
    connection.close();
  });
}

startServer();