<%@ page contentType="text/html; charset=euc-kr" language="java" %>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
    .table-style-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        color: #515150;
        font-weight: bold;
    }
    .table-back-1 {
        background-color: #B0BAEC
    }
    .table-body-1 {
        text-align: center;
    }
    .font-1 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
        font-weight: bold;
    }
    .font-2 {
        font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
        font-size: 9pt;
    }
</style>

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">

    var gSeq = 0;

    $(document).ready(function(){
    	$('#select-category').hide();
    	
    	//$('#input-category_1').val("0");
    	//$('#input-category').hide();

        // 시퀀스 가져옴
        ajaxGetSequence();
        
     	// 템플릿 카테고리 선택시 : 템플릿 리스트 가져옴
        $('#select-first-category').bind('change', function() {

            var option = $(this).find('option:selected');
            
            if (option.val() == '1') {
            	
            	$('#select-category').empty();
                var html =
                    '<option value="0" selected>카테고리선택</option>'+
                    '<option value="1">장기대여</option>'+
                    '<option value="2">월렌트</option>'+
                    '<option value="3">협력업체</option>'+
                    '<option value="4">리콜안내</option>';
                $('#select-category').append(html);
            	
            	$('#select-category').val("0");
            	$('#select-category').show();
            	
            } else if (option.val() == '2') {
            	
            	$('#select-category').empty();
                var html =
                    '<option value="0" selected>카테고리선택</option>'+
                    '<option value="5">대여개시</option>'+
                    '<option value="6">예약안내</option>'+
                    '<option value="7">예약취소</option>'+
                    '<option value="8">해지안내</option>'+
                    '<option value="9">계약종료</option>'+
                    '<option value="10">보험안내</option>'+
                    '<option value="11">사고접수</option>'+
                    '<option value="12">정비안내</option>'+
                    '<option value="13">정기검사</option>'+
                    '<option value="14">연체안내</option>'+
                    '<option value="15">탁송</option>';
                $('#select-category').append(html);
            	
            	$('#select-category').val("0");
            	$('#select-category').show();
            } else {
            	
            	$('#select-category').empty();
                var html =
                    '<option value="0" selected>카테고리선택</option>';
                $('#select-category').append(html);
            	
                $('#select-category').val("0");        	
            	$('#select-category').hide();
            	//$('#template-select').show();
            }
            $('#select-category').trigger('change');
        });
        
        // 입력 카테고리 선택시
        /* $('#input-category_1').bind('change', function() {

            var option = $(this).find('option:selected');
            
            if (option.val() == '1') {
            	$("#input-category").val('1');
            	$('#input-category').show();
            	
            	$("#input_cate_1").show();
            	$("#input_cate_2").show();
            	$("#input_cate_3").show();
            	$("#input_cate_4").show();
            	$("#input_cate_5").hide();
            	$("#input_cate_6").hide();
            	$("#input_cate_7").hide();
            	$("#input_cate_8").hide();
            	$("#input_cate_9").hide();
            	$("#input_cate_10").hide();
            	$("#input_cate_11").hide();
            } else if (option.val() == '2') {
            	$("#input-category").val('5');
            	$('#input-category').show();
            	
            	$("#input_cate_1").hide();
            	$("#input_cate_2").hide();
            	$("#input_cate_3").hide();
            	$("#input_cate_4").hide();
            	$("#input_cate_5").show();
            	$("#input_cate_6").show();
            	$("#input_cate_7").show();
            	$("#input_cate_8").show();
            	$("#input_cate_9").show();
            	$("#input_cate_10").show();
            	$("#input_cate_11").show();
            } else {
            	$('#input-category').val("0");
            }
        }); */

        // 템플릿 카테고리 선택시 : 템플릿 리스트 가져옴
        $('#select-category').bind('change', function() {
        	var cmd_use = $(":input:radio[name=cmd_use]:checked").val();					// 사용 여부 선택 값	2017.12.21
        	var cmd_manage = $(":input:radio[name=cmd_manage]:checked").val();	// 관리 여부 선택 값	2017.12.21
        	
            ajaxGetTemplateList($('#select-first-category').val(), $(this).val(), cmd_use, cmd_manage);		// 템플릿 선택 조건에 사용 여부, 관리 여부 추가		2017.12.21
            clearTemplateTable();
        });
        $('#select-category').trigger('change');
        
        // 사용 여부 변경 시 카테고리 전체 선택	2017.12.21
        $("input[type=radio][name=cmd_use]").change(function(){
        	$('#select-category').val("0").prop("selected", true);
        	$('#select-category').trigger('change');
        });
        
     	// 관리 여부 변경 시 카테고리 전체 선택	2017.12.21
        $("input[type=radio][name=cmd_manage]").change(function(){
        	$('#select-category').val("0").prop("selected", true);
        	$('#select-category').trigger('change');
        });

        // 템플릿 선택시 : 템플릿 테이블 채움
        $('#select-template').bind('change', function() {

            // 템플릿 선택 안했을때는 생성, 선택 했을때는 변경/삭제
            if ($(this).val() == 0) {
                $('#button-create').prop('disabled', false);
                $('#button-change').prop('disabled', true);
                $('#button-delete').prop('disabled', true);
                $('#input-no').prop('readonly', false);
                $('#input-code').prop('readonly', false);
                //$('#input-category_1').val('0');
                //$('#input-category').hide();
                clearTemplateTable();
                ajaxGetSequence();                
            } else {            	
                setTemplateTable($(this).find('option:selected'));
                $('#button-create').prop('disabled', true);
                $('#button-change').prop('disabled', false);
                $('#button-delete').prop('disabled', false);
                $('#input-no').prop('readonly', true);
                $('#input-code').prop('readonly', true);
                //$('#input-category').show();
            }
        })

        // 생성 버튼 클릭시
        $('#button-create').bind('click', function() {
            var no = $('#input-no').val();
            var code = $('#input-code').val();
            var cat_1 = $('#input-category_2').val();
            var cat = $('#input-category').val();
            var show = $('#input-show-list').is(':checked') ? "Y" : "N";
            var name = $('#input-name').val();
            var content = $('#input-content').val();
            var desc = $('#input-desc').val();            
            var use_yn = $('#input-use_yn').is(':checked') ? "Y" : "N";
            var m_nm = "";
            
         	// 상품별
            var cat_1_text = $("#input-category_2 option:selected").text();
            var cat_1_1_text = $("#sub-category option:selected").text();
         	// 내용별
            var cat_text = $("#input-category option:selected").text();
         	
         	if (cat_1 == "1" || cat_1 == "2" || cat_1 == "3") {
         		m_nm = "#상품별/"+cat_1_text+"/"+cat_1_1_text+"#내용별/"+cat_text;
         	} else {
         		m_nm = "#상품별/"+cat_1_text+"#내용별/"+cat_text;
         	}

            ajaxCreateTemplate(no, code, cat_1, cat, show, name, content, desc, use_yn, m_nm);
        });

        // 변경 버튼 클릭시
        $('#button-change').bind('click', function() {
            var no = $('#input-no').val();
            var code = $('#input-code').val();
            var cat_1 = $('#input-category_2').val();
            var cat = $('#input-category').val();
            var show = $('#input-show-list').is(':checked') ? "Y" : "N";
            var name = $('#input-name').val();
            var content = $('#input-content').val();
            var desc = $('#input-desc').val();            
            var use_yn = $('#input-use_yn').is(':checked') ? "Y" : "N";
            var m_nm = "";
            
            // 상품별
            var cat_1_text = $("#input-category_2 option:selected").text();
            var cat_1_1_text = $("#sub-category option:selected").text();
         	// 내용별
            var cat_text = $("#input-category option:selected").text();
         	
         	if (cat_1 == "1" || cat_1 == "2" || cat_1 == "3") {
         		m_nm = "#상품별/"+cat_1_text+"/"+cat_1_1_text+"#내용별/"+cat_text;
         	} else {
         		m_nm = "#상품별/"+cat_1_text+"#내용별/"+cat_text;
         	}

            ajaxUpdateTemplate(no, code, cat_1, cat, show, name, content, desc, use_yn, m_nm);
        });

        // 삭제 버튼 클릭시
        $('#button-delete').bind('click', function() {
            var no = $('#input-no').val();
            var code = $('#input-code').val();

            ajaxDeleteTemplate(no, code);
        });
        
        // 대표 카테고리 상품별 선택시
        $('#input-category_2').on("change", function() {
        	var cat_1 = $('#input-category_2').val();
        	if (cat_1 == "0" || cat_1 == "4") {
        		$("#sub_nm").val("");
        		$("#sub_nm").prop("disabled", true);
        	} else {
        		$("#sub_nm").prop("disabled", false);
        	}
        	
        	if ($("#input-category_2").val() == "1") {
            	create_sub(0);
            } else if ($("#input-category_2").val() == "2") {
            	create_sub(1);
            } else if ($("#input-category_2").val() == "3") {
            	create_sub(2);
            } else {
            	create_sub(3);
            }
        })
        
    })

    function ajaxGetTemplateList(category_1, category, cmd_use, cmd_manage) {	// 템플릿 선택 조건에 사용 여부, 관리 여부 추가		2017.12.21
        var data = {
       		cat_1: category_1,
    		cat: category,
        };
        $.ajax({
            cache: false,
            type: 'GET',
            url: './alim_template_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'list',
                data: JSON.stringify(data),
                use: cmd_use,
                manage: cmd_manage
            },
            success: function(data) {
                setTemplateList(data);
                $('#select-template').trigger('change');
            },
            error: function(e) {
                alert('템플릿 리스트를 가져오지 못했습니다');
            }
        });
    }

    function setTemplateList(data) {
        $('#select-template').empty();
        $('#select-template').append('<option value="0" selected>템플릿 선택</option>');
        data.forEach(function(tpl) {
        	var select_first_cate = $("#select-first-category").val();
        	var temp_cate = "";
        	
        	if (select_first_cate == "1") {
        		temp_cate = tpl.CAT_1;
        	} else {
        		temp_cate = tpl.CAT;
        	}
        	
            html =
                '<option value="'+ tpl.NO +'" ' +
                'data-cat_1="'+ tpl.CAT_1 +'" '+
                //'data-cat_1="'+ select_first_cate +'" '+
                'data-cat="'+ tpl.CAT +'" '+
                'data-m_nm="'+ tpl.M_NM +'" '+
                //'data-cat="'+ temp_cate +'" '+
                'data-show="'+ tpl.SHOW +'" '+
                'data-code="'+ tpl.CODE +'" '+
                'data-content="'+ tpl.CONTENT +'" '+
                'data-desc="'+ tpl.DESC +'" '+
                'data-use_yn="'+ tpl.USE_YN +'" '+                
                '>'+ tpl.NAME +' ('+tpl.CODE+')'+'</option>';
            $('#select-template').append(html);
        });
    }

    function setTemplateTable(data) {
        var no = data.val();
        var code = data.attr('data-code');
        var cat_1 = data.attr('data-cat_1');
        var cat = data.attr('data-cat');
        var m_nm = data.attr('data-m_nm');
        var show = data.attr('data-show');
        var name = data.html();
        var content = data.attr('data-content');
        var desc = data.attr('data-desc');
        var use_yn = data.attr('data-use_yn');
		
        $('#input-no').val(no);
        $('#input-code').val(code);
        //$('#input-category_1').val(cat_1);
        $('#input-category').val(cat);
        $('#input-category_2').val(cat_1);
        
        // 메뉴명 등록되어있는지 값 확인
        if (!(m_nm == "" || m_nm == "undefined" || m_nm == null || m_nm == "null")) {
	        var m_nm_split = m_nm.split("#")[1];
	        var m_nm_length = m_nm_split.length;
	        var m_nm_idx = m_nm_split.lastIndexOf("/");
	        var result_m_nm = m_nm_split.substring(m_nm_idx, m_nm_length);
	        
	        // 최종텍스트
	        var sub_m_nm = result_m_nm.replace("/", "");
	        
	        // 중단메뉴 텍스트
	        var mid_text = m_nm.split("#")[1].split("/")[1];
	        
	        if (mid_text == "장기대여") {
		        create_sub(0);
		        $("#sub-category").val(sub_m_nm);
	        } else if (mid_text == "월렌트") {
		        create_sub(1);
		        $("#sub-category").val(sub_m_nm);
	        } else if (mid_text == "협력업체") {
		        create_sub(2);
		        $("#sub-category").val(sub_m_nm);
	        } else {
	        	create_sub(3);
	        }
        } else {        	
        	if ($("#input-category_2").val() == "1") {
            	create_sub(0);
            } else if ($("#input-category_2").val() == "2") {
            	create_sub(1);
            } else if ($("#input-category_2").val() == "3") {
            	create_sub(2);
            } else {
            	create_sub(3);
            }
        }
        
        if (show == 'Y') {
            $('#input-show-list').prop('checked', true);
        }else{
       	    $('#input-show-list').prop('checked', false);
        }
        
        var name_slice = name.slice(0, -11);	// 제목에 acar0067 코드가 나타나는 것을 제거 2017.12.22

        $('#input-name').val(name_slice);
        $('#input-content').val(content);
        $('#input-desc').val(desc);
        if (use_yn == 'Y') {
            $('#input-use_yn').prop('checked', true);
        } else {
       	    $('#input-use_yn').prop('checked', false);
       	}
    }

    function clearTemplateTable() {
        $('#input-no').val('');
        $('#input-code').val('');
        $('#input-category_2').val('0');
        $('#input-category').val('0');
        $('#input-show-list').prop('checked', false);
        $('#input-name').val('');
        $('#input-content').val('');
        $('#input-desc').val('');
        $('#input-use_yn').prop('checked', false);

        if ($(gSeq != 0 && '#select-category option:selected').val() == '0') {
            $('#input-no').val(gSeq);
            $('#input-code').val('acar' + new Array(4 - gSeq.toString().length + 1).join('0') + gSeq.toString());
        }
    }

    function ajaxGetSequence() {
        $.ajax({
            cache: false,
            type: 'POST',
            url: './alim_template_ajax.jsp',
            dataType: 'json',
            data: {
                cmd: 'sequence'
            },
            success: function(data) {
                gSeq = data['sequence'];

                $('#input-no').val(gSeq);
                $('#input-code').val('acar' + new Array(4 - gSeq.toString().length + 1).join('0') + gSeq.toString());
            },
            error: function(e) {
            }
        });
    }

    function ajaxCreateTemplate(no, code, cat_1, cat, show, name, content, desc, use_yn, m_nm) {

        if (no == "" || code == "" || name == "" || content == "") {
            alert("필드를 입력해주세요.");
            return;
        }        
        if (cat_1 == "" || cat_1 == "0" || cat_1 == null || cat_1 == "null") {
        	alert("상품별 카테고리를 선택해주세요.");
        	return;
        }        
        if (cat == "" || cat == "0" || cat == null || cat == "null") {
        	alert("내용별 카테고리를 선택해주세요.");
        	return;
        }

        if (confirm('템플릿을 생성하시겠습니까?')) {
            var data = {
                no: no,
                code: code,
                cat_1: cat_1,
                cat: cat,
                show: show,
                name: encodeURIComponent(name),
                content: encodeURIComponent(content),
                desc: encodeURIComponent(desc),
                use_yn: use_yn,
                m_nm: encodeURIComponent(m_nm)
            };
            $.ajax({
                cache: false,
                type: 'POST',
                url: './alim_template_ajax.jsp',
                dataType: 'json',
                data: {
                    cmd: 'create',
                    data: JSON.stringify(data)
                },
                success: function(data) {
                    alert('템플릿을 생성하였습니다.')
                    $('#select-category').trigger('change');
                },
                error: function(e) {
                    alert('템플릿을 생성하지 못했습니다.');
                }
            });
        }
    }

    function ajaxUpdateTemplate(no, code, cat_1, cat, show, name, content, desc, use_yn, m_nm) {
        if (confirm('템플릿을 변경하시겠습니까?')) {
            var data = {
                no: no,
                code: code,
                cat_1: cat_1,
                cat: cat,
                show: show,
                name: encodeURIComponent(name),
                content: encodeURIComponent(content),
                desc: encodeURIComponent(desc),
                use_yn: use_yn,
                m_nm: encodeURIComponent(m_nm)
            };
            $.ajax({
                cache: false,
                type: 'POST',
                url: './alim_template_ajax.jsp',
                dataType: 'json',
                data: {
                    cmd: 'update',
                    data: JSON.stringify(data)
                },
                success: function(data) {
                    alert('템플릿을 변경하였습니다.');
                    $('#select-category').trigger('change');
                },
                error: function(e) {
                    alert('템플릿을 변경하지 못했습니다.');
                }
            });
        }
    }

    function ajaxDeleteTemplate(no, code) {
        if (confirm('해당 템플릿을 삭제하시겠습니까?')) {
            var data = {
                no: no,
                code: code
            };
            $.ajax({
                cache: false,
                type: 'POST',
                url: './alim_template_ajax.jsp',
                dataType: 'json',
                data: {
                    cmd: 'delete',
                    data: JSON.stringify(data)
                },
                success: function(data) {
                    alert('템플릿을 삭제하였습니다.')
                    $('#select-category').trigger('change');
                },
                error: function(e) {
                    alert('템플릿을 삭제하지 못했습니다.');
                }
            });
        }
    }

    // 템플릿 팝업
    function openPopup(){
    	window.open("./alim_template_popup.jsp","alim_template_popup","width=580, height=900, left=800, top=30, scrollbars=yes");
    }
        	
	// 세부카테고리 동적생성
	function create_sub(idx) {
		
		var sub = new Array();
		sub[0] = new Array("대여개시", "계약종료", "보험안내", "사고접수", "정비안내", "정기검사", "연체안내", "해지안내");
		sub[1] = new Array("예약안내", "예약취소", "대여개시", "계약종료", "보험안내", "사고접수", "정비안내", "정기검사", "연체안내", "해지안내");
		sub[2] = new Array("정기검사", "탁송");
		sub[3] = new Array("카테고리선택");
		
		$("#sub-category").empty();
		for (var i = 0; i < sub[idx].length; i++) {
			if (idx == 3) {				
				html = '<option value="'+ sub[idx][i] +'" ' +' selected disabled>'+ sub[idx][i] +'</option>';
			} else {				
				html = '<option value="'+ sub[idx][i] +'" ' +'>'+ sub[idx][i] +'</option>';
			}
			$("#sub-category").append(html);
		}
	}

