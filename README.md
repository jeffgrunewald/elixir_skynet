# Skynet Exercise

## The Exercise

### The Server

The exercise is to model Skynet and Terminators using Elixir. A user can spawn Terminators and then those Terminators go on living their metallic, human-killing lives. Each Terminator has a chance to reproduce and be killed by Sarah Connor at specific intervals.

- Take advantage of Elixir's OTP features.
- When the app starts there should be no Terminators.
- There should be a function that when called spawns a Terminator.
  - While this terminator is alive, it has a chance to reproduce and be killed by Sarah Connor.
  - Every 5 seconds, each terminator has a 20% chance of reproducing, creating 1 new terminator.
    - Terminators can reproduce more than once. They're trying to take over the world, after all.
  - Every 10 seconds, each terminator has a 25% chance to be killed by Sarah Connor.
- Each terminator should have a unique ID.
- There should be a function to manually kill a Terminator given its ID.
- There should be a function to get a list of all living Terminators.
- You don't need to keep track of ancestry / heirarchy.
- Expect this part to be run and manually tested in `iex`.

### The API

Create API endpoints for the following actions. You can pick what API protocol to use, if any.

- Spawn a terminator
- Manually kill a terminator
- List all living terminators

### The Front-end

Create a web page for the following. You can pick what technology to use and you won't be judged for how the page looks, style-wise.

- A clickable button that says "Create Terminator"
- A list of all living terminators, updated in real-time
- The ability to select a specific terminator in the list and "manually kill" it
