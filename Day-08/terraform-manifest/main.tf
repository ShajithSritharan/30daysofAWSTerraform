resource "aws_s3_bucket" "my_bucket" {
  count = 2
  #bucket = var.bucket_names[count.index] #accessing bucket name from the list
  bucket = var.bucket_names[count.index] #accessing bucket name from the set

  #Set doesnot have indexes. only list ahve indexes

  tags = var.tags
}

#there's a set whiche we have created in the set is of type string in that we have two elements
#since it is a set not a list we cannot iterate through the elements of the set.
# we used for+each loop to iterate through the set or map

resource "aws_s3_bucket" "bucket2" {
    #for_each = length(var.bucket_names_set) #length function gives the number of elements in the set #2
    for_each = var.bucket_names_set # each fo the elements in the set
    bucket = each.value #traversing through the set using each.key

    tags = var.tags

    depends_on = [ aws_s3_bucket.my_bucket ]
}