</script>
</head>

<body leftmargin="15">

<%-- 헤더 --%>
<div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td colspan=10>
                <table width=100% border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_1.gif width=7 height=33>
                        </td>
                        <td class=bar>
                        	&nbsp;&nbsp;&nbsp;
                        	<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
                        	<span class=style1>
                        		FMS운영관리 > Master > <span class=style5>알림톡템플릿관리</span>
                        	</span>
                        </td>
                        <td width=7>
                        	<img src=/acar/images/center/menu_bar_2.gif width=7 height=33>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td class=h></td>
        </tr>
    </table>
</div>

<%-- 템플릿 --%>
<div>
    <div class="table-style-1">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px;">템플릿
    </div>
    <div style="padding-top: 10px;">
        <table>
        	<tr>
        		<td style="border-top:1px solid #444444;border-left:1px solid #444444;border-right:1px solid #444444;" align="center">사용 여부</td>
        		<td style="border-top:1px solid #444444;border-left:1px solid #444444;border-right:1px solid #444444;" align="center">관리 여부</td>
        		<td rowspan="2">
        			&nbsp;&nbsp;
        			<select id="select-first-category">
			    		<option value="0">전체</option>
			    		<option value="1">상품별</option>
    					<option value="2">내용별</option>
    					
			    		<!-- <option value="1">장기대여</option>
			    		<option value="2">월렌트</option>
			    		<option value="3">협력업체</option>
			    		<option value="4">아마존카</option> -->
			    	</select>
			    	<select id="select-category">
			    		<option value="0" id="cate_0">카테고리선택</option>
			    		<option value="1" id="cate_1">장기대여</option>
			    		<option value="2" id="cate_2">월렌트</option>
			    		<option value="3" id="cate_3">협력업체</option>
			    		<option value="4" id="cate_4">아마존카</option>
						<option value="5" id="cate_5">대여개시</option>
			    		<option value="6" id="cate_6">예약/예약취소</option>
			    		<option value="7" id="cate_7">해지/종료</option>
			    		<option value="8" id="cate_8">보험/정비/정기검사</option>
			    		<option value="9" id="cate_9">탁송</option>
			    		<option value="10" id="cate_10">협력업체</option>
			    		<option value="11" id="cate_11">직원</option>
			        	<!-- <option value="0" id="cate_0">카테고리선택</option>
			        	<option value="1" id="cate_1">대여개시</option>
			    		<option value="2" id="cate_2">예약/예약취소</option>
			    		<option value="3" id="cate_3">해지/종료</option>
			    		<option value="4" id="cate_4">보험/정비/정기검사</option>
			    		<option value="5" id="cate_5">탁송</option>
			    		<option value="6" id="cate_6">협력업체</option>
			    		<option value="7" id="cate_7">직원</option> -->
			        </select>
        			<!-- <select id="select-category">
			            <option value="0">전체</option>
			            <option value="1">영업관리</option>
			            <option value="2">차량관리</option>
			            <option value="3">사고및보험</option>
			            <option value="4">재무회계</option>
			            <option value="5">채권관리</option>
			            <option value="6">매각관리</option>
			            <option value="7">협력업체관리</option>
			            <option value="8">인사관리</option>
			            <option value="9">개별</option>
			        </select> -->
        		</td>
        		<td rowspan="2">
        			<select id="select-template">
            			<option value="0" selected>템플릿 선택</option>
        			</select>
        		</td>
        	</tr>
        	<tr>
        		<td style="border-bottom:1px solid #444444;border-left:1px solid #444444;border-right:1px solid #444444;" align="center">
        			<label><input type="radio" name="cmd_use" value="2">전체</label> 
        			<label><input type="radio" name="cmd_use" value="1" checked>사용</label>
        			<label><input type="radio" name="cmd_use" value="0">미사용</label>
        		</td>
        		<td style="border-bottom:1px solid #444444;border-left:1px solid #444444;border-right:1px solid #444444;" align="center">
        			<label><input type="radio" name="cmd_manage" value="2">전체</label> 
        			<label><input type="radio" name="cmd_manage" value="1" checked>사용</label>
        			<label><input type="radio" name="cmd_manage" value="0">미사용</label>
        		</td>        		
        	</tr>
        </table>
    </div>

	<div style="padding-top: 15px;">
		<table>
			<tr>
				<td>
					<table class="table-back-1" border="0" cellspacing="1" cellpadding="0" width="700">
				        <tr>
				        	<td class=line2 colspan=2></td>
				        </tr>
				        <tr>
				            <td class="title" width=15%>번호</td>
				            <td width=70% style="padding: 1px 5px;">
				                <input id="input-no" type="text" name="end_dt"  value="" class="whitetext" style="width: 50%;">
				            </td>
				        </tr>
				        <tr>
				            <td class="title">코드</td>
				            <td style="padding: 1px 5px;">
				                <input id="input-code" type="text" name="end_dt"  value="" class="whitetext" style="width: 50%;">
				            </td>
				        </tr>
				        <tr>
				            <td class="title">카테고리</td>
				            <td style="padding: 1px 5px;">
				            	<!-- <select id="input-category_1">
				                    <option value="0" disabled selected>카테고리 선택</option>
				                    <option value="1">상품별</option>
				                </select> -->
				                상품별&nbsp;                
				                <select id="input-category_2">
				                	<!-- <option value="0" id="input_cate_0" disabled selected>카테고리선택</option> -->
				                	<option value="0" disabled selected>카테고리선택</option>				                	
				                	<option value="1" id="input_cate_1">장기대여</option>
						    		<option value="2" id="input_cate_2">월렌트</option>
						    		<option value="3" id="input_cate_3">협력업체</option>
						    		<option value="4" id="input_cate_4">리콜안내</option>
				                	
						        	<!-- <option value="1" id="input_cate_1">대여개시</option>
						    		<option value="2" id="input_cate_2">예약/예약취소</option>
						    		<option value="3" id="input_cate_3">해지/종료</option>
						    		<option value="4" id="input_cate_4">보험/정비/정기검사</option>
						    		<option value="5" id="input_cate_5">탁송</option>
						    		<option value="6" id="input_cate_6">협력업체</option>
						    		<option value="7" id="input_cate_7">직원</option> -->
						    		
				                    <!-- <option value="0" disabled selected>카테고리 선택</option>
				                    <option value="1">영업관리</option>
				                    <option value="2">차량관리</option>
				                    <option value="3">사고및보험</option>
				                    <option value="4">재무회계</option>
				                    <option value="5">채권관리</option>
				                    <option value="6">매각관리</option>
				                    <option value="7">협력업체관리</option>
				                    <option value="8">인사관리</option>
				                    <option value="9">개별</option> -->
				                </select>
				                &nbsp;
				                <select id="sub-category">
				        			<option value="카테고리선택" disabled selected>카테고리선택</option>
				        		</select>
				        		&nbsp;&nbsp;
				                내용별&nbsp;  
				                <select id="input-category">
				                	<!-- <option value="0" id="input_cate_0" disabled selected>카테고리선택</option> -->
				                	<option value="0" disabled selected>카테고리선택</option>				                	
									<option value="5" id="input_cate_5">대여개시</option>
						    		<option value="6" id="input_cate_6">예약안내</option>
						    		<option value="7" id="input_cate_7">예약취소</option>
						    		<option value="8" id="input_cate_8">해지안내</option>
						    		<option value="9" id="input_cate_9">계약종료</option>
						    		<option value="10" id="input_cate_10">보험안내</option>
						    		<option value="11" id="input_cate_11">사고접수</option>
						    		<option value="12" id="input_cate_12">정비안내</option>
						    		<option value="13" id="input_cate_13">정기검사</option>
						    		<option value="14" id="input_cate_14">연체안내</option>
						    		<option value="15" id="input_cate_15">탁송</option>
				                	
						        	<!-- <option value="1" id="input_cate_1">대여개시</option>
						    		<option value="2" id="input_cate_2">예약/예약취소</option>
						    		<option value="3" id="input_cate_3">해지/종료</option>
						    		<option value="4" id="input_cate_4">보험/정비/정기검사</option>
						    		<option value="5" id="input_cate_5">탁송</option>
						    		<option value="6" id="input_cate_6">협력업체</option>
						    		<option value="7" id="input_cate_7">직원</option> -->
						    		
				                    <!-- <option value="0" disabled selected>카테고리 선택</option>
				                    <option value="1">영업관리</option>
				                    <option value="2">차량관리</option>
				                    <option value="3">사고및보험</option>
				                    <option value="4">재무회계</option>
				                    <option value="5">채권관리</option>
				                    <option value="6">매각관리</option>
				                    <option value="7">협력업체관리</option>
				                    <option value="8">인사관리</option>
				                    <option value="9">개별</option> -->
				                </select>	                
				            </td>
				        </tr>
				        <tr>
				        	<td class="title">템플릿 여부</td>
				        	<td style="padding: 1px 5px;">
				        		템플릿 관리 여부<input id="input-show-list" type="checkbox">
				                &nbsp;
								템플릿 사용 여부<input id="input-use_yn" type="checkbox">
				        	</td>
				        </tr>
				        <tr>
				            <td class="title">제목</td>
				            <td style="padding: 1px 5px;">
				                <input id="input-name" type="text" value="" class="whitetext" style="width: 100%;">
				            </td>
				        </tr>
				        <tr>
				            <td class="title">내용</td>
				            <td style="padding: 1px 5px;">
				                <textarea id="input-content" name="car_etc" rows="20" style="overflow-y: scroll; border: 0px; margin: 0px; width: 100%; resize: none;"></textarea></td>
				            </td>
				        </tr>
				        <tr>
				            <td class="title">설명</td>
				            <td style="padding: 1px 5px;">
				                <input id="input-desc" type="text" name="end_dt"  value="" class="whitetext" style="width: 100%;">
				            </td>
				        </tr>
				    </table>
				</td>
				<td style="vertical-align: top; padding-top: 30px; padding-left: 30px;">
					<table>
				    	<tr>
				    		<td colspan="2" style="font-weight: bold;">* 상품별</td>
				    	</tr>
				    	<tr>
				    		<td>장기대여</td>
				    		<td style="padding-left: 15px;">
				    			대여개시 / 계약종료 / 보험안내 / 사고접수 / 정비안내 /<br>
				    			정기검사 / 연체안내 / 해지안내
				    		</td>
				    	</tr>
				    	<tr>
				    		<td colspan="2"></td>
				    	</tr>
				    	<tr>
				    		<td>월렌트</td>
				    		<td style="padding-left: 15px;">
				    			예약안내 / 예약취소 / 대여개시 / 계약종료 / 보험안내 /<br>
				    			사고접수 / 정비안내 / 정기검사 / 연체안내 / 해지안내
				    		</td>
				    	</tr>
				    	<tr>
				    		<td colspan="2"></td>
				    	</tr>
				    	<tr>
				    		<td>협력업체</td>
				    		<td style="padding-left: 15px;">
				    			정기검사 / 탁송
				    		</td>
				    	</tr>
				    	<tr>
				    		<td colspan="2"></td>
				    	</tr>
				    	<tr>
				    		<td>리콜안내</td>
				    		<td style="padding-left: 15px;">
				    			(리콜안내의 경우 카테고리선택은 확장성으로 남겨두었습니다.)
				    		</td>
				    	</tr>
				    	<tr>
				    		<td colspan="2" style="height: 50px;"></td>
				    	</tr>
				    	<tr>
				    		<td colspan="2" style="font-weight: bold;">* 내용별</td>
				    	</tr>
				    	<tr>
				    		<td colspan="2">
				    			대여개시 / 예약안내 / 예약취소 / 해지안내 / 계약종료 /<br>
				    			보험안내 / 사고접수 / 정비안내 / 정기검사 / 연체안내 / 탁송
				    		</td>
				    	</tr>
				    </table>
				</td>
			</tr>
		</table>	    
    </div>
    
    <div align="right" style="width: 700px; padding-top: 10px;">
        <button id="button-create">생성</button>
        <button id="button-change">변경</button>
        <button id="button-delete">삭제</button>
    </div>
    
</div>
<br>
<%-- 템플릿 필드표--%>
<div>    
    <div class="table-style-1">
    	<img src=/acar/images/center/icon_arrow.gif align=absmiddle style="margin-right: 5px;">템플릿 필드
    </div>
	<input type="button" value="템플릿 팝업" onclick="openPopup();" style="width:700;margin-top: 10;"/>
</div>
</body>
</html>
