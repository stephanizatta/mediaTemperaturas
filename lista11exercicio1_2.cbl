      $set sourceformat"free"

      *>Divis�o de identifica��o do programa - CORRIGIR
       identification division.
       program-id. "lista11exercicio1_2".
       author. "Stephani S. Zatta".
       installation. "PC".
       date-written. 08/07/2020.
       date-compiled. 24/07/2020.

      *>------------------------------------------------------------------------
      *>Divis�o para configura��o do ambiente
       environment division.

      *>------------------------------------------------------------------------
       configuration section.
           special-names. decimal-point is comma.

      *>------------------------------------------------------------------------
      *>---Declara��o de recursos externos
       input-output section.
       file-control.

           select arqTemp assign to "arqTemp.txt" *> assiciando arquivo logico (nome dado ao arquivo do programa com o arquivo fisico)
           organization is line sequential                    *> forma de organiza��o dos dados
           access mode is sequential                          *> forma de acesso aos dados
        *> todos os programas que forem feitos com arquivos, usar a condi��o abaixo (lock mode)
           lock mode is automatic                             *> dead lock, evita a perda de informa��es
           file status is ws-fs-arqTemp.                *> file status (o status da ultima opera��o)

       i-o-Control.

      *>------------------------------------------------------------------------
      *>---Declara��o de vari�veis
       data division.

      *>------------------------------------------------------------------------
      *>---Vari�veis de arquivos
       file section.
       fd arqTemp. *> inico da declara��o das variaveis do arquivo
       01  fd-temperaturas.   *> layout do arquivo propriamente dito / layout do registro do arquivo
           05 fd-temp                              pic s9(02)v99.

      *>------------------------------------------------------------------------
      *>---Vari�veis de trabalho
       working-storage section.

       77  ws-fs-arqTemp                           pic  9(02).

       01  temperaturas occurs 30.
           05 ws-temp                              pic s9(02)v99.

       01 variaveis_numericas.
           05 soma_temp                            pic s9(04)v99.
           05 media_temp                           pic s9(02)v99.

       77 ind                                      pic 9(02).
       77 dia                                      pic 9(02).
       77 menu                                     pic x(01).

       01 mensagens.
          05 ws-msn-erro.
             10 ws-msn-erro-ofsset                 pic 9(04).
             10 filler                             pic x(01) value "-".
             10 ws-msn-erro-cod                    pic 9(02).
             10 filler                             pic x(01) value "-".
             10 ws-msn-text                        pic x(42). *> 04+02+01+01+42=50

      *>------------------------------------------------------------------------
      *>---Vari�veis para comunica��o entre programas
       linkage section.

      *>------------------------------------------------------------------------
      *>---Declara��o de tela
       screen section.

      *>------------------------------------------------------------------------
      *>Declara��o do corpo do programa
       procedure division.

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicializa��o
      *>------------------------------------------------------------------------
       inicializa section.

           *> caso d� erro ao abrir o arquivo
           open input arqTemp
           if ws-fs-arqTemp <> 0 then
               move 1                                     to ws-msn-erro-ofsset
               move ws-fs-arqTemp                 to ws-msn-erro-cod
               move "Erro ao abrir arq. estacosCapitais " to ws-msn-text
               perform finaliza-anormal
           end-if

           perform varying ind from 1 by 1 until ws-fs-arqTemp = 10
                                                     or ind > 30
               *> caso d� erro ao ler o arquivo
               read arqTemp into temperaturas(ind)
               if ws-fs-arqTemp <> 0
               and ws-fs-arqTemp <> 10 then
                   move 2                                   to ws-msn-erro-ofsset
                   move ws-fs-arqTemp                       to ws-msn-erro-cod
                   move "Erro ao ler arq. estacosCapitais " to ws-msn-text
                   perform finaliza-anormal
               end-if

           end-perform

         *> caso d� erro ao fechar arquivo
           close arqTemp
           if ws-fs-arqTemp <> 0 then
               move 3                                      to ws-msn-erro-ofsset
               move ws-fs-arqTemp                          to ws-msn-erro-cod
               move "Erro ao fechar arq. estacosCapitais " to ws-msn-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

           perform calculo-temp-media

           perform until menu = "S"
               display erase

               display "Informe o dia que voce deseja consultar (01-30): "
               accept dia

               if dia > 30
               or < 1 then
                   display "Dia invalido!!!"
                   display "Intervalo de dias disponiveis: 1 - 30"
               else
                   if ws-temp(dia) > media_temp then              *> caso a temperatura esteja acima da media
                       display "A temperatura esta acima da media."
                       display "Dia " dia ", temperatura: " ws-temp(dia) "C."
                   else
                       if ws-temp(dia) < media_temp then          *>caso a temperatura esteja abaixo da media
                           display "A temperatura esta abaixo a media."
                           display "Dia " dia ", temperatura: " ws-temp(dia) "C."
                       else                                    *>caso a temperatura esteja igual a media
                           display "A temperatura esta igual a media."
                           display "Dia " dia ", temperatura: " ws-temp(dia) "C."
                       end-if

                   end-if
               end-if

               display "Informe 'C' para continuar ou 'S' para sair."
               accept menu

           end-perform
           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Calculo da media da temperatura
      *>------------------------------------------------------------------------
       calculo-temp-media section.

           move 0 to soma_temp
           perform varying ind from 1 by 1 until ind > 30
               compute soma_temp = soma_temp + ws-temp(ind)
           end-perform

           compute media_temp = soma_temp / 30
           .
       calculo-temp-media-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Finaliza��o anormal - causada por erro
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro

           stop run
           .
       finaliza-anormal-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Finaliza��o normal
      *>------------------------------------------------------------------------
       finaliza section.
          stop run.
          .
       finaliza-exit.
           exit.





