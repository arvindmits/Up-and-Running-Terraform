/*****************************************************************************
*    Required Variable
******************************************************************************/
// variable "db_password" {
//     description = "The password for the database"
//     type = string
// }

/*****************************************************************************
*    Optional Variable
******************************************************************************/
variable "db_name {
    description = "The name to use for the database"
    type = string
    default = "ryanharlich_example_database_stage"
}