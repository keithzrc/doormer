# doormer

A new Flutter project.


# Clean Architecture Development Guideline

This guideline outlines the principles and practices of Clean Architecture to be followed in our Flutter project. Adhering to this structure ensures scalability, maintainability, and testability of the codebase. Below, you'll find the why and how behind each aspect of the architecture.

Read: https://medium.com/@yamen.abd98/clean-architecture-in-flutter-mvvm-bloc-dio-79b1615530e1
---

## Core Principles of Clean Architecture

1. **Separation of Concerns**  
   Keep the responsibilities of different parts of the application distinct. This means:
   - UI components handle user interaction and display only.
   - Business logic resides in use cases and domain entities.
   - Data handling and network communication are isolated in the data layer.

2. **Dependency Rule**  
   High-level modules (e.g., domain layer) should not depend on low-level modules (e.g., data layer). Instead, they communicate through abstractions (interfaces).

3. **Testability**  
   By separating logic into independent layers, we ensure that each part can be tested in isolation, improving code reliability.

---

## Folder Structure

Use a feature-based modular structure, with each feature encapsulated within its own directory.
```
lib/
├── core/                  # Application-wide utilities, error handling, network setup, and DI
├── features/
│   └── chat/
│       ├── presentation/  # UI-related code: widgets, pages, blocs
│       ├── domain/        # Business logic: entities, use cases, repositories (interfaces)
│       └── data/          # Data handling: API calls, local storage, repository implementations
└── shared/                # Reusable widgets or utilities shared across features
```
---

### **Layer Responsibilities**

### 1. Presentation Layer
- **Purpose:** Handle UI logic, state management, and user interaction.
- **Components:**
  - **Pages:** Screens or views in the app.
  - **Widgets:** Reusable UI components (e.g., chat bubbles, search bars).
  - **Bloc/State Management:** Manages UI state and triggers domain layer operations.
- **Dependencies:** Only depends on the domain layer. Does not directly communicate with the data layer.

**Example Workflow:**
- A button press triggers a `Bloc` event (e.g., `SendMessageEvent`).
- The `Bloc` processes the event, invokes a use case from the domain layer, and emits a new UI state.

### 2. Domain Layer
- **Purpose:** Centralized business logic and application rules.
- **Components:**
  - **Entities:** Core data models, usually simple and immutable (e.g., `ChatRoom`, `Message`).
  - **Use Cases:** Encapsulated business logic as single-purpose classes (e.g., `FetchChatRooms`, `SendMessage`).
  - **Repositories:** Define abstract contracts for data access.

**Why use cases?**  
- They ensure that the business logic is independent of any framework, allowing easy reuse and testability.

**Example Workflow:**
- The `SendMessageUseCase` takes a `Message` object as input and calls the repository to send it. It contains all business rules for sending messages (e.g., validation, logging).

### 3. Data Layer
- **Purpose:** Handle data operations, such as API calls, local storage, and third-party integrations.
- **Components:**
  - **Repositories:** Implement the contracts defined in the domain layer.
  - **Data Sources:** Responsible for direct data handling (e.g., remote APIs or local databases).
  - **Models:** Data transfer objects (DTOs) used for serialization and deserialization.

**Why isolate data handling?**  
- Changes in APIs or databases don’t affect the rest of the app. The domain layer remains decoupled from specific data sources.

**Example Workflow:**
- The `ChatRepositoryImpl` fetches chat rooms by making an API call via the `ChatRemoteDataSource` and maps the result to `ChatRoom` entities.

## Dependency Management

We use **GetIt** for Dependency Injection (DI), which allows us to inject dependencies (e.g., repositories, blocs) without tight coupling. This promotes loose coupling and makes unit testing easier.

### Steps to Configure DI:
1. Define all dependencies in `injection_container.dart` (e.g., repositories, blocs).
2. Register each dependency using `GetIt.registerLazySingleton` or `GetIt.registerFactory`.

**Example:**
```dart
// Registering dependencies
sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());
sl.registerFactory(() => ChatListBloc(sl()));
```

---

### **Coding Guidelines**

### General Rules
1. **Single Responsibility Principle**  
   Each class or method should have one clear purpose. For example:
   - A use case should encapsulate one business operation.
   - A repository should handle data access only.

2. **Avoid Logic in UI**  
   Keep UI code clean by delegating logic to blocs or use cases. UI should only react to state changes.

3. **Testable Code**  
   Write testable code by injecting dependencies and avoiding static methods or tightly coupled components.

### Bloc Guidelines
1. **Purpose:** Blocs act as the intermediary between the UI and the domain layer, managing state and events.
2. **Structure:**
   - Define **Events** for all user actions or triggers (e.g., `LoadChatList`, `SendMessage`).
   - Define **States** to represent the UI at any point (e.g., `ChatListLoading`, `ChatListLoaded`).
   - Use `on<EventName>` to handle each event and update the state.

**Example Bloc:**
```dart
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;

  ChatListBloc(this.chatRepository) : super(ChatListLoading()) {
    on<LoadChatList>((event, emit) async {
      try {
        final chatRooms = await chatRepository.fetchChatRooms();
        emit(ChatListLoaded(chatRooms));
      } catch (_) {
        emit(ChatListError("Failed to load chat list"));
      }
    });
  }
}
```


---

### **Repository Guidelines**

1. Define interfaces in the **domain layer** for all repositories.
2. Implement the interfaces in the **data layer** using concrete data sources (e.g., API calls via Dio).
3. Return **domain entities** from repository methods, not raw data or DTOs.

**Example Interface:**
```dart
abstract class ChatRepository {
  Future<List<ChatRoom>> fetchChatRooms();
  Future<void> sendMessage(String chatId, Message message);
}


class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatRoom>> fetchChatRooms() async {
    final data = await remoteDataSource.getChatRooms();
    // TODO: Map raw data to ChatRoom entities
    return data.map((dto) => ChatRoom(...)).toList();
  }
}
```


---

### **UI and Widgets Guidelines**

1. Break UI into smaller reusable widgets for modularity.
2. Avoid embedding state management or business logic in widgets.
3. Use `BlocBuilder` or `BlocListener` to react to state changes.

**Example:**
```dart
BlocBuilder<ChatListBloc, ChatListState>(
  builder: (context, state) {
    if (state is ChatListLoading) {
      return CircularProgressIndicator();
    } else if (state is ChatListLoaded) {
      return ListView.builder(
        itemCount: state.chatRooms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(state.chatRooms[index].candidateId),
          );
        },
      );
    } else {
      return Text("Error loading chats");
    }
  },
);
```


---

### **Testing**

1. **Unit Tests**  
   Write tests for:
   - Use cases: Ensure correct business logic.
   - Blocs: Verify state transitions for each event.
   - Repositories: Mock data sources to test interactions.

2. **Integration Tests**  
   Test entire feature flows, such as navigating from the chat list to the chat page.

**Example Bloc Test:**
```dart
void main() {
  late ChatListBloc bloc;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    bloc = ChatListBloc(mockRepository);
  });

  blocTest<ChatListBloc, ChatListState>(
    'emits [ChatListLoading, ChatListLoaded] when chat rooms are loaded',
    build: () => bloc,
    act: (bloc) => bloc.add(LoadChatList()),
    expect: () => [ChatListLoading(), ChatListLoaded(mockChatRooms)],
  );
}
```
