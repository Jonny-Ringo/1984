 -- Send Command with list of addresses

-- Send ({
--    Target = "target_process_id",
--    Action = "Distribute-Tokens",
--    TokenAddress = "token_address",
--    Addresses = [[
--        "address1",
--	      "address2",
--    ]]

--})

-- Handler for distributing tokens
Handlers.add(
    "DistributeTokens",
    function(m)
        return m.Action == "Distribute-Tokens"
    end,
    function(m)
        local addresses = m.Addresses
        local tokenAddress = m.TokenAddress
        local amount = "1000000000000000000000"  -- 1000 + 18 zeros (send 1000 tokens with 18 decimals)
        
        -- Validate inputs
        if not addresses then
            print("Error: No addresses provided")
            Send({
                Target = m.From,
                Data = "Error: Please provide addresses"
            })
            return
        end

        if not tokenAddress then
            print("Error: No token address specified")
            Send({
                Target = m.From,
                Data = "Error: Please specify the token address"
            })
            return
        end

        -- Counter for successful transfers
        local transferCount = 0

        -- Pattern to match addresses between quotes
        for address in addresses:gmatch('"([^"]+)"') do
            -- Send individual transfer for each address
            Send({
                Target = tokenAddress,
                Action = "Transfer",
                Recipient = address,
                Quantity = amount,
                ["X-Data"] = "Token distribution"
            })
                    
            print(string.format("Sent %s tokens to %s", amount, address))
            transferCount = transferCount + 1
        end
        
        -- Send confirmation to initiator
        Send({
            Target = m.From,
            Data = string.format("Distribution completed. Sent to %d addresses.", transferCount)
        })
    end
)


