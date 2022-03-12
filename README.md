# Cats
Sample Cat List Application written using ReSwift.

<img src="./.github/ezgif-5-1afad6a9df.gif" width="160" height="340" />

# Introduction

This application is a sample who shows the idea I had to modularize an application written using ReSwift.
The repository contains 2 different branches:

* <b>develop</b>: contains the not modularized version of the application, the one who needs to be refactored
* <b>feature/modularization</b>: contains the result of the modularization.

# Steps to perform modularization

The steps to modularize the application are:

1. create the pullback function to convert the middlewares from localState to globalState, in order to assign it to the store during its instantiation.

2. create a new Store with the following constraints:
    * a public and published state variable
    * a public cancellable variable

3. create the view function into your new store, which transforms the stores from globalState to localState, in order to assign them to the views.

## Pullback function for Middlewares

From Wikipedia:

<i>Precomposition with a function probably provides the most elementary notion of pullback: in simple terms, a function f of a variable y, where y itself is a function of another variable x, may be written as a function of x. This is the pullback of f by the function y.</i>

                    f(y(x)) ≡ g(x)

In our case, we need to find a function f that pulls back a Middleware from a LocalState to a GlobalState, in order to assign it to the store. 

From ReSwift code, we have that the correct definition of Middleware depends on these two typealiases

```
public typealias DispatchFunction = (Action) -> Void
public typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> State?)
    -> (@escaping DispatchFunction) -> DispatchFunction
```

So, from the definitions we see that we just need to transform the return of the right parameter in order to make it work ( because the DispatchFunction doesn't involve the State in any operation ). 

The function we are looking for is:

```
func pullback<GlobalState, LocalState>(input: @escaping Middleware<LocalState>,
                                       state: KeyPath<GlobalState, LocalState>) -> Middleware<GlobalState> {
    return { globalDispatch, globalStateFunction in
        return input(globalDispatch, { globalStateFunction()?[keyPath: state] })
    }
}
```
## New Store Creation

We need to create a new Store because the one provided by ReSwift does not admit any state modification. 

For semplicity ( and lazyness) I copy-pasted the one from ReSwift. This is a big workaround that can be avoided using generics and injecting the Store\<AppState> in every module. However, I decided to create a new store because my goal was to perform a real modularization of the code, instead of hide it using generics and protocols.

The other solution is described in this solved issue:
https://github.com/ReSwift/ReSwift/issues/377

The new Store created is equal to the one in ReSwift, except of:

* the state, which is public
* the state, which is annotated with @Published
* a new cancellable property to store the subscription

## Store view function

Once the state is modifiable, I added a new function to the store, in order to convert a Store of GlobalState to a Store of LocalState, and passing it through the views.

```
extension MyStore {
    func view<LocalState>(state: KeyPath<State, LocalState>,
                          defaultState: LocalState) -> MyStore<LocalState> {
        let localStore = MyStore<LocalState>(reducer: { action, localState in
            self.dispatch(action)
            return self.state?[keyPath: state] ?? defaultState
        }, state: self.state?[keyPath: state])
        
        localStore.cancellable = self.$state.sink { newState in
            localStore.state = newState?[keyPath: state] ?? defaultState
        }
        return localStore
    }
}
```

The <b>view</b> function consists in the creation of a new local store starting from the global one. 

The new local store must also be aware of each store change, so that it can update the state every time the global state changes. 

This is necessary because otherwise there would be an issue in local state updating, resulting in a not working application.
