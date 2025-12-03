# #30DaysOfAWSTerraform

## Day 06 — AWS Terraform Type Constraints Explained (with realtime examples)

### Learning objectives


### Baseline layout

![Terraform variable flow](./varaible.drawio.png)

Based on purpose is already covered.

based on value.

type contraint means type of value that we store in a variable.
it defined the type of variable it is.

2 major category.
1. Primitve - straight forward we use all the times. (string,number, boolean)
ex:
Name: "Terraform" #double quotes indicates the value is string
age=35 # type Number
Adult=yes #boolean

2. Complex - have multiple values
each have seperate purpose

3.Null is a special type of variable it store null values.
reserves the space in the memory, and it doe not have any value.

if it does not mention anything it will take the datatype as any.

varaible has multiple fieds
importand fields are description and type.


https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

Adding multiple CIDR block

when ever we have to access the particular element of the set, then we need to convert into list first.


how to we use teh set elements without converting into list

tags has multple key calue pairs
