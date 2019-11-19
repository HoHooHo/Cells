rc4 = {}

local function permut(clef)
    local i,j = 0,0
    local cle = {}
    local tempo = 0
    local long = string.len(clef)
    local S = {}
    for i = 0, long - 1 do
        cle[i] = string.byte(string.sub(clef,i+1,i+1))
    end
    for i = 0, 255 do
        S[i] = i
    end
    for i = 0,255 do
        j = (j+ S[i] + cle[i % long]) % 256
        tempo = S[i]
        S[i] = S[j]
        S[j] = tempo
    end
    return S
end

local function dec(binaire)
    local i
    local result = 0
    local mul = 1
    for i = 8,1,-1 do
        result = result + (binaire[i]* mul)
        mul = mul *2
    end
    return result
end

local function binaire(octet)
    local B = {}
    local div = 128
    local i = 1
    while (i < 9) do
        B[i] = math.floor(octet/div)
        if B[i] == 1 then octet = octet-div end
        div = div / 2
        i = i +1
    end
    return B
end

local function XOR(octet1, octet2)
    local O1 = {}
    local O2 = {}
    local result = {}
    local i
    O1 = binaire(octet1)
    O2 = binaire(octet2)
    for i= 1,8 do
        if(O1[i] == O2[i]) then
            result[i] = 0
        else
            result[i] = 1
        end
    end
    return dec(result)
end


function rc4.new( clef )
    local arc4 = {}
    local index1 = 0
    local index2 = 0

    local S = permut(clef)

    arc4.code = function(texte)
        local i = 0
        local text = {}
        local maxcara = string.len(texte)
        local code = {}
        local tempo = 0
        local o_chif = 0
        local result = ""
        local cpt = 1
        for i= 1, maxcara do
            text[i] = string.byte(string.sub(texte,i,i))
        end
        while cpt<maxcara+1 do
            index1 = (index1+1)%256
            index2 = (index2+S[index1])%256
            tempo = S[index1]
            S[index1] = S[index2]
            S[index2] = tempo
            o_chif = S[(S[index1]+S[index2])%256]
            result = result..string.char(XOR(o_chif,text[cpt]))
            cpt = cpt+1
        end
        return result
    end

    return arc4
end

return rc4
