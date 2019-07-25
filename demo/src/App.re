open ReasonReactNavigation;

module RouterConfig = {
  type route =
    | Home
    | Hello(string)
    | NotFound;

  let initialRoute = Home;

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
  <Router.CurrentRouteProvider>
    <div> <h1> "test"->React.string </h1> </div>
  </Router.CurrentRouteProvider>;

let default = make;