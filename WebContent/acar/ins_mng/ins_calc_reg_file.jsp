<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String car_name2 = request.getParameter("car_name2")==null?"":request.getParameter("car_name2");
	String car_b_p = request.getParameter("car_b_p")==null?"":request.getParameter("car_b_p");
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>

<script>
/*파일업로드 관련  */
$(document).ready(function() {
	//리스트 삭제
	function removefile(){
		$('#form3').children('#upload-select').remove();
		$('#form3').find('#file-upload-form').find('tbody').remove();
		$('#form3').find('#file-upload-form').find('tr').remove();
		$('#upload-list').empty();
		$('#upload-select').val("");
		$('#upload-list').css("height","20px");
	}
	//validation
	function validation(){
		var check = false;
		if($('#file-upload-form').find('tr').html() == undefined){
			alert("파일을 등록해주세요");
		}else{
			 check = true;
		}  
		return check;
	}

	$('#upload-select-fake').bind('click', function() {
		removefile();
		$('#upload-select').trigger('click');
	});
	
	$('#upload-select').change(function() {
		 var list = '';
         fileIdx = 0;
         for (var i = 0; i < this.files.length; i++) {
             fileIdx += 1;
             list += fileIdx + '. ' + this.files[i].name + '\n';
         }
         //파일리스트
         $('#upload-list').append(list);
         $('#upload-list').css("height","auto");
         
         for (var i = 0; i < this.files.length; i++) {
	         var file = this.files[i];
	         var tokens = file.name.split('.');
	         tokens.pop();
	         var content_seq = '<%=reg_code%>'+'_c'; 
	         var file_name = this.files[i].name;
	     	 var file_size = this.files[i].size;
	         var file_type = this.files[i].type;
	         
	         var tr =
	             '<tr><td>' +
	             '' +
	             '<input type="hidden" name="content_seq" value="'+ content_seq +'">' +
	             '<input type="hidden" name="file_name" value="'+ file_name +'">' +
	             '<input type="hidden" name="file_size" value="'+ file_size +'">' +
	             '<input type="hidden" name="file_type" value="'+ file_type +'">' +
	             '</td></tr>';
	         //파일 정보    
	         $('#file-upload-form').append(tr);
         }
         
	     	var real= $('#upload-select');
	    	var cloned = real.clone(true);
	    	real.hide();
	    	cloned.insertAfter(real);
	    	real.appendTo('#form3');
         
		});
	
		$('#upload-button-fake').bind('click', function() {
		        if(validation()){ 
			       if(!confirm("해당 파일을 등록하시겠습니까?")) return;
			       var refresh=false;
			       var fm = document.form3;
			       var url = "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=INSUR";
			       fm.action = url;
			       fm.method = "post";
			       fm.submit();
		        } 
		   });

});
</script>
<style>
	td.title{height:26px;}
	input{height:20px;}
	select{height:20px;}
	input[type=button]{height:20px;font-size:8pt;}
	input[type=radio]{height:13px;}
</style>
</head>
<body>

<form name='form1' method='post' action='ins_calc_reg_a.jsp'>
<input type="hidden" name="reg_code" value="<%=reg_code%>">


<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > 고객피보험산출요청 ><span class=style5>
			고객피보험산출요청등록</span></span></td>
		<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
	</tr>
</table>
    <br>
    <!-- 고객피보험정보 -->
    <table  width=100% border="0" cellspacing="0" cellpadding="0" >
      <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객피보험정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  width=100%>
                <tr> 
                    <td class=title width=15% id="client_nm_td">상호명/대표자명</td>
                    <td>&nbsp;<%=client_nm%></td>
                    <td width=15% class=title>차종</td>
                    <td colspan="">&nbsp;<%=car_name2%></td>
                    <td width=15% class=title>차량가격</td>
                    <td colspan="">&nbsp;<%=car_b_p%>&nbsp;원&nbsp;&nbsp;</td>
                </tr>
                 <%if(!reg_code.equals("")){ %>
                 <tr>
                    <td class=title>첨부파일</td>
                    <td colspan="5">&nbsp; 
					    <img src=/acar/images/center/button_in_fsearch.gif  border=0 id="upload-select-fake">
					    <pre style="font-size: 9pt;display: inline-block;width:300px;height:20px;margin:0px;padding:0px;background:#e2e6ea;" id="upload-list" ></pre>
					    <img src=/acar/images/center/button_in_scan_reg.gif  border=0 id="upload-button-fake" >
					    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
                    </td>   
                </tr>
                <%} %> 
            </table>
        </td>
    </tr>
      <tr>
        <td class=line2></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form name='form3' method='post' action='' id="form3" enctype="multipart/form-data">
	<div>
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>
</body>
</html>
