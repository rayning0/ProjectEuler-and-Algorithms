# Interview question:
# Given the a Yaml file of the format found in shipping.yaml parse the file so that we can access it in Ruby.
# 
# Your parsing code should return an object that allows you to access attributes using the [] operator:
# 
# data["product"].first["sku"] => "BL394D"
# The returned object should also allow you to access attributes using method calls:
# 
# data.product.first.sku => "BL394D"

