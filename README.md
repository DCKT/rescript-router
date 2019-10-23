# Reason React Router

This is project is based on the great old [reroute](https://github.com/callstackincubator/reroute) module.
It's just using the latest Reason React API (hooks & context).

[Checkout this simple demo](https://nifty-leakey-46cc44.netlify.com)

## Setup

Install the module :

```bash
$ yarn add @dck/reason-react-navigation
```

Then add it to your `bsconfig.json`:

```json
{
  "bs-dependencies": ["reason-react", "@dck/reason-react-navigation"]
}
```

## Usage

```reason
open ReasonReactNavigation;

module RouterConfig = {
  type route =
    | Home
    | Hello(string)
    | NotFound;

  let routeFromUrl = (url: ReasonReact.Router.url) =>
    switch (url.path) {
    | [] => Home
    | ["hello", name] => Hello(name)
    | ["404"]
    | _ => NotFound
    };

  let routeToUrl = (route: route) =>
    switch (route) {
    | Home => "/"
    | Hello(name) => "/hello/" ++ name
    | NotFound => "/404"
    };
};

module Router = CreateRouter(RouterConfig);

[@react.component]
let make = () =>
  <div>
    <a href="#" onClick={e => {
      e->ReactEvent.Synthetic.preventDefault;
      Router.navigate(RouterConfig.Home)
    }}>
      "Home "->React.string
    </a>

    <a href="#" onClick={e => {
      e->ReactEvent.Synthetic.preventDefault;
      Router.navigate(RouterConfig.Hello("dck"))
    }}>
      "Hello DCK "->React.string
    </a>
    <Router.Provider>
      ...{
           (~currentRoute) =>
             <p>
               {
                 (
                   switch (currentRoute) {
                   | RouterConfig.Home => "This is home"
                   | RouterConfig.Hello(n) => "Hi " ++ n
                   | _ => "404 not found"
                   }
                 )
                 |> React.string
               }
             </p>
         }
    </Router.Provider>
  </div>
```

### Authentication example

Quick and dirty implementation :

```reason
open ReasonReactNavigation;

module Config = {
  type route =
    | Login
    | Dashboard
    | NotFound;

  let routeToUrl = route =>
    switch (route) {
    | Login => "/login"
    | Dashboard => "/dashboard"
    | NotFound => "/404"
    };
  let routeFromUrl = (url: ReasonReact.Router.url) =>
    switch (url.path) {
    | ["login"] => Login
    | ["dashboard"] => Dashboard
    | _ => NotFound
    };
};

module Router = CreateRouter(Config);

[@react.component]
let make = () => {
  let (currentUser, setCurrentUser) = React.useState(() => None);

  <Router.Provider>
    {
      (~currentRoute) =>
        switch (currentRoute, currentUser) {
        | (Config.Login, None) => <Login />
        | (Config.Login, Some(_)) => <Redirect to_=Config.Dashboard />
        | (route, Some(user)) =>
          switch (route) {
          | Config.Dashboard => <Dashboard user />
          | _ => <NotFound />
          }
        | (Config.NotFound, _) => <NotFound />
        | (_, None) => <Redirect to_=Login />
        }
    }
  </Router.Provider>
};
```

## Run demo

Install dependencies

```
yarn
```

Run bsb watcher

```
yarn start
```

Run webpack-dev-server

```
yarn demo
```

Go to `http://localhost:8000`
