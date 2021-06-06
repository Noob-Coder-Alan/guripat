import { Resolver, Mutation, Arg, Query } from "type-graphql";
import { List } from "../models/List";
import { v4 as uuidv4 } from 'uuid';
import { validate as validateCode } from 'uuid';

@Resolver(() => List)
export class ListResolver {

    @Mutation(() => List)
    async generateListCode() {
      let code = uuidv4();
      let list;

      await List.create({
        code: code
      }).save().then(value => list = value)

      return list;
    }

    @Mutation(() => Boolean)
    async deleteList(@Arg("accessCode") code: string) {
        const list = await List.findOne({ where: { code: code} });
        if(!list) throw Error("List doesn't exist!");

        list.remove();
        return true;
    }

    @Query(() => Boolean)
    async codeIsValid(@Arg("accessCode") code: string) {
      return validateCode(code)
    }

    @Query(() => Boolean)
    async checkConnectionList() {
      return true
    }
}