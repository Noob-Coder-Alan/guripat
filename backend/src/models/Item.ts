import { Field, ID, ObjectType } from "type-graphql";
import { BaseEntity, Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { List } from "./List";

@Entity()
@ObjectType()
export class Item extends BaseEntity {
    @PrimaryGeneratedColumn()
    @Field(() => ID)
    id: number;

    @Column()
    @Field()
    name: string;
    
    @Column()
    @Field()
    quantity: number;

    @Field(() => List)
    @ManyToOne(() => List, list => list.items, {eager: true})
    list : List;

    @Column()
    @Field()
    isPerishable: boolean;
}