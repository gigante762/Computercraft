dofile("guardar/data.lua") 
--inserindo valores na data
--dofile("save.lua")

--salva 
function save()
    arq = io.open("guardar/data.lua","w")
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
function new(x,y)
  table.insert(data,{})
  data[#data].type = ""
  data[#data].qtd = 0
  data[#data].x=x
  data[#data].y=y
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
--comente

  -- x > 0 até 3
  -- y > 0 até 4
 -- cria uma matriz de quadrada de 0,0 de x até 4,3 
 --[[
for y = 0,6,2 do 
   for x = 0,3 do 
     new(y,x)
  end
end
]]

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


guardarTudo = function()
  for slot = 1,16 do 
      turtle.select(slot)
      local item = turtle.getItemDetail()
      if item ~= nil then
          add(item.name,item.count)
      end
  end
end

--main
turtle.turnLeft()
turtle.turnLeft()
turtle.suck()
turtle.turnLeft()
turtle.turnLeft()
guardarTudo()
go(3,4)
save()
