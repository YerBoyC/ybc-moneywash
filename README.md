# WP Money Wash

A configurable **money laundering system for FiveM** built around **QBX Core**, **ox_inventory**, **ox_target**, and **ox_lib**.

WP Money Wash provides an immersive way for players to convert a configured dirty-money item into clean cash by depositing it into one of several washing stations. Processing takes a configurable amount of time based on the amount being washed.

## Features

- 💰 Configurable dirty-money item
- 🧼 Multiple independent washing stations
- 📦 Dedicated `ox_inventory` stash for every washer
- ⏱️ Processing time based on the amount being laundered
- 💵 Configurable dirty-to-clean conversion rate
- 🚪 Enter/exit teleport locations
- 🎯 `ox_target` interaction
- 🔔 `ox_lib` notifications
- 📧 Optional QB Phone completion notifications
- 📊 QBX logging support
- 🔐 Server-side processing and collection
- ⚙️ Fully configurable locations and messaging
- 🏢 Supports IPL/interior-based washing locations

## How It Works

Players approach one of the configured washing machines and interact with it through `ox_target`.

The basic flow is:

1. Player opens a washing machine.
2. Dirty money is deposited into the washer's inventory.
3. Player starts the washing process.
4. The script calculates the resulting clean money using the configured conversion rate.
5. The washer remains occupied while processing.
6. Once processing is complete, the dirty-money item is removed.
7. The resulting clean cash is stored as ready for pickup.
8. The player can return to the washer and collect the clean cash.

Each washer operates independently, allowing multiple players to use different washing stations at the same time.

## Conversion System

The amount of clean cash returned is controlled by:

```lua
conversionRate = 0.7
```

A value of `0.7` means the player receives **70% of the amount deposited**.

For example:

| Dirty Money | Conversion Rate | Clean Cash |
|---:|---:|---:|
| $1,000 | 70% | $700 |
| $5,000 | 70% | $3,500 |
| $10,000 | 70% | $7,000 |
| $20,000 | 70% | $14,000 |

The conversion rate can be changed in the configuration.

## Processing Times

Processing time is determined by the resulting clean-money amount.

| Clean Amount | Processing Time |
|---:|---:|
| $0–$5,000 | 1 minute |
| $5,001–$10,000 | 2 minutes |
| $10,001–$20,000 | 3 minutes |
| $20,001+ | 5 minutes |

These values are currently defined directly in the server-side washing logic.

## Washing Stations

The configuration currently provides **four washing stations**.

Three are located inside the configured Money Printing IPL/interior, while a fourth is configured at an exterior/alternate location.

Each washer maintains its own state:

```lua
washing = false
pickup = false
cleaned = 0
```

### Washer States

**Idle**

The washer is available for use.

**Washing**

A laundering process is currently active and the washer cannot be started again.

**Ready for Pickup**

The washing process has completed and the resulting clean cash is waiting to be collected.

After collection, the washer is reset and becomes available again.

## Configuration

The primary configuration is located in `config.lua`.

### Dirty Money Item

```lua
washableItem = 'black_money'
```

Change this to whatever item your server uses for dirty/illicit currency.

For example:

```lua
washableItem = 'dirty_money'
```

### Conversion Rate

```lua
conversionRate = 0.7
```

This determines how much clean money is returned.

Examples:

```lua
conversionRate = 0.5 -- 50%
conversionRate = 0.7 -- 70%
conversionRate = 0.8 -- 80%
conversionRate = 1.0 -- 100%
```

### Enter / Exit Locations

The script provides configurable teleport locations:

```lua
enterCoords = vector3(...)
exitCoords = vector3(...)
```

Players interact with the entrance and exit zones using `[E]`.

The script fades the screen out, moves the player to the destination, and fades the screen back in.

## Washer Configuration

Additional washers can be configured through the `washers` table.

Example:

```lua
washers = {
    [1] = {
        location = vector3(1123.78, -3193.92, -40.40),
        washing = false,
        pickup = false,
        cleaned = 0,
    },
}
```

Each washer receives its own `ox_inventory` stash automatically.

The stash is registered as:

```text
Washer #1
Washer #2
Washer #3
...
```

## Player Interaction

Washer interactions are handled through `ox_target`.

Players have access to options such as:

- **Open Washer**
- **Start Washing**
- **Collect From Washer**

A washer cannot be started while another laundering process is already running.

The script also checks the washer's state before allowing the player to open its inventory.

## Notifications

The resource uses `ox_lib` notifications for status messages.

Players are notified when:

- A washer is already running
- Washing begins
- Washing completes
- There is no money available to wash
- There is nothing ready to collect

## Phone Notifications

The resource can send QB Phone email notifications when laundering starts and finishes.

The sender and subject are configurable:

```lua
messageSender = 'Dry Cleaner'
messageSubject = 'Clothing Update'
```

The start and completion messages can also be customized.

The existing messages use a dry-cleaning theme to disguise the laundering process as a legitimate clothing service.

## Logging

Server-side actions are logged through the QBX logger.

The resource currently logs events including:

- Washing Started
- Washing Complete
- Money Retrieved

Logs can be sent through the configured Discord webhook/API logging functionality provided by QBX.

### Security Notice

**Never publish your Discord webhook URL publicly.**

If a webhook has been exposed through GitHub, Discord, screenshots, or a public resource release, revoke/rotate it before releasing the script.

## Dependencies

The resource is designed around the following FiveM resources:

- **QBX Core**
- **ox_lib**
- **ox_inventory**
- **ox_target**
- **qb-phone** — required if phone/email notifications are being used

Make sure these resources are started before WP Money Wash.

## Resource Flow

```text
Player
  │
  ▼
Enter Washing Location
  │
  ▼
Select Washer
  │
  ▼
Deposit Dirty Money
  │
  ▼
Start Washing
  │
  ▼
Server Calculates Conversion
  │
  ▼
Timed Processing
  │
  ▼
Dirty Money Removed
  │
  ▼
Clean Money Ready
  │
  ▼
Player Collects Cash
  │
  ▼
Washer Reset
```

## Example Configuration

```lua
Config = {
    washableItem = 'black_money',

    conversionRate = 0.7,

    enterCoords = vector3(...),
    exitCoords = vector3(...),

    washers = {
        [1] = {
            location = vector3(...),
            washing = false,
            pickup = false,
            cleaned = 0,
        },

        [2] = {
            location = vector3(...),
            washing = false,
            pickup = false,
            cleaned = 0,
        },
    },
}
```

## Recommended Server Setup

Ensure the resource dependencies are started first:

```cfg
ensure ox_lib
ensure qbx_core
ensure ox_inventory
ensure ox_target
ensure qb-phone

ensure wp-moneywash
```

Use the actual resource folder names from your server if they differ.

## Customization

The resource is designed to allow server owners to customize:

- Dirty-money item
- Conversion percentage
- Washer locations
- Number of washers
- Entrance location
- Exit location
- Processing messages
- Completion messages
- Phone notification sender
- Phone notification subject
- Debug zones
- Logging webhook

This makes it suitable for a variety of RP server economies and laundering locations.

## Credits

**WP Money Wash**

Developed for FiveM roleplay servers.

Built around:

- QBX Core
- ox_lib
- ox_inventory
- ox_target
- QB Phone

---

## License

Unless otherwise stated by the author, this resource is proprietary software.

Do not redistribute, resell, re-upload, or modify and redistribute this resource without permission from the original author.
