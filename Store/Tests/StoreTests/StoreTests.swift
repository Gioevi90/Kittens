import XCTest
import ReSwift
@testable import Store

final class StoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        testStore = Store<TestState>(reducer: testReducer,
                                     state: nil)
    }
    
    func testState_isupdatedCorretly_afterDispatchAction() {
        let localStore: LocalStore<TestSubState, TestSubscriber> = testStore.view(state: \.subState)
    
        // dispatch action from localStore
        localStore.dispatch(TestAction.ChangeValueAction(value: "test"))
        
        // test that both local and global stores are updated
        XCTAssertEqual(testStore.state.subState.value, "test")
        XCTAssertEqual(localStore.state.value, "test")
    }
    
    func testNewState_whenLocalStoreIsSubscribed_isCalledAfterDispatchAction() {
        let localStore: LocalStore<TestSubState, TestSubscriber> = testStore.view(state: \.subState)
        let subscriber = TestSubscriber()
        localStore.subscribe(subscriber)
        
        subscriber.newStateHandler = { newState in
            XCTAssertEqual("test2", newState.value)
        }
    
        // dispatch action from localStore
        localStore.dispatch(TestAction.ChangeValueAction(value: "test2"))
        
        XCTAssertEqual(subscriber.newStateCallCount, 2)
    }
    
    func testNewState_whenLocalStoreIsUnSubscribed_isNotCalledAfterDispatchAction() {
        let localStore: LocalStore<TestSubState, TestSubscriber> = testStore.view(state: \.subState)
        let subscriber = TestSubscriber()
        localStore.subscribe(subscriber)
        localStore.unsubscribe(subscriber)
    
        // dispatch action from localStore
        localStore.dispatch(TestAction.ChangeValueAction(value: "test2"))
        
        XCTAssertEqual(subscriber.newStateCallCount, 1)
    }
}
