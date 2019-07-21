# Reason React Router

This is project is based on the great old [https://github.com/callstackincubator/reroute](reroute) module.
It's just using the latest API.

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
      event->ReactEvent.Synthetic.preventDefault;
      Router.navigate(RouterConfig.Home)
    }}>
      "Home "->React.string
    </a>

    <a href="#" onClick={e => {
      event->ReactEvent.Synthetic.preventDefault;
      Router.navigate(RouterConfig.Hello("dck"))
    }}>
      "Hello DCK "->React.string
    </a>
    <Router.Container>
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
    </Router.Container>
  </div>
```
