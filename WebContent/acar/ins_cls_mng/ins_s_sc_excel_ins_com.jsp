<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	String vid[] 	= request.getParameterValues("pr");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String car_mng_id 	= "";
	String ins_st 	= "";
	int    count = 0;
	int flag = 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<body>
<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">연번</td>
		<td width='150' align='center' style="font-size : 8pt;">계약번호</td>
	  <td width='500' align='center' style="font-size : 8pt;">처리결과</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
	
				vid_num = vid[i];
				
				car_mng_id 		= vid_num.substring(0,6);
				ins_st				= vid_num.substring(6);
				
				String gubun = "해지";
				String result = "";
				
				
				Hashtable ht2 = ai_db.getInsClsMng(car_mng_id, ins_st);
				
				InsurExcelBean ins = new InsurExcelBean();
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(count+1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun);
				ins.setCar_mng_id (car_mng_id);
				ins.setIns_st	    (ins_st);
				
				ins.setValue01		(String.valueOf(ht2.get("CAR_NO")));
				ins.setValue02		(String.valueOf(ht2.get("INS_CON_NO")));
				ins.setValue03		(String.valueOf(ht2.get("CAR_NM")));
				if(String.valueOf(ht2.get("CAU")).equals("매입옵션") && String.valueOf(ht2.get("INS_COM_ID")).equals("0007")) {
					ins.setValue04		(String.valueOf(ht2.get("CH_DT")));
				} else { 
					ins.setValue04		(String.valueOf(ht2.get("MIGR_DT")));
				}
				ins.setValue05		("없음");
				ins.setValue06		(String.valueOf(ht2.get("CAU")));
				ins.setValue07		("");
				ins.setValue08		("");
				ins.setValue09		(String.valueOf(ht2.get("INS_COM_ID")));
				
				
				if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null") && ins.getValue04().equals("null")){
					result = "보험내용을 정상적으로 가져오지 못했습니다.";
				}else{
					//중복체크
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", "", "", car_mng_id, ins_st);
					if(over_cnt > 0){
						result = "이미 등록되어 있습니다.";
					}else{
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result = "등록에러입니다.";
						}else{
							result = "정상 등록되었습니다.";
							count++;
						}
					}
				}
	%>
	<tr>
		<td align='center' style="font-size : 8pt;"><%=i+1%></td>
    <td align='center' style="font-size : 8pt;"><%=ht2.get("CAR_NO")%> <%=car_mng_id%> <%=ins_st%></td>
    <td align='center' style="font-size : 8pt;"><%if(!result.equals("정상 등록되었습니다.")){%><font color=red><%=result%></font><%}else{%><%=result%><%}%></td>
	</tr>
	<%	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

