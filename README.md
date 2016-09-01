**IngredientInspector Dataserver**

IngredientInspector mobile app is an app that allows users to scan barcodes using their phone's camera, and then shows users the food additive ingredients of that product. It uses the data compiled by (e-additives)[http://e-additives.vexelon.net/#!/home] primarily from uk-based food authorities. When users view the potentially concerning ingredients, they are provided the option to add the product to the user's Approved or Avoid lists (accesible from the user dashboard), or to contact the manufacturer.
The server caches each upc inquiry for ingredients, and at the same time looks up and caches the available contact information for that brand name. If the user decides to "contact manufacturer", the server retrieves the saved contact info and will attempt to Tweet at that brand if there is a handle available and send an email if there is an address available, and if there isn't usable contact information it will instead send out a tweet with the brand and product. All forms of contact list additives found in their product.

****Set Up****
To create your own IngredientInspector Dataserver; 

1. clone this repository to your machine.

2. cd into that repository and run `$gem install bundler`

3. run `$bundle`

4. run `$psql createdb ingredient_development`
  4.5 if this doesn't work, enter pg console with `$psql` and then run `createdb ingredient_development`

5. run `$rake db:migrate`

6. run `$rake db:seed`

7. run `$rails s`

****Functional Endpoint****
To receive the JSON information gathered regarding a product, send a GET request to BASE_URL + '/ingredients/:upc/0', where the product's barcode number/UPC replaces :upc.
This will return a data hash of 
{"ingredients" => [array of matching hash entries in the database], 
"manufacturer_contact" => [array of hashed contact options],
"product" => "name of product",
"brand" => "brand of product",
"domain" => "domain associated with brand",
"packaging" => nil, #to be built in future
"message" => "found",
"status" => "ok"}
if the product is found in the Open Food Facts database. If the product is not found in the OFF database, the JSON response will be 
data = { message: "No ingredients added", status: 0}. If the product exists in the database, but hasn't had ingredients added to its record, JSON response will be 
data = { product: product, brand: brand, message: "No ingredients added"}


