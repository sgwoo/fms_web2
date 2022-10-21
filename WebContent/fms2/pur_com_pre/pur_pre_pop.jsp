<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.* "%>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String mode 				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(mode.equals("jg_code")){
		ce_bean = c_db.getCommonEtc("set_msg", "jg_code", "사전계약관리메세지수신코드설정", "", "", "", "", "", "");
	}
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
$(document).on(function(){

});

function update_jg_code(mode){
	var jg_codes = $("#jg_codes").val();
	var new_jg_code = $("#jg_code").val();
	var jg_code_arr = jg_codes.split(",");
	
	if(mode=="I"){	jg_codes += ","+new_jg_code;			}
	if(mode=="D"){	jg_codes = "";										}
	
	if(new_jg_code.length!=7){			alert("차종코드 7자리를 정확히 입력해주세요.");	return;		}
	
	for(var i=0; i<jg_code_arr.length;i++){
		if(mode=='I'){
			if(jg_code_arr[i] == new_jg_code){			alert("이미 등록된 차종코드입니다."); 	return;			}
			
		}else if(mode=="D"){
			if(jg_code_arr[i] != new_jg_code){
				jg_codes += jg_code_arr[i];
				if(i != jg_code_arr.length-1){	jg_codes += ",";	}	
			}	
		}
	}
	
	if(confirm('수정 하시겠습니까?')){	
		window.open("pur_pre_pop_a.jsp?mode=jg_code&jg_codes="+jg_codes, "action", "left=100, top=20, width=600, height=500, scrollbars=auto");
	}
}
</script>
</head>

<body>
<form name='form1' method='post'>
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="jg_codes" id="jg_codes" value="<%=ce_bean.getEtc_content()%>">
<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">협력업체관리 > 자체출고관리 > 사전계약관리 > </span>
	<%if(mode.equals("jg_code")){%>	
		<span class="style5">메세지 수신 차종코드 설정</span>
	<%}%>	
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">
<%if(mode.equals("jg_code")){%>
	<tr>
		<td>※ 계약4단계 등록시, 사전계약관리 담당자에게 메세지 발송되는 차종을 설정하는 페이지입니다.</td>
	</tr>
    <tr> 
      	<td class=line> 
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
        			<col width='30%'>
	        		<col width='*'>
        		</colgroup>
          		<tr>
          			<td class=title>차종코드</td>
          			<td class=title>차명</td>
          		</tr>
   		<%	if(ce_bean != null){
          			String jg_codes =  ce_bean.getEtc_content();
          			String jg_codes_r = "";	 	
          			String [] jg_code_arr = jg_codes.split(",");
          			for(int i=0; i<jg_code_arr.length;i++){
          				jg_codes_r += "'"+jg_code_arr[i]+"'";
          				if(i != jg_code_arr.length-1){	jg_codes_r +=	",";	}
          			}	          				
          			Vector vt = cop_db.getCarInfoForMsg(jg_codes_r);
          			int vt_size = vt.size();
          			
          			if(vt_size > 0){
          				for(int i=0;i<vt_size;i++){
          					Hashtable ht = (Hashtable)vt.elementAt(i);
          		%>
          		<tr>
          			<td align="center"><%=ht.get("JG_CODE")%></td>
          			<td>&nbsp;&nbsp;&nbsp;<%=ht.get("CAR_NM")%></td>
          		</tr>
   		<%			}
   					}
   				}%>
        	</table>
      	</td>
	</tr>
    <tr>
    	<td align="right">
  			차종코드 : <input type="text" name="jg_code" id="jg_code" size="8">
    		<input type="button" class="button"  value="추가" onclick="javascript:update_jg_code('I')">
    		<input type="button" class="button"  value="삭제" onclick="javascript:update_jg_code('D')">
    	</td>
    </tr>
<%}%>
</table>
<div align="center">
    <input type='button' value='닫기'  class='button' onclick='javascript:window.close();'>
</div>
</form>
</body>
</html>