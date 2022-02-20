//
//  LocalStore.swift
//  Cats
//
//  Created by Giovanni Catania on 19/02/22.
//

import ReSwift

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
