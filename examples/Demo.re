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

module App = {
  [@react.component]
  let make = () =>
    <Router.Provider>
      ...{(~currentRoute) =>
        <>
          <Router.Link
            className="link"
            activeClassName="active-link"
            route=RouterConfig.Home>
            "Home"->React.string
          </Router.Link>
          <Router.Link
            className="link"
            activeClassName="active-link"
            route={RouterConfig.Hello("dck")}>
            "Hello DCK "->React.string
          </Router.Link>
          <p>
            {(
               switch (currentRoute) {
               | RouterConfig.Home => "This is home"
               | RouterConfig.Hello(n) => "Hi " ++ n
               | _ => "404 not found"
               }
             )
             |> React.string}
          </p>
        </>
      }
    </Router.Provider>;
};
ReactDOMRe.renderToElementWithId(<App />, "root");