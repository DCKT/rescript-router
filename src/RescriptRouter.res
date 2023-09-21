module type RouterConfig = {
  type t
  let make: RescriptReactRouter.url => t
  let toString: t => string
}

module CreateRouter = (Config: RouterConfig) => {
  type contextState = {currentRoute: Config.t}

  let replace = (route: Config.t) => RescriptReactRouter.replace(route->Config.toString)

  let routerContext = React.createContext({
    currentRoute: RescriptReactRouter.dangerouslyGetInitialUrl()->Config.make,
  })

  module RouterContextProvider = {
    let make = React.Context.provider(routerContext)
  }

  module Provider = {
    @react.component
    let make = (~children) => {
      let (currentRoute, setCurrentRoute) = React.useState(() =>
        RescriptReactRouter.dangerouslyGetInitialUrl()->Config.make
      )

      React.useLayoutEffect1(() => {
        let watcherID = RescriptReactRouter.watchUrl(url => setCurrentRoute(_ => url->Config.make))
        Some(() => RescriptReactRouter.unwatchUrl(watcherID))
      }, [setCurrentRoute])

      let contextValue: contextState = {
        currentRoute: currentRoute,
      }

      <RouterContextProvider value={contextValue}>
        {children(~currentRoute)}
      </RouterContextProvider>
    }
  }

  let useRoute = (): Config.t => RescriptReactRouter.useUrl()->Config.make

  let isRouteEqual = (routeA: Config.t, routeB: Config.t): bool => {
    let routeA = {
      let url = routeA->Config.toString
      let queryParamsIndex = url->Js.String2.indexOf("?")

      queryParamsIndex === -1 ? url : url->Js.String2.slice(~from=0, ~to_=queryParamsIndex)
    }

    let routeB = {
      let url = routeB->Config.toString
      let queryParamsIndex = url->Js.String2.indexOf("?")

      queryParamsIndex === -1 ? url : url->Js.String2.slice(~from=0, ~to_=queryParamsIndex)
    }

    routeA === routeB
  }

  let useIsCurrentRoute = (route: Config.t): bool => {
    let {currentRoute} = React.useContext(routerContext)
    isRouteEqual(currentRoute, route)
  }

  let navigate = (route: Config.t): unit => route->Config.toString->RescriptReactRouter.push

  let redirect = (route: Config.t): unit => route->Config.toString->RescriptReactRouter.replace

  let toString = Config.toString

  module Link = {
    @react.component
    let make = (
      ~route: Config.t,
      ~className="",
      ~activeClassName="",
      ~onClick: option<ReactEvent.Mouse.t => unit>=?,
      ~isExternal=false,
      ~children,
    ) => {
      let isCurrentRoute = useIsCurrentRoute(route)
      let activeClassName = isCurrentRoute ? activeClassName : ""

      <a
        href={route->Config.toString}
        target={isExternal ? "_blank" : ""}
        className={cx([className, activeClassName])}
        onClick={event =>
          if (
            !(event->ReactEvent.Mouse.defaultPrevented) &&
            (event->ReactEvent.Mouse.button == 0 &&
            (!(event->ReactEvent.Mouse.altKey) &&
            (!(event->ReactEvent.Mouse.ctrlKey) &&
            (!(event->ReactEvent.Mouse.metaKey) &&
            (!(event->ReactEvent.Mouse.shiftKey) &&
            !isExternal)))))
          ) {
            event->ReactEvent.Mouse.preventDefault
            onClick->Option.map(fn => fn(event))->ignore
            route->navigate
          }}>
        children
      </a>
    }
  }

  module Redirect = {
    type behavior =
      | Push
      | Replace

    @react.component
    let make = (~to_: Config.t, ~behavior=Replace) => {
      React.useEffect0(() => {
        switch behavior {
        | Push => navigate(to_)
        | Replace => replace(to_)
        }
        None
      })

      React.null
    }
  }

  module RedirectExternal = {
    %%private(
      @val
      external replace: string => unit = "window.location.replace"
    )

    @react.component
    let make = (~url: string) => {
      React.useEffect0(() => {
        replace(url)

        None
      })

      React.null
    }
  }
}
