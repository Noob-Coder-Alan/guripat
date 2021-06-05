import { Field, ID, ObjectType } from "type-graphql";
import { BaseEntity, Column, Entity, ManyToMany, ManyToOne, OneToMany, OneToOne, PrimaryGeneratedColumn } from "typeorm";
import { Item } from "./Item";

@Entity()
@ObjectType()
export class List extends BaseEntity {
  @PrimaryGeneratedColumn()
  @Field(() => ID)
  id: number;

  @Column()
  @Field()
  code: string;

  @OneToMany(() => Item, item => item.list, {nullable: true})
  items: Item[];
}