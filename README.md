# ReScript Router

This is project is based on the great old [reroute](https://github.com/callstackincubator/reroute) module.
It's just using the latest Reason React API (hooks & context).

[Checkout this simple demo](https://nifty-leakey-46cc44.netlify.com)

## Setup

Install the module :

```bash
$ yarn add @dck/rescript-router
```

Then add it to your `bsconfig.json`:

```json
{
  "bs-dependencies": ["@rescript/react", "@dck/rescript-router"]
}
```

## Usage

### Create your configuration

```rescript
open RescriptRouter

module RouterConfig = {
  type t =
    | Home
    | About
    | Hello(string)
    | NotFound

  let make = (url: RescriptReactRouter.url) =>
    switch url.path {
    | list{} => Home
    | list{"about"} => About
    | list{"hello", name} => Hello(name)
    | list{"404"}
    | _ =>
      NotFound
    }

  let toString = (route: t) =>
    switch route {
    | Home => "/"
    | About => "/about"
    | Hello(name) => "/hello/" ++ name
    | NotFound => "/404"
    }
}

module Router = CreateRouter(RouterConfig)
```

### Add the Provider

```rescript
module App = {
  @react.component
  let make = () =>
    <Router.Provider>
      {(~currentRoute) => <>
        <div className="container mx-auto p-4">
          <h1 className="text-xl font-semibold text-center mb-4 text-blue-700">
            {"RescriptRouter example"->React.string}
          </h1>
          <div className="flex flex-row items-center mb-4">
            <CustomLink route=RouterConfig.Home> {"Home"->React.string} </CustomLink>
            <CustomLink route=RouterConfig.About> {"About"->React.string} </CustomLink>
            <CustomLink route={RouterConfig.Hello("dck")}>
              {"Route with params"->React.string}
            </CustomLink>
          </div>
          {switch currentRoute {
          | RouterConfig.Home => <h1> {"Home"->React.string} </h1>
          | RouterConfig.About => <h1> {"About"->React.string} </h1>
          | RouterConfig.Hello(name) =>
            <div>
              <h1> {"Route with params"->React.string} </h1>
              <p> {("Hi : " ++ name)->React.string} </p>
            </div>
          | _ => <h1> {"404 not found"->React.string} </h1>
          }}
        </div>
      </>}
    </Router.Provider>
}
```

### Use built-in Link module

Don't forget to use it inside the Provider 😉

```rescript
module CustomLink = {
  @react.component
  let make = (~route: RouterConfig.t, ~children) => {
    <Router.Link
      className="rounded block px-3 py-2 bg-gray-200 mr-2 hover:bg-gray-300"
      activeClassName="bg-blue-500 text-white hover:bg-blue-600"
      route>
      children
    </Router.Link>
  }
}
```

### Full example

```rescript
open RescriptRouter

module RouterConfig = {
  type t =
    | Home
    | About
    | Hello(string)
    | NotFound

  let make = (url: RescriptReactRouter.url) =>
    switch url.path {
    | list{} => Home
    | list{"about"} => About
    | list{"hello", name} => Hello(name)
    | list{"404"}
    | _ =>
      NotFound
    }

  let toString = (route: t) =>
    switch route {
    | Home => "/"
    | About => "/about"
    | Hello(name) => "/hello/" ++ name
    | NotFound => "/404"
    }
}

module Router = CreateRouter(RouterConfig)

module CustomLink = {
  @react.component
  let make = (~route: RouterConfig.t, ~children) => {
    <Router.Link
      className="rounded block px-3 py-2 bg-gray-200 mr-2 hover:bg-gray-300"
      activeClassName="bg-blue-500 text-white hover:bg-blue-600"
      route>
      children
    </Router.Link>
  }
}

module App = {
  @react.component
  let make = () =>
    <Router.Provider>
      {(~currentRoute) => <>
        <div className="container mx-auto p-4">
          <h1 className="text-xl font-semibold text-center mb-4 text-blue-700">
            {"RescriptRouter example"->React.string}
          </h1>
          <div className="flex flex-row items-center mb-4">
            <CustomLink route=RouterConfig.Home> {"Home"->React.string} </CustomLink>
            <CustomLink route=RouterConfig.About> {"About"->React.string} </CustomLink>
            <CustomLink route={RouterConfig.Hello("dck")}>
              {"Route with params"->React.string}
            </CustomLink>
          </div>
          {switch currentRoute {
          | RouterConfig.Home => <h1> {"Home"->React.string} </h1>
          | RouterConfig.About => <h1> {"About"->React.string} </h1>
          | RouterConfig.Hello(name) =>
            <div>
              <h1> {"Route with params"->React.string} </h1>
              <p> {("Hi : " ++ name)->React.string} </p>
            </div>
          | _ => <h1> {"404 not found"->React.string} </h1>
          }}
        </div>
      </>}
    </Router.Provider>
}

```

## Run demo

Install dependencies

```
yarn
```

Compiles ReScript files

```
yarn start
```

Run webpack-dev-server

```
yarn demo
```

Go to `http://localhost:8000`
