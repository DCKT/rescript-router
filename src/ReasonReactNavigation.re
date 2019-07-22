module type RouterConfig = {
  type route;
  let routeFromUrl: ReasonReact.Router.url => route;
  let routeToUrl: route => string;
};

module CreateRouter = (Config: RouterConfig) => {
  module Container = {
    type currentRoute = Config.route;

    [@react.component]
    let make = (~children) => {
      let (currentRoute, setCurrentRoute) =
        React.useState(() =>
          ReasonReact.Router.dangerouslyGetInitialUrl() |> Config.routeFromUrl
        );

      React.useLayoutEffect1(
        () => {
          let watcherID =
            ReasonReact.Router.watchUrl(url =>
              setCurrentRoute(_ => url |> Config.routeFromUrl)
            );
          Some(() => ReasonReact.Router.unwatchUrl(watcherID));
        },
        [|setCurrentRoute|],
      );

      children(~currentRoute);
    };
  };

  let navigate = (route: Config.route) =>
    ReasonReact.Router.push(route |> Config.routeToUrl);

  let replace = (route: Config.route) =>
    ReasonReact.Router.replace(route |> Config.routeToUrl);
};