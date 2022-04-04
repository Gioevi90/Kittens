# Cats
Sample Cat List Application written using ReSwift.

<img src="./.github/ezgif-5-1afad6a9df.gif" width="160" height="340" />

# Introduction

This application is a sample who shows a way that can be used to modularize an application written using ReSwift.
The repository contains 2 different branches:

* <b>develop</b>: contains the not modularized version of the application, the one who needs to be refactored
* <b>feature/modularization</b>: contains the result of the modularization.

# Steps to perform modularization

The steps to modularize the application are:

1. create the pullback function to convert the Middlewares from LocalState to GlobalState, in order to assign it to the store during its instantiation.

2. create a Store wrapper class focused on the LocalState instead of the global one.

3. create the view extension function for the Store, which computes a new LocalStore focused on some LocalState

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
## Store Wrapper

We need to create a LocalStore wrapper in order to pass it to the submodules. The wrapper must wrap all the important functions of the store, that are:

* dispatch: needed to dispatch a new action
* subscribe: needed to the views to subscribe to the state changes
* unsubscribe: needed to the views to unsubscribe from the state changes
* state: needed to get the current state

```
public class LocalStore<State, S: StoreSubscriber> where State == S.StoreSubscriberStateType {
    var dispatchFunction: DispatchFunction
    var subscribeFunction: (S) -> Void
    var unsubscribeFunction: (AnyStoreSubscriber) -> Void
    var getState: () -> State
    
    public init(getState: @escaping () -> State,
                dispatchFunction: @escaping DispatchFunction,
                subscribeFunction: @escaping (S) -> Void,
                unsubscribeFunction: @escaping (AnyStoreSubscriber) -> Void) {
        self.getState = getState
        self.dispatchFunction = dispatchFunction
        self.subscribeFunction = subscribeFunction
        self.unsubscribeFunction = unsubscribeFunction
    }
    
    public var state: State {
        getState()
    }
    
    public func dispatch(_ action: Action) {
        self.dispatchFunction(action)
    }
    
    public func subscribe(_ subscriber: S) where S: StoreSubscriber, State == S.StoreSubscriberStateType {
        subscribeFunction(subscriber)
    }
    
    public func subscribe<SelectedState>(_ subscriber: S,
                                  transform: ((ReSwift.Subscription<State>) -> ReSwift.Subscription<SelectedState>)?)
    where SelectedState == S.StoreSubscriberStateType, S : StoreSubscriber {
        subscribeFunction(subscriber)
    }
    
    public func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        unsubscribeFunction(subscriber)
    }
    
    public func dispatch(_ asyncActionCreator: Action, callback: ((State) -> Void)?) {}
}
```

This is not the single solution to this problem. You can find another solution described in this solved issue:
https://github.com/ReSwift/ReSwift/issues/377

## Store view function

We can now add a new function to the store, in order to compute a LocalStore of LocalState from a Store of GlobalState, and passing it through the views.

```
public extension Store {
    func view<LocalState, S: StoreSubscriber>(state: KeyPath<State, LocalState>) -> LocalStore<LocalState, S> where S.StoreSubscriberStateType == LocalState {
        LocalStore<LocalState, S>(getState: { self.state[keyPath: state] },
                                  dispatchFunction: { self.dispatch($0) },
                                  subscribeFunction: { self.subscribe($0) { $0.select { $0[keyPath: state]  }} },
                                  unsubscribeFunction: { self.unsubscribe($0) })
    }
}
```

The <b>view</b> function consists in the creation of a new local store wrapper starting from the global one. 

## References

All the stuff described here is born following the Point-Free composable architecture videos. You can find the video references and the repo at https://github.com/pointfreeco/swift-composable-architecture.