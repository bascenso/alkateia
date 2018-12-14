
        var finalidade = [];
        var finalidade_id = {};
        var finalidade_id_reverse = {};
        var all_detalhe_finalidade = [];
        var detalhe_finalidade = {};
        var detalhe_finalidade_id_reverse = {};
        var finalidades = JSON.parse('[{"description":"Exercício de profissão ou atividade de natureza pública","finalidade_id":1},
        {"description":"Exercício de profissão ou atividade de natureza privada","finalidade_id":2},
        {"description":"Inscrição em ordem profissional","finalidade_id":3},
        {"description":"Outras finalidades","finalidade_id":4},
        {"description":"Ver todas as finalidades","finalidade_id":-1}]');
        
        var detalhes_finalidades = JSON.parse('[{"description":"Acesso a zonas reservadas","finalidade_id":4,"detalhe_finalidade_id":3},
        {"description":"Acesso ao respetivo registo (art.35cr)","finalidade_id":4,"detalhe_finalidade_id":63290},
        {"description":"Administrador judicial","finalidade_id":1,"detalhe_finalidade_id":154},
        {"description":"Admissão a guarda - noturno","finalidade_id":2,"detalhe_finalidade_id":14},
        {"description":"Admissão a guarda - prisional","finalidade_id":1,"detalhe_finalidade_id":15},
        {"description":"Admissão a polícia de segurança pública","finalidade_id":1,"detalhe_finalidade_id":17},
        {"description":"Admissão a polícia marítima","finalidade_id":1,"detalhe_finalidade_id":16},
        {"description":"Admissão/promoção a guarda nacional republicana","finalidade_id":1,"detalhe_finalidade_id":18},
        {"description":"Adoção","finalidade_id":4,"detalhe_finalidade_id":63291},{"description":"Agente oficial da propriedade industrial","finalidade_id":2,"detalhe_finalidade_id":20},{"description":"Alvará de empresa de trabalho temporário","finalidade_id":2,"detalhe_finalidade_id":21},{"description":"Alvará de escola de condução","finalidade_id":2,"detalhe_finalidade_id":22},{"description":"Alvará de transporte de doentes","finalidade_id":2,"detalhe_finalidade_id":25},{"description":"Apadrinhamento civil","finalidade_id":4,"detalhe_finalidade_id":63298},{"description":"Aplicação do regime juridico das armas e munições","finalidade_id":4,"detalhe_finalidade_id":27},{"description":"Aquisição de nacionalidade portuguesa","finalidade_id":4,"detalhe_finalidade_id":28},{"description":"Asilo político","finalidade_id":4,"detalhe_finalidade_id":29},{"description":"Ativ. De assistência em escala em tráfego aéreo","finalidade_id":2,"detalhe_finalidade_id":6},{"description":"Ativ. De centro de inspeção periódica de veículos","finalidade_id":2,"detalhe_finalidade_id":4},{"description":"Ativ. Prestação serviços com veículos pronto socorro","finalidade_id":2,"detalhe_finalidade_id":9},{"description":"Atividade de agente de navegação","finalidade_id":2,"detalhe_finalidade_id":63316},{"description":"Atividade de concentrador de zona","finalidade_id":2,"detalhe_finalidade_id":7},{"description":"Atividade de corretagem","finalidade_id":2,"detalhe_finalidade_id":8},{"description":"Atividade de manutenção/inspeção de elevadores e afins","finalidade_id":2,"detalhe_finalidade_id":144},{"description":"Atividade de prestamista","finalidade_id":2,"detalhe_finalidade_id":10},{"description":"Atividade de rent-a-car","finalidade_id":2,"detalhe_finalidade_id":63314},{"description":"Atividade de transporte de crianças","finalidade_id":2,"detalhe_finalidade_id":11},{"description":"Atividade de transporte de crianças-motorista","finalidade_id":2,"detalhe_finalidade_id":12},{"description":"Atividade de transporte de crianças-vigilante","finalidade_id":2,"detalhe_finalidade_id":13},{"description":"Atividade leiloeira","finalidade_id":2,"detalhe_finalidade_id":63299},{"description":"Autorização para armazém de exportação","finalidade_id":2,"detalhe_finalidade_id":31},{"description":"Candidatos a árbitros desportivos","finalidade_id":2,"detalhe_finalidade_id":32},{"description":"Candidatura a ajudante de farmácia","finalidade_id":2,"detalhe_finalidade_id":33},{"description":"Candidatura a auxiliar de farmácia","finalidade_id":2,"detalhe_finalidade_id":34},{"description":"Candidatura a deputado","finalidade_id":1,"detalhe_finalidade_id":35},{"description":"Candidatura a família de acolhimento","finalidade_id":4,"detalhe_finalidade_id":37},{"description":"Candidatura a presidência da república","finalidade_id":1,"detalhe_finalidade_id":38},{"description":"Candidatura ao conselho das comunidades portuguesas","finalidade_id":4,"detalhe_finalidade_id":145},{"description":"Candidatura às eleições autárquicas","finalidade_id":1,"detalhe_finalidade_id":36},{"description":"Carta de caçador","finalidade_id":2,"detalhe_finalidade_id":39},{"description":"Cartão de acesso sala de trânsito internac.Aerop.","finalidade_id":4,"detalhe_finalidade_id":40},{"description":"Casinos-membro direção/orgão social concessionária","finalidade_id":2,"detalhe_finalidade_id":41},{"description":"Cédula de operador explosivos","finalidade_id":2,"detalhe_finalidade_id":42},{"description":"Certificação de entidades formadoras","finalidade_id":2,"detalhe_finalidade_id":63315},{"description":"Comércio europeu de licenças de emissão - verificador ","finalidade_id":2,"detalhe_finalidade_id":146},{"description":"Concessão de medalha militar/medalhas comemorativas","finalidade_id":4,"detalhe_finalidade_id":44},{"description":"Concessão de visto em passaporte","finalidade_id":4,"detalhe_finalidade_id":45},{"description":"Constituição de armazém de domiciliação","finalidade_id":2,"detalhe_finalidade_id":48},{"description":"Constituição de empresa de seguros","finalidade_id":2,"detalhe_finalidade_id":49},{"description":"Constituição de entreposto fiscal","finalidade_id":2,"detalhe_finalidade_id":50},{"description":"Constituição instituição crédito/sociedade financeira","finalidade_id":2,"detalhe_finalidade_id":51},{"description":"Contratação pública (código dos contratos públicos)","finalidade_id":2,"detalhe_finalidade_id":142},{"description":"Credenciação industrial","finalidade_id":2,"detalhe_finalidade_id":52},{"description":"Credenciação otan","finalidade_id":4,"detalhe_finalidade_id":53},{"description":"Despachante oficial/ajudante/declarante","finalidade_id":2,"detalhe_finalidade_id":54},{"description":"Diamantes em bruto - processo kimberly","finalidade_id":2,"detalhe_finalidade_id":63313},{"description":"Diretiva 64/221/cee","finalidade_id":4,"detalhe_finalidade_id":55},{"description":"Diretor de armazém de farmácia","finalidade_id":2,"detalhe_finalidade_id":56},{"description":"Diretor de escola de condução","finalidade_id":2,"detalhe_finalidade_id":57},{"description":"Diretor de parque zoológico","finalidade_id":2,"detalhe_finalidade_id":153},{"description":"Diretor técnico de farmácia ou laboratório/adjunto","finalidade_id":2,"detalhe_finalidade_id":58},{"description":"Dispensa de prestação de garantia- dl 249/2009","finalidade_id":4,"detalhe_finalidade_id":150},{"description":"Emissão de certif. Conformidade de projetos de obras","finalidade_id":2,"detalhe_finalidade_id":59},{"description":"Empreiteiro de obras públicas/particulares","finalidade_id":2,"detalhe_finalidade_id":63300},{"description":"Estabelecimento de apoio social-licenciamento/emprego","finalidade_id":2,"detalhe_finalidade_id":60},{"description":"Estatuto de igualdade de direitos","finalidade_id":4,"detalhe_finalidade_id":61},{"description":"Estatuto de operador registado ( I .A.)","finalidade_id":2,"detalhe_finalidade_id":62},{"description":"Examinador de condução automóvel","finalidade_id":2,"detalhe_finalidade_id":63},{"description":"Exercício da atividade de segurança privada","finalidade_id":2,"detalhe_finalidade_id":64},{"description":"Exercício de profissão/atividade no estrangeiro","finalidade_id":2,"detalhe_finalidade_id":66},{"description":"Exoneração do passivo restante","finalidade_id":4,"detalhe_finalidade_id":67},{"description":"Explosivos-fabrico/armazenagem/comércio","finalidade_id":2,"detalhe_finalidade_id":68},{"description":"Fixação de residência em portugal","finalidade_id":4,"detalhe_finalidade_id":70},{"description":"Fixação de residência no estrangeiro","finalidade_id":4,"detalhe_finalidade_id":69},{"description":"Função pública","finalidade_id":1,"detalhe_finalidade_id":71},{"description":"Gestores de empresas públicas","finalidade_id":1,"detalhe_finalidade_id":147},{"description":"Impressão de documentos de transporte/facturas","finalidade_id":2,"detalhe_finalidade_id":72},{"description":"Indústria/comércio de armamento","finalidade_id":2,"detalhe_finalidade_id":73},{"description":"Instrutor de condução","finalidade_id":2,"detalhe_finalidade_id":79},{"description":"Internato médico","finalidade_id":1,"detalhe_finalidade_id":151},{"description":"Juiz de paz/mediador","finalidade_id":1,"detalhe_finalidade_id":81},{"description":"Juíz militar/assessor militar do ministério público","finalidade_id":1,"detalhe_finalidade_id":80},{"description":"Licença de exploração transporte aéreo","finalidade_id":2,"detalhe_finalidade_id":85},{"description":"Licença de inspetor de veículo a motor","finalidade_id":2,"detalhe_finalidade_id":86},{"description":"Licença detenção animal perigoso/potencialmente perig.","finalidade_id":4,"detalhe_finalidade_id":84},{"description":"Licenciamento de unidade de saúde privada","finalidade_id":4,"detalhe_finalidade_id":87},{"description":"Licenciamento venda de bilhetes p/espetáculos públicos","finalidade_id":2,"detalhe_finalidade_id":88},{"description":"Mediação de seguros/resseguros","finalidade_id":2,"detalhe_finalidade_id":90},{"description":"Mediação imobiliária/angariação imobiliária","finalidade_id":2,"detalhe_finalidade_id":89},{"description":"Mediador dos jogos sociais do estado","finalidade_id":2,"detalhe_finalidade_id":91},{"description":"Membro de órgão de admin./fisc. Caixa crédito agrícola","finalidade_id":2,"detalhe_finalidade_id":92},{"description":"Membro de órgão social de empresa de seguros","finalidade_id":2,"detalhe_finalidade_id":94},{"description":"Membro órgão de admin./fisc. Em inst. Crédito/soc. Fin.","finalidade_id":2,"detalhe_finalidade_id":93},{"description":"Mercado lícito de estupefacientes/subst.Psicotrópicas","finalidade_id":2,"detalhe_finalidade_id":95},{"description":"Monitor de curso de formação de ensino de condução","finalidade_id":2,"detalhe_finalidade_id":96},{"description":"Motorista de táxi/veículos de passageiros","finalidade_id":2,"detalhe_finalidade_id":63301},{"description":"Objetor de consciência","finalidade_id":4,"detalhe_finalidade_id":63294},{"description":"Obtençao de nacionalidade estrangeira","finalidade_id":4,"detalhe_finalidade_id":97},{"description":"Ordem dos advogados","finalidade_id":3,"detalhe_finalidade_id":63302},{"description":"Ordem dos contabilistas certificados","finalidade_id":3,"detalhe_finalidade_id":63303},{"description":"Ordem dos despachantes oficiais","finalidade_id":3,"detalhe_finalidade_id":63304},{"description":"Ordem dos enfermeiros","finalidade_id":3,"detalhe_finalidade_id":63305},{"description":"Ordem dos farmacêuticos","finalidade_id":3,"detalhe_finalidade_id":63306},{"description":"Ordem dos médicos","finalidade_id":3,"detalhe_finalidade_id":63307},{"description":"Ordem dos médicos dentistas","finalidade_id":3,"detalhe_finalidade_id":63308},{"description":"Ordem dos notários","finalidade_id":3,"detalhe_finalidade_id":63309},{"description":"Ordem dos nutricionistas","finalidade_id":3,"detalhe_finalidade_id":63310},{"description":"Ordem dos revisores oficiais de contas","finalidade_id":3,"detalhe_finalidade_id":63311},{"description":"Ordem dos solicitadores e dos agentes de execução","finalidade_id":3,"detalhe_finalidade_id":63312},{"description":"Pensão de ex-prisioneiro de guerra","finalidade_id":4,"detalhe_finalidade_id":98},{"description":"Pensão mérito excecional p/liberdade e democracia","finalidade_id":4,"detalhe_finalidade_id":63292},{"description":"Pensão por serviços excecionais e relevantes","finalidade_id":4,"detalhe_finalidade_id":63293},{"description":"Permanência de estrangeiro em portugal","finalidade_id":4,"detalhe_finalidade_id":101},{"description":"Pessoal das salas de jogo do bingo","finalidade_id":2,"detalhe_finalidade_id":102},{"description":"Prestação de serviço efetivo nas forças armadas","finalidade_id":1,"detalhe_finalidade_id":103},{"description":"Prestação de serviços de transporte ferroviário","finalidade_id":2,"detalhe_finalidade_id":104},{"description":"Processo de alteração de nome","finalidade_id":4,"detalhe_finalidade_id":105},{"description":"Profissão/atividade sem Lei especial - Lei 37/2015","finalidade_id":2,"detalhe_finalidade_id":106},{"description":"Profissional de banca nos casinos","finalidade_id":2,"detalhe_finalidade_id":107},{"description":"Promoção de atos de registo de veículos","finalidade_id":2,"detalhe_finalidade_id":108},{"description":"Reabilitação judicial","finalidade_id":4,"detalhe_finalidade_id":109},{"description":"Reconhecimento de união de facto","finalidade_id":4,"detalhe_finalidade_id":110},{"description":"Registo de auditores na cmvm","finalidade_id":2,"detalhe_finalidade_id":111},{"description":"Registo de sociedades de risco (rating)","finalidade_id":2,"detalhe_finalidade_id":113},{"description":"Registo instituição crédito/sociedade financeira","finalidade_id":2,"detalhe_finalidade_id":112},{"description":"Sociedades financeiras para aquisição a crédito","finalidade_id":2,"detalhe_finalidade_id":116},{"description":"Sócio/gerente/administrador de escola de condução","finalidade_id":2,"detalhe_finalidade_id":117},{"description":"Sub-diretor de escola de condução","finalidade_id":2,"detalhe_finalidade_id":118},{"description":"Titular de órgão de federação desportiva","finalidade_id":2,"detalhe_finalidade_id":148},{"description":"Trabalhador portuário","finalidade_id":2,"detalhe_finalidade_id":119},{"description":"Transporte rodov. De mercadorias p/conta de outrém","finalidade_id":2,"detalhe_finalidade_id":120},{"description":"Transporte rodov. De passageiros em veículos pesados","finalidade_id":2,"detalhe_finalidade_id":121},{"description":"Tripulante de ambulância","finalidade_id":2,"detalhe_finalidade_id":122},{"description":"Troca carta de condução estrangeira","finalidade_id":4,"detalhe_finalidade_id":123},{"description":"Voluntariado","finalidade_id":4,"detalhe_finalidade_id":124}]');
        for(var i = 0; i < finalidades.length; i++) {
            finalidade.push(finalidades[i]['description']);
            detalhe_finalidade[finalidades[i]['description']] = [];
            finalidade_id[finalidades[i]['finalidade_id']] = finalidades[i]['description'];
            finalidade_id_reverse[finalidades[i]['description']] = finalidades[i]['finalidade_id'];
        }
        for(var c = 0; c < detalhes_finalidades.length; c++) {
            all_detalhe_finalidade.push(detalhes_finalidades[c]['description']);
            detalhe_finalidade[finalidade_id[detalhes_finalidades[c]['finalidade_id']]].push(detalhes_finalidades[c]['description']);
            detalhe_finalidade_id_reverse[detalhes_finalidades[c]['description']] = detalhes_finalidades[c]['detalhe_finalidade_id'];
        }


        

        $(document).ready(function() {


            $('#certidaopermanente').mask('0000-0000-0000', { translation: { 'Z': { pattern: /[a-z0-9]/ } } });


            jQuery.extend(jQuery.validator.messages, {
                required: 'Preenchimento necessário'
            });


            jQuery.validator.addMethod("nipc_format", function(value, element) {

                if (value.length != 9) {

                    return false;

                } else {

                    var nifSplit = value.split('');

                    if(nifSplit[0] != '5' && nifSplit[0] != '6' && nifSplit[0] != '7' && nifSplit[0] != '8' && nifSplit[0] != '9') {

                        return false;
                    }


                    var checkDigit = 0;

                    for(i=0; i<8; i++) {

                        checkDigit += Number(nifSplit[i])*(10-i-1);
                    }

                    checkDigit = checkDigit % 11;

                    if(checkDigit == 0 || checkDigit == 1) checkDigit=0;
                    else checkDigit = 11 - checkDigit;

                    if ( checkDigit == nifSplit[8]) {
                    
                        return true;

                    }

                    return false;
                }

            }, "Formato inválido");


            
            $.validator.addMethod("customemail", function(value, element) {
                    
                    return /^.+@.+\..+$/i.test(value);
                }, 
                "Preenchimento incorreto"
            );


            jQuery.validator.addMethod("finalidade_exists", function(value, element) {
                
                if(finalidade.indexOf(value) == -1) return false;
                else return true;

            }, 'Preenchimento incorreto');


            jQuery.validator.addMethod("detalhe_finalidade_exists", function(value, element) {
                
                if($("#pedido_finalidade").val() != '') {

                        if(typeof detalhe_finalidade[$("#pedido_finalidade").val()] != "undefined") {

                        if(detalhe_finalidade[$("#pedido_finalidade").val()].indexOf(value) == -1 && all_detalhe_finalidade.indexOf(value)== -1) return false;
                        else return true;

                    }

                }

                return false;

            }, 'Preenchimento incorreto');


            
            jQuery.validator.addMethod("certidao_format", function(value, element) {
                
                return /^[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}$/i.test(value);

            }, 'Preenchimento incorreto');

            jQuery.validator.addMethod("certidao_pending", function(value, element) {
                
                var ok = $(".certidao-group").find('.glyphicon-refresh');
                if(ok.length == 1) return false;
                else return true;

            }, 'Preenchimento incorreto');



            jQuery.validator.addMethod("denominacao", function(value, element) {

                if($("#pedido_denominacao").val() != '') return true;
                else return false;

            }, 'Preenchimento incorreto');
            
            

            $("#pedido_nipc").keyup(function() { if($(this).val().length == 9) { denominacaoSocial(); } });


            $("input[type=radio]").click(function(){

                $(this).valid();
            });

            $('#formPedido').validate({

                onkeyup: false,

                errorClass:'help-block with-errors',
                errorElement:'div',

                errorPlacement: function(error, element) {
                    
                    //console.log(error, element);

                    if ($(element).is(':radio')) {

                        var e = $(element).parents('.radioParent');

                        error.appendTo(e);

                    } else {

                        error.insertAfter(element);
                    }
                },

                highlight: function (element, errorClass, validClass) {


                    if($('span.glyphicon-refresh', $(element).parents("div.form-group")).length == 0) {

                        $(element).parents("div.form-group").addClass('has-error').removeClass('has-success');
                        $('span.glyphicon', $(element).parents("div.form-group")).remove();
                        

                        if($(element).is(':radio')) {

                            var t = $(element).parents('.radioParent');

                            $('.radio-inline:last', t).after('<span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>');
                        }
                        else {
                            $(element).after('<span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>');
                        }

                    }



                    // Get denominacao social
                    if($(element).attr('id') == 'pedido_nipc') {

                        $("#pedido_denominacao").val('');
                    }


                }, 
                unhighlight: function (element, errorClass, validClass) { 


                    if($('span.glyphicon-refresh', $(element).parents("div.form-group")).length == 0) {


                        $(element).parents("div.form-group").addClass('has-success').removeClass('has-error');
                        $('span.glyphicon', $(element).parents("div.form-group")).remove();
                        
                        if($(element).is(':radio')) {

                            var t = $(element).parents('.radioParent');

                            $('.radio-inline:last', t).after('<span class="glyphicon glyphicon-ok form-control-feedback" aria-hidden="true"></span>');
                        }
                        else {
                            $(element).after('<span class="glyphicon glyphicon-ok form-control-feedback" aria-hidden="true"></span>');
                        }
                    }

                },

                rules: {

                    finalidade_input: {
                        required:true,
                        finalidade_exists: true
                    },

                    detalhe_finalidade_input: {
                        required:true,
                        detalhe_finalidade_exists:true
                    },

                    funcao: {
                        maxlength: 80,
                        required: function(){

                            if($(".pedido_especificacao_fundao_parent_row").css('display') != 'none') return true;
                            else return false;
                        }
                    },

                    entidade: {

                        required: function(){

                            if($(".pedido_especificacao_fundao_parent_row").css('display') != 'none') return true;
                            else return false;
                        }
                    },

                    local_trabalho: {

                        required: function(){

                            if($(".pedido_especificacao_fundao_parent_row").css('display') != 'none') return true;
                            else return false;
                        }
                    },

                    contacto_menores: {
                        required:true
                    },

                    email: {
                        required: true,
                        customemail: true
                    },

                    confirmar_email: {
                        required: true,
                        equalTo: "#pedido_email"
                    },

                    tipo_certificado: {
                        required: true
                    },

                    nipc: {

                        required: function(){

                            if($("#tipo_colectiva:checked")) return true;
                            else return false;
                        },
                        nipc_format: true,
                        denominacao:true
                    },

                    certidaopermanente: {

                        required: function() {

                            if($("#tipo_colectiva:checked")) return true;
                            else return false;
                        },
                        
                        certidao_format: true,
                        certidao_pending: true,

                        remote: {
                            url:'/services/certidaopermanente',
                            beforeSend: function() {

                                $('span.glyphicon', $("#certidaopermanente").parent()).remove();

                                $("#certidaopermanente").after('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate form-control-feedback"></span>');
                            },
                            complete: function() {

                                $('span.glyphicon-refresh', $("#certidaopermanente").parent()).remove();

                                $("#certidaopermanente").valid();
                            }
                        }

                    },


                },
                messages: {
                    email: {
                      email: 'Preenchimento incorreto'
                    },
                    confirmar_email: {
                        equalTo: 'Preenchimento incorreto'
                    },
                    pedido_denominacao: {

                        required: 'Ocorreu um erro'
                    },
                    certidaopermanente: {

                        remote: 'Preenchimento incorreto'
                    },
                    funcao: {
                        maxlength: 'Utilize no máximo 80 caracteres'
                    }
                }


            });


            var substringMatcher = function(strs) {

                return function findMatches(q, cb) {
                    var matches, substringRegex;

                    // an array that will be populated with substring matches
                    matches = [];

                    // regex used to determine if a string contains the substring `q`
                    substrRegex = new RegExp(q, 'i');

                    // iterate through the pool of strings and for any string that
                    // contains the substring `q`, add it to the `matches` array
                    $.each(strs, function(i, str) {
                      if (substrRegex.test(str)) {
                        matches.push(str);
                      }
                    });

                    cb(matches);
                }
            }

            

            $(function () {
                $('[data-toggle="tooltip"]').tooltip()
            });


            


            $('#pedido_finalidade').typeahead({
                minLength:0
            },
            {
              name: 'finalidade',
              source: substringMatcher(finalidade),
              limit:136
            });


            var detalhe_finalidade_type = [];


            $('#pedido_finalidade').bind('typeahead:change', function(ev, suggestion) {

                if($('#pedido_finalidade').val() == '') {

                    $("#pedido_detalhe_finalidade").val('');
                }
            });


            $('#pedido_finalidade').bind('typeahead:select typeahead:autocomplete', function(ev, suggestion) {
            
                var set_finalidade = Number(finalidade_id_reverse[suggestion]);

                $("#finalidade_hidden").val(set_finalidade);

                $("#pedido_detalhe_finalidade").val('');

                if((set_finalidade == 1 && detalhe_finalidade_id_reverse[$("#pedido_detalhe_finalidade").val()] == 71) ||
                    (set_finalidade == -1 && detalhe_finalidade_id_reverse[$("#pedido_detalhe_finalidade").val()] == 71)) {

                    $(".pedido_especificacao_fundao_parent_row").show();

                } else if((set_finalidade == 2 && detalhe_finalidade_id_reverse[$("#pedido_detalhe_finalidade").val()] == 106) ||
                            (set_finalidade == -1 && detalhe_finalidade_id_reverse[$("#pedido_detalhe_finalidade").val()] == 106)) {

                    $(".pedido_especificacao_fundao_parent_row").show();

                } else {

                    $("#pedido_especificacao_funcao").val('');
                    $(".pedido_especificacao_fundao_parent_row").hide();

                }

                if(typeof detalhe_finalidade[finalidade_id[set_finalidade]] != "undefined") {

                    $("#detalhe_finalidade_hidden").val('');

                    if(set_finalidade == -1) {
                        detalhe_finalidade_type = all_detalhe_finalidade;
                    } else {
                        detalhe_finalidade_type = detalhe_finalidade[finalidade_id[set_finalidade]];
                    }

                    $("#pedido_detalhe_finalidade").typeahead('destroy');


                    $("#pedido_detalhe_finalidade").typeahead({
                        minLength:0
                    },
                    {
                      name: 'detalhe_finalidade',
                      source: substringMatcher(detalhe_finalidade_type),
                      limit:136
                    });


                    $(".pedido_detalhe_finalidade_parent_row").show();


                } else {

                    detalhe_finalidade_type = [];

                    $(".pedido_detalhe_finalidade_parent_row").hide();

                }


            });



            $("#pedido_detalhe_finalidade").bind('typeahead:select typeahead:autocomplete', function(ev, suggestion) {

                var set_finalidade = finalidade_id_reverse[$("#pedido_finalidade").val()];

                $("#detalhe_finalidade_hidden").val(detalhe_finalidade_id_reverse[suggestion]);

                if((set_finalidade == 1 && detalhe_finalidade_id_reverse[suggestion] == 71) ||
                        (set_finalidade == -1 && detalhe_finalidade_id_reverse[suggestion] == 71)) {

                    $(".pedido_especificacao_fundao_parent_row").show();

                } else if((set_finalidade == 2 && detalhe_finalidade_id_reverse[suggestion] == 106) || 
                            (set_finalidade == -1 && detalhe_finalidade_id_reverse[suggestion] == 106)) {

                    $(".pedido_especificacao_fundao_parent_row").show();

                } else {

                    $("#pedido_especificacao_funcao").val('');
                    $(".pedido_especificacao_fundao_parent_row").hide();

                }


            });


            $('#pedido_finalidade').keypress(function (e) {
              if (e.which == 13) {
                $(this).trigger("typeahead:select");
              }
            });

            $('#pedido_detalhe_finalidade').keypress(function (e) {
              if (e.which == 13) {
                $(this).trigger("typeahead:select");
              }
            });


            $(".pedido_tipo_certificado").change(function() {

                var tipo_certidao = $(this).val();

                if(tipo_certidao == '2') {

                    $(".pedido_identificacao_pessoa_colectiva").show();

                } else {
                    $(".pedido_identificacao_pessoa_colectiva").hide();
                }


            });

            
            $("#submitPedido").click(function(e) {

                var form = $("#formPedido");

                if($(form).valid()) {

                    var modal = $(this).data('modal');
                    $('.' + modal).addClass('md-show');
                    
                }

            });

        });




        function denominacaoSocial() {

            $("#pedido_denominacao").val('');

            $("#pedido_denominacao").after('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate form-control-feedback"></span>');

            result = $.ajax({

                type: 'POST',
                url: '/services/nipc',
                dataType:'json',
                data: 'nipc='+$("#pedido_nipc").val()

            }).done(function(data) {

                $("span.glyphicon-refresh", $("#pedido_denominacao").parent()).remove();

                if(data['status'] == true) {

                    $("#pedido_denominacao").val(data['denominacao']);
                }

            });

        }


    