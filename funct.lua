--salva 
function save()
    arq = io.open("data.lua","w")
    arq:write("data={\n")
    --pegando todos os elementos da data

    for i,v in ipairs(data) do 
        arq:write("{")
        for k,val in pairs(data[i]) do
            if type(val) == type("a") then
                arq:write(k.."=".."\""..val.."\""..",")
            else
                arq:write(k.."="..tostring(val)..",")
            end
        end
        arq:write("},\n")
    end
    arq:write("}\n")
    --escrevendo a posicao do jogador
    arq:write("pos={\n")
    for k,v in pairs(pos) do
      arq:write(k.."="..tostring(v)..",")
    end
    arq:write("\n}")
    arq:close()

end
--coloca novo slot 
function new()
  table.insert(data,{})
  data[#data].type = ""
  data[#data].qtd = 0
  data[#data].x=0
  data[#data].y=0
end

--coloca um novo item nos slots segundo a capacidade
add = function(type, qtd)
  check()
  local jatem = false
  for i,v in ipairs(data) do
    if v.type == type then
      --vai para la e jogo lá dentro
      go(v.x,v.y) -- vai para la
      turtle.drop() --jogo lá dentro
      jatem = true
      v.qtd = v.qtd + qtd;
      save()
      break
    end
    if v.type == "" then
      --vai para la e jogo lá dentro
      go(v.x,v.y) -- vai para la
      turtle.drop() --jogo lá dentro 
      jatem = true
      v.type=type;
      v.qtd =  qtd;
      save()
      break
      
    end
  end
  if not jatem then 
      info()
      print("Não há vaga para: "..type..".")
  end
end

--ver se dar para realocar um slot quando qtd <= 0 e salva
check = function()
  local qtdslots = 0
  --todo slot com qtd = 0 pode ser novante realocado
  for i,v in ipairs(data) do
      if  v.qtd <=0 and v.type ~= ""  then
        v.type = ""
        qtdslots = qtdslots + 1
      end
  end
  if qtdslots > 0 then
    print(qtdslots.."  slots foram realocados.")
  end
  save()
end

-- nos passar algumas informaçoes dos slots
info = function()
  local total = #data
  local used = 0
  for i,v in ipairs(data) do
    if v.type ~= "" then
      used = used + 1
    end
  end

  print("Capacidade: "..used.." / "..total)
end

--faz o tranlado da turtle
function go(x,y)
    if x > pos.x then 
        local dif = x - pos.x
        turtle.turnRight()
        for i = 1,dif do 
            turtle.forward()
            pos.x = pos.x + 1;
        end
        turtle.turnLeft()
    elseif x < pos.x then
        local dif = pos.x - x;
        turtle.turnLeft()
        for i =1,dif do
            turtle.forward()
            pos.x = pos.x - 1;
        end
        turtle.turnRight()
    
    end

    if y > pos.y then 
        local dif = y- pos.y;
        for i =1,dif do 
            turtle.down()
            pos.y = pos.y + 1;
        end
    elseif y < pos.y then
        local dif = pos.y - y;
        for i =1,dif do 
            turtle.up()
            pos.y = pos.y - 1;
        end
    end
end

-- funcao principal para guardar todos os itens verificando todos os slots da turtle.
guardarTudo = function()
    girarEpegar()
    for slot = 1,16 do 
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item ~= nil then
            add(item.name,item.count)
        end
    end
end

--gira pega os itens e 'gira de volta'
function girarEpegar()
    turtle.turnLeft()
    turtle.turnLeft()
    for i =1,16 do 
      turtle.suck()
    end
    turtle.turnLeft()
    turtle.turnLeft()
end
--funcao prioridade 3 para usar na configEstoque
function showSlotsPositions(columns)
    --[[
      mostra como esta a disposicao dos slots com suas coordena
      das x e y.
      o x vai de 2 em 2 porque um bau nao fica do lado um do outro(olhando de lado)
      ex: 
      | 0,0 || 2,0 || 4,0 || 6,0 || 8,0 |
      | 0,1 || 2,1 || 4,1 || 6,1 || 8,1 |
      | 0,2 || 2,2 || 4,2 || 6,2 || 8,2 |
      | 0,3 || 2,3 || 4,3 || 6,3 || 8,3 |
    
    ]]
      local stringFinalConcatenada = ""
      --serve para pegar o tamanho da maior string para formatar depois
      local stringLargest = 0 
      for i,v in ipairs(data) do 
        local strLen = tostring(v.x..","..v.y)
        if #strLen > stringLargest then 
          stringLargest = #strLen
        end
      end
      --print("Maior tamnho de str",stringLargest)
      -- monta a string para exibir visualmente os baus e suas coordenadas
      for i,v in ipairs(data) do
        local strLen = #(tostring(v.x..","..v.y))
        local rep = stringLargest-strLen
        local strToAdd = string.rep(" ",rep)
        stringFinalConcatenada =  stringFinalConcatenada.."| "..v.x..","..v.y..strToAdd.." |"
        if i%columns == 0 then
          stringFinalConcatenada =  stringFinalConcatenada.."\n"
        end
      end
      print(stringFinalConcatenada)
end
  --funcao prioridade 2 para usar na configEstoque
setColunasDeSlots = function(columns)
    --[[
      Configura a quantidade de colunas em que os baus ficarao dispostos e atualiza suas respectivas coordenadas com base na quantidade de colunas. 
      ##Sempre o ponto 0,0 ficara no slot superior esquerdo.##
    ]]
    -- nao mexer  inicio--
    -- essa parte gera as novas coordenadas dos slots
    local y = 0
    local x = 0
    for i,v in ipairs(data) do --referente a y
      v.y = y
      v.x= x
      x=x+2
      if x==columns*2 then
        x=0;
        y=y+1 
      end
    end
     -- nao mexer  fim--
     showSlotsPositions(columns) --mostra como ficou
    --perguntar se quer salvar assim a configuracao
    print("Deseja salvar a nova configuracao ? s | n" )
    io.write("Esolha: ")
    local resposta = io.read()
    if resposta == "s" then
      print("Configuração atualizada.")
      --caso aceite ele salva as novas coordenadas
      save()
    else
      print("Cancelado ou escolha inválida.")
    end
end
  --funcao prioridade 1
function configEstoque()
    -- Ajuda a configurar os baus, slots, coordenadas etc...
    -- bom utilizar assim que montar a parte fisica do estoque
    print("#########################")
    print("## Configuração Guiada ##")
    print("#########################")
    print()
    io.write("Coloque o total de baus: ")
    local totalDeBaus = tonumber(io.read())
    io.write("Em quantas colunas que estão dispostos?: ")
    local colunas = tonumber(io.read())
    --local data = {}
    for i = 1,totalDeBaus do 
      new()
    end
    pos.centerX = math.floor(totalDeBaus/colunas)
    pos.centerY = math.floor(colunas)
    setColunasDeSlots(colunas)
end
  
