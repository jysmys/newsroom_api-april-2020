# newsroom_api-april-2020

# API

Prefix for all requests >>> **/api**

### **Articles**

#### index

get /articles  
created_at is based on db created_at, and may need to be changed to be published_at later
Response : {articles:[{id:1,title:"title1"},{id:2,title:"title2"}]}

```
{
    "articles":[
        {"id":1,
        "title":"title1",
        "category":"category1",
        "published_at":"YYYY-MM-dd hh:mm"
        },
        {"id":2,
        "title":"title2",
        "category":"category2",
        "published_at":"YYYY-MM-dd hh:mm"
        }
    ]
}
```

#### show

get /articles/:id
:id exists in db gives a 200 response with body:

:body is restricted to 100 characters without user credentials for articles where :premium is true

```
{
  "article": {
    "id": 1,
    "title": "A title",
    "body": "The body",
    "published_at":"YYYY-MM-dd hh:mm"
    "premium": false
  }
}
```

:id does not exist in db gives a 404 with body:

```
{
  "message": "Article with id :id could not be found"
}
```

#### create

post /articles **Requires authentication headers!**
Headers need to include the standard { uid: "", client: "", access_token: "", expiry: "", token_type: "Bearer" }
with :title, and :body params (:category is available to set, or will default to "other"), gives 200 response with body:

```
{
  "id": :id,
  "message": "Article successfully created!"
}
```

with :title,or :body params missing, gives 400 response with body:

```
{
  "message": "Title can't be blank"
}

or

{
  "message": "Body can't be blank"
}

or

{
  "message": "Category can't be blank"
}

or

{
  "message": "Image can't be blank"
}
```

### **Admin::Articles**

#### index

get /admin/articles returns only unpublished articles (:published=false)
created_at is based on db created_at

```
{
    "articles":[
        {"id":1,
        "title":"title1",
        "category":"category1",
        "created_at":"YYYY-MM-dd hh:mm"
        },
        {"id":2,
        "title":"title2",
        "category":"category2",
        "created_at":"YYYY-MM-dd hh:mm"
        }
    ]
}
```

### **Login**

All [devise_token_auth endpoints](https://devise-token-auth.gitbook.io/devise-token-auth/usage) are open, only sign in is tested for right now.
post /auth/sign_in
The login response also includes :role, which can be "user", "journalist", "editor".

```
{
    "data":
  {"id":12,
   "email":"mystring@mail.com",
   "provider":"email",
   "uid":"mystring@mail.com",
   "allow_password_change":false,
   "role": "user"
}
```

with wrong password or email

```
{
    "success":false, "errors":["Invalid login credentials. Please try again."]
}
```
