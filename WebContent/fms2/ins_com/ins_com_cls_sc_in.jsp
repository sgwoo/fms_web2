<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getInsComClsList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.js"></script>
<script language='javascript'>

	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.ch_cd[i];
			 if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
			} 
		} 
	}
	
	function save() {
		var size = <%=vt_size%>;
		var value07String = "";
		var value08String = "";
		var etcString = "";
		var regCodeString = "";
		var seqString = "";
		var checkedCount = 0;
		
		for(var y=0; y<size; y++) {
			if($(".ch_cd").eq(y).is(":checked") == true) {
				checkedCount = checkedCount + 1
			}
		} 
		
		if(checkedCount == 0) {
			alert("저장할 항목을 선택하세요.");
			return;
		}
		
		for(var i=0; i<size; i++) {
			// 입력 값 validation check
			if($(".ch_cd").eq(i).is(":checked") == true) {
				var count = 0;
				var checkedSize = $("input:checkbox[name=ch_cd]:checked").length;
				
				if($(".value07").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 청구/승계일자 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value08").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 환급금 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				
				if($(".etc").eq(i).val() == "") {
					$(".etc").eq(i).val(" ");
					return;
				}
				
				if(value08String.length == 0) {
					value07String += $(".value07").eq(i).val();
				    value08String += $(".value08").eq(i).val();
					etcString += $(".etc").eq(i).val();
					regCodeString += $(".reg_code").eq(i).val();
					seqString += $(".seq").eq(i).val();
				} else {
					value07String += (","+$(".value07").eq(i).val());
				    value08String += (","+$(".value08").eq(i).val());
					etcString += (","+$(".etc").eq(i).val());
					regCodeString += (","+$(".reg_code").eq(i).val());
					seqString += (","+$(".seq").eq(i).val());
				}
			}
		}
			
			$("#value07String").val(value07String);
			$("#value08String").val(value08String);
			$("#etcString").val(etcString);
			$("#arraySize").val(checkedCount);
			$("#regCodeString").val(regCodeString);
			$("#seqString").val(seqString);
			if(confirm("저장하시겠습니까?")) {
				setTimeout(function() {
					fm = document.form1;
					fm.action = 'ins_com_cls_sc_save_a.jsp';
					fm.submit();
				});
			} else {
				return;
			}
	}
	
	function next() {
		var size = <%=vt_size%>;
		var regCodeString = "";
		var seqString = "";
		var checkedCount = 0;
		
		for(var y=0; y<size; y++) {
			if($(".ch_cd").eq(y).is(":checked") == true) {
				checkedCount = checkedCount + 1
			}
		} 
		
		if(checkedCount == 0) {
			alert("확인처리할 항목을 선택하세요.");
			return;
		}
		
		for(var i=0; i<size; i++) {
			// 입력 값 validation check
			if($(".ch_cd").eq(i).is(":checked") == true) {
				if($(".save_yn").eq(i).val() == "N") {
					alert((i+1)+"번 째 행의 데이터가 저장되지 않았습니다. 확인 후 다시 확인처리하세요.");
					return;
				}
				
				if($(".value07").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 청구/승계일자 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if($(".value08").eq(i).val() == "") {
					alert((i+1)+"번 째 행의 환급금 값이 없습니다. 확인 후 다시 저장하세요");
					return;
				}
				if(regCodeString.length == 0) {
					regCodeString += $(".reg_code").eq(i).val();
					seqString += $(".seq").eq(i).val();
				} else {
					regCodeString += (","+$(".reg_code").eq(i).val());
					seqString += (","+$(".seq").eq(i).val());
				}
			}
		}
			$("#arraySize").val(checkedCount);
			$("#regCodeString").val(regCodeString);
			$("#seqString").val(seqString);
		
			if(confirm("확인처리 하시겠습니까?")) {
				setTimeout(function() {
					fm = document.form1;
					fm.action = 'ins_com_cls_sc_confirm_a.jsp';
					fm.submit();
				});
			} else {
				return;
			}		
	}
	
	
	$(document).on("focusout","[name=value07]", function(){
		var idx = $("[name=value07]").index(this);
		var value07 = $("[name=value07]").eq(idx).val();
		var removeCommaValue07 = value07.replaceAll(',','');
		$("[name=value07]").eq(idx).val(removeCommaValue07);
	}); 

	$(document).on("focusout","[name=value08]", function(){
		var idx = $("[name=value08]").index(this);
		var value08 = $("[name=value08]").eq(idx).val();
		var removeCommaValue08 = value08.replaceAll(',','');
		$("[name=value08]").eq(idx).val(removeCommaValue08);
	}); 
	
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_cls_frame.jsp'>
  <input type="hidden" value="" id="value07String" name="value07String"/>
  <input type="hidden" value="" id="value08String" name="value08String"/>
  <input type="hidden" value="" id="etcString" name="etcString"/>
  <input type="hidden" value="" id="arraySize" name="arraySize"/>
  <input type="hidden" value="" id="regCodeString" name="regCodeString"/>
  <input type="hidden" value="" id="seqString" name="seqString"/>
<!--   <input type='hidden' name='reg_code' value=''> -->
<!--   <input type='hidden' name='seq' value=''> -->

  <input type='hidden' name='size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='2100'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='510' id='td_title' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title' style='height:51'>연번</td>
		    <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='50' class='title'>점검</td>
		    <td width='100' class='title'>보험사</td>
		    <td width='80' class='title'>상태</td>
        <td width='80' class='title'>등록일</td>
		    <td width="50" class='title'>등록자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1200'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="6" class='title'>요청</td>
		    <td colspan="4" class='title'>결과</td>
		</tr>
		<tr>
		    <td width='100' class='title'>차량번호</td>
		    <td width='150' class='title'>증권번호</td>
		    <td width='150' class='title'>차명</td>
		    <td width='150' class='title'>해지사유발생일자</td>	
		    <td width='100' class='title'>용도변경내용</td>
		    <td width='100' class='title'>용도변경목적</td>
		    <td width='100' class='title'>청구/승계일자</td>
		    <td width='100' class='title'>환급금</td>
		    <td width='100' class='title'>피보험자변경</td>
		    <td width='300' class='title'>비고</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='510' id='td_con' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>
		    <td width='50' align='center'>
		    	<input type="checkbox" name="ch_cd" class="ch_cd" value="<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>/<%=i%>">
		    </td>
		    <td width='50' align='center'><input type='text' name='chk_cont' size='3' class='whitetext' value=''></td>
		    <td width='100' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 7)%></span></td>
		    <td width='80' align='center'><%=ht.get("USE_ST")%></td>
		    <td width='80' align='center'><%=ht.get("REG_DT2")%></td>
		    <td width='50' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='1500'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		        <td width='100' align='center'><a href="javascript:parent.view_ins_com('<%=ht.get("REG_CODE")%>', '<%=ht.get("SEQ")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><%=ht.get("VALUE01")%></a></td>
		        <td width='150' align='center'><%=ht.get("VALUE02")%></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE03")%>'><%=Util.subData(String.valueOf(ht.get("VALUE03")), 10)%></span></a></td>
		        <td width='150' align='center'><%=ht.get("VALUE04")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE05")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE06")%></td>
		        <%if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='100' align='center'><input type="text" name="value07" class="value07" style="width:80%; text-align:center;" value="<%=ht.get("VALUE07")%>"/></td>
		        <%} else {%>
		        	<td width='100' align='center'><%=ht.get("VALUE07")%></td>
		        <%} %>
		        <%if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='100' align='center'><input type="text" name="value08" class="value08" style="width:80%; text-align:center;" value="<%=ht.get("VALUE08")%>"/></td>
		        <%} else {%>
		        	<td width='100' align='center'><%=ht.get("VALUE08")%></td>
		        <%} %>
		        <td width='100' align='right'><%=ht.get("VALUE10")%></td>
		        <%if(gubun1.equals("0007") && gubun2.equals("요청")) {%>
		       	 	<td width='300' align='center'><input type="text" name="etc" class="etc" style="width:80%; text-align:left;" value="<%=ht.get("ETC")%>"/></td>
		        <%} else {%>
		        	<td width='300' align='left'><%=ht.get("ETC")%></td>
		        <%} %>
		        <input type="hidden" style="display:none" id="save_yn" name="save_yn" class="save_yn" value="<%=ht.get("SAVE_YN")%>"/>
				<input type="hidden" style="display:none" id="reg_code" name="reg_code" class="reg_code" value="<%=ht.get("REG_CODE")%>"/>
		        <input type="hidden" style="display:none" id="seq" name="seq" class="seq" value="<%=ht.get("SEQ")%>"/>
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='410' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1500'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

