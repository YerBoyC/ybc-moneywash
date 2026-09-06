Config = {
    webhook = '', -- Optional Discord webhook. Set your own webhook here; do not publish it in a public repository., -- logs to discord using qbx_core
    washableItem = 'black_money', -- any 'dark' currency that you want exchanged to normal cash
    enterCoords = vector3(-396.66, 6076.92, 31.5), -- entrance location for IPL
    exitCoords = vector3(1118.66, -3193.65, -40.39), -- exit location for IPL
    messageSender = 'Dry Cleaner', -- email notification sender 
    messageSubject = 'Clothing Update', -- email notification subject
    -- email message body when you start washing
    startMessage = 'We received your clothing. We will be in touch when it is ready for pickup. This could take between 1 and 10 minutes based on the amount of clothing. <br /> <br /> - Wiwang Dry Cleaning',
    -- email message body when washing is complete
    readyMessage = 'Please pick this up ASAP as I will NOT hold for you. <br /> If someone claims the clothing, not my problem..  <br /> <br /> - Wiwang Dry Cleaning',
    debugPoly = false, -- for debugging purposes
    conversionRate = 0.7, -- 70% conversion rate from dirty to clean. this would be your clean money returned to you.
    washers = {
        -- Money Printing IPL
        [1] = { 
            location = vector3(1123.78, -3193.92, -40.40),
            washing = false,
            pickup = false,
            cleaned = 0,
        },
        [2] = {
            location = vector3(1125.49, -3193.98, -40.40),
            washing = false,
            pickup = false,
            cleaned = 0,
        },
        [3] = {
            location = vector3(1126.99, -3193.99, -40.40),
            washing = false,
            pickup = false,
            cleaned = 0,
        },

        -- abandoned laundry MLO
        [4] = {
            location = vector3(1135.15, -988.17, 46.1),
            washing = false,
            pickup = false,
            cleaned = 0,
        },
    },
}