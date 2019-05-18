dofile('functs.lua') --carrega as funcoes
--verificacão serve para ver se já existe uma data
-- caso não existe ele configura uma. Funciona para o primeiro acesso do programa
-- assim que entrar vai pedir para configurar uma novo estoque.
a = io.open("data.lua","r")
if a == nil then
  local arq = io.open('data.lua',"w")
  local str = [[
    data = {}
    pos={x=0,y=0}
  ]]
  arq:write(str)
  arq:close()
  dofile("data.lua")
  configEstoque()
  go(pos.centerX,pos.centerY)
  save()
else
    dofile("data.lua")
    menu()
    --guardarTudo()
    go(pos.centerX,pos.centerY)
    save()
    menu()
end
