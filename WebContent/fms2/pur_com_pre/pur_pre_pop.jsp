<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.* "%>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String mode 				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(mode.equals("jg_code")){
		ce_bean = c_db.getCommonEtc("set_msg", "jg_code", "�����������޼��������ڵ弳��", "", "", "", "", "", "");
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
	
	if(new_jg_code.length!=7){			alert("�����ڵ� 7�ڸ��� ��Ȯ�� �Է����ּ���.");	return;		}
	
	for(var i=0; i<jg_code_arr.length;i++){
		if(mode=='I'){
			if(jg_code_arr[i] == new_jg_code){			alert("�̹� ��ϵ� �����ڵ��Դϴ�."); 	return;			}
			
		}else if(mode=="D"){
			if(jg_code_arr[i] != new_jg_code){
				jg_codes += jg_code_arr[i];
				if(i != jg_code_arr.length-1){	jg_codes += ",";	}	
			}	
		}
	}
	
	if(confirm('���� �Ͻðڽ��ϱ�?')){	
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
	<span class="style1">���¾�ü���� > ��ü������ > ���������� > </span>
	<%if(mode.equals("jg_code")){%>	
		<span class="style5">�޼��� ���� �����ڵ� ����</span>
	<%}%>	
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">
<%if(mode.equals("jg_code")){%>
	<tr>
		<td>�� ���4�ܰ� ��Ͻ�, ���������� ����ڿ��� �޼��� �߼۵Ǵ� ������ �����ϴ� �������Դϴ�.</td>
	</tr>
    <tr> 
      	<td class=line> 
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
        			<col width='30%'>
	        		<col width='*'>
        		</colgroup>
          		<tr>
          			<td class=title>�����ڵ�</td>
          			<td class=title>����</td>
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
  			�����ڵ� : <input type="text" name="jg_code" id="jg_code" size="8">
    		<input type="button" class="button"  value="�߰�" onclick="javascript:update_jg_code('I')">
    		<input type="button" class="button"  value="����" onclick="javascript:update_jg_code('D')">
    	</td>
    </tr>
<%}%>
</table>
<div align="center">
    <input type='button' value='�ݱ�'  class='button' onclick='javascript:window.close();'>
</div>
</form>
</body>
</html>