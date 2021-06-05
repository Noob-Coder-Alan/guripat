import { buildSchema } from "type-graphql";
import { ListResolver } from "../resolvers/ListResolver";
import { ItemResolver } from "../resolvers/ItemResolver";

export const createSchema = () => buildSchema({
    resolvers: [ListResolver, ItemResolver],
});
