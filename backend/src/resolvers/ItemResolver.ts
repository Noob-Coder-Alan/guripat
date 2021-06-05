import { Resolver, Mutation, Arg, Query } from "type-graphql";
import { List } from "../models/List";
import { Item } from "../models/Item";

@Resolver(() => Item)
export class ItemResolver {
    @Mutation(() => Item, { nullable: true })

    async addItem(@Arg("name") name: string, @Arg("quantity") quantity: number, @Arg("isPerishable") isPerishable: boolean, @Arg("accessCode") code: String) {
        const list = await List.findOne({where: {code: code}});
        let item;
        
        await Item.create({
          isPerishable: isPerishable,
          list: list,
          quantity: quantity,
          name: name
        }).save().then(value => item = value)

        console.log(item);

      return item;
    }

    @Query(() => [Item], { nullable: true })
    async getItems(@Arg("accessCode") code: String) {
      const list = await List.findOne({where: {code: code}})
        const items = await Item.find({ where: { list: list } });
        return items;
    }

    
    @Mutation(() => Boolean, { nullable: true })
    async deleteItem(@Arg("accessCode") code: String, @Arg("itemId") itemId: number) {
      const list = await List.findOne({where: {code: code}});
        const item = await Item.findOne({ where: { list: list, id: itemId }, relations: ["list"]  });
        if (!item) throw new Error("Deletion not possible! Item doesn't exist!")
        await item.remove()
        return true;
    }

    @Mutation(() => Item)
    async editItemQuantity(@Arg("accessCode") code: String, @Arg("itemId") itemId: number, @Arg("quantity") quantity: number) {
      const list = await List.findOne({where: {code: code}});
        const item = await Item.findOne({ where: { list: list, id: itemId} });
        if (!item) throw new Error("Can't update a non existent item!");
        item.quantity = quantity;  
        await item.save();
        return item;
    }

    @Mutation(() => Item)
    async markItemAsComplete(@Arg("accessCode") code: String, @Arg("itemId") itemId: number) {
      const list = await List.findOne({where: {code: code}});
        const item = await Item.findOne({ where: { list: list, id: itemId} });
        if (!item) throw new Error("Can't update a non existent item!");
        item.quantity = 0;  
        await item.save();
        return item;
    }

    @Query(() => Boolean, { nullable: true })
    async checkConnection(@Arg("accessCode") code: String) {
        return true;
    }
}