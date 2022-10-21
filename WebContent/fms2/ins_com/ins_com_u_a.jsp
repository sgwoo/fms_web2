<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	int flag = 0;
	
	
	InsurExcelBean iec_bean = ic_db.getInsExcelCom(reg_code, seq);
	
	if(iec_bean.getGubun().equals("가입")){
		iec_bean.setValue01	(request.getParameter("value01")==null?"":request.getParameter("value01"));
		iec_bean.setValue02	(request.getParameter("value02")==null?"":request.getParameter("value02"));
		iec_bean.setValue03	(request.getParameter("value03")==null?"":request.getParameter("value03"));
		iec_bean.setValue04	(request.getParameter("value04")==null?"":request.getParameter("value04"));
		iec_bean.setValue05	(request.getParameter("value05")==null?"":request.getParameter("value05"));
		iec_bean.setValue06	(request.getParameter("value06")==null?"":request.getParameter("value06"));
		iec_bean.setValue07	(request.getParameter("value07")==null?"":request.getParameter("value07"));
		iec_bean.setValue08	(request.getParameter("value08")==null?"":request.getParameter("value08"));
		iec_bean.setValue09	(request.getParameter("value09")==null?"":request.getParameter("value09"));
		iec_bean.setValue10	(request.getParameter("value10")==null?"":request.getParameter("value10"));
		iec_bean.setValue11	(request.getParameter("value11")==null?"":request.getParameter("value11"));
		iec_bean.setValue12	(request.getParameter("value12")==null?"":request.getParameter("value12"));
		iec_bean.setValue13	(request.getParameter("value13")==null?"":request.getParameter("value13"));
		iec_bean.setValue14	(request.getParameter("value14")==null?"":request.getParameter("value14"));
		iec_bean.setValue33	(request.getParameter("value33")==null?"":request.getParameter("value33"));
	}else if(iec_bean.getGubun().equals("갱신")){
		iec_bean.setValue01	(request.getParameter("value01")==null?"":request.getParameter("value01"));
		iec_bean.setValue02	(request.getParameter("value02")==null?"":request.getParameter("value02"));
		iec_bean.setValue03	(request.getParameter("value03")==null?"":request.getParameter("value03"));
		iec_bean.setValue04	(request.getParameter("value04")==null?"":request.getParameter("value04"));
		iec_bean.setValue05	(request.getParameter("value05")==null?"":request.getParameter("value05"));
		iec_bean.setValue06	(request.getParameter("value06")==null?"":request.getParameter("value06"));
		iec_bean.setValue07	(request.getParameter("value07")==null?"":request.getParameter("value07"));
		iec_bean.setValue08	(request.getParameter("value08")==null?"":request.getParameter("value08"));
		iec_bean.setValue09	(request.getParameter("value09")==null?"":request.getParameter("value09"));
		iec_bean.setValue10	(request.getParameter("value10")==null?"":request.getParameter("value10"));
		iec_bean.setValue11	(request.getParameter("value11")==null?"":request.getParameter("value11"));
		iec_bean.setValue12	(request.getParameter("value12")==null?"":request.getParameter("value12"));
		iec_bean.setValue13	(request.getParameter("value13")==null?"":request.getParameter("value13"));
		iec_bean.setValue14	(request.getParameter("value14")==null?"":request.getParameter("value14"));
		iec_bean.setValue15	(request.getParameter("value15")==null?"":request.getParameter("value15"));
		iec_bean.setValue16	(request.getParameter("value16")==null?"":request.getParameter("value16"));
		iec_bean.setValue17	(request.getParameter("value17")==null?"":request.getParameter("value17"));
		iec_bean.setValue18	(request.getParameter("value18")==null?"":request.getParameter("value18"));
		iec_bean.setValue19	(request.getParameter("value19")==null?"":request.getParameter("value19"));
		iec_bean.setValue20	(request.getParameter("value20")==null?"":request.getParameter("value20"));
		iec_bean.setValue21	(request.getParameter("value21")==null?"":request.getParameter("value21"));
		iec_bean.setValue22	(request.getParameter("value22")==null?"":request.getParameter("value22"));
		iec_bean.setValue23	(request.getParameter("value23")==null?"":request.getParameter("value23"));
		iec_bean.setValue24	(request.getParameter("value24")==null?"":request.getParameter("value24"));
		iec_bean.setValue25	(request.getParameter("value25")==null?"":request.getParameter("value25"));
		iec_bean.setValue26	(request.getParameter("value26")==null?"":request.getParameter("value26"));
		iec_bean.setValue27	(request.getParameter("value27")==null?"":request.getParameter("value27"));
		iec_bean.setValue28	(request.getParameter("value28")==null?"":request.getParameter("value28"));
		iec_bean.setValue29	(request.getParameter("value29")==null?"":request.getParameter("value29"));
		iec_bean.setValue30	(request.getParameter("value30")==null?"":request.getParameter("value30"));	
		iec_bean.setValue49	(request.getParameter("value49")==null?"":request.getParameter("value49"));
	}else if(iec_bean.getGubun().equals("배서")){
		iec_bean.setValue01	(request.getParameter("value01")==null?"":request.getParameter("value01"));
		iec_bean.setValue02	(request.getParameter("value02")==null?"":request.getParameter("value02"));
		iec_bean.setValue03	(request.getParameter("value03")==null?"":request.getParameter("value03"));
		iec_bean.setValue04	(request.getParameter("value04")==null?"":request.getParameter("value04"));
		iec_bean.setValue05	(request.getParameter("value05")==null?"":request.getParameter("value05"));
		iec_bean.setValue06	(request.getParameter("value06")==null?"":request.getParameter("value06"));
		iec_bean.setValue07	(request.getParameter("value07")==null?"":request.getParameter("value07"));
		iec_bean.setValue08	(request.getParameter("value08")==null?"":request.getParameter("value08"));
		iec_bean.setValue09	(request.getParameter("value09")==null?"":request.getParameter("value09"));
		iec_bean.setValue10	(request.getParameter("value10")==null?"":request.getParameter("value10"));
		iec_bean.setValue11	(request.getParameter("value11")==null?"":request.getParameter("value11"));
		iec_bean.setValue12	(request.getParameter("value12")==null?"":request.getParameter("value12"));
		iec_bean.setValue13	(request.getParameter("value13")==null?"":request.getParameter("value13"));
		iec_bean.setValue14	(request.getParameter("value14")==null?"":request.getParameter("value14"));
		iec_bean.setValue36	(request.getParameter("value36")==null?"":request.getParameter("value36"));
		iec_bean.setValue38	(request.getParameter("value38")==null?"":request.getParameter("value38"));
	}else if(iec_bean.getGubun().equals("해지")){
		iec_bean.setValue10	(request.getParameter("value10")==null?"":request.getParameter("value10"));
	}
	
	/* iec_bean.setValue01	(request.getParameter("value01")==null?"":request.getParameter("value01"));
	iec_bean.setValue02	(request.getParameter("value02")==null?"":request.getParameter("value02"));
	iec_bean.setValue03	(request.getParameter("value03")==null?"":request.getParameter("value03"));
	iec_bean.setValue04	(request.getParameter("value04")==null?"":request.getParameter("value04"));
	iec_bean.setValue05	(request.getParameter("value05")==null?"":request.getParameter("value05"));
	iec_bean.setValue06	(request.getParameter("value06")==null?"":request.getParameter("value06"));
	iec_bean.setValue07	(request.getParameter("value07")==null?"":request.getParameter("value07"));
	iec_bean.setValue08	(request.getParameter("value08")==null?"":request.getParameter("value08"));
	iec_bean.setValue09	(request.getParameter("value09")==null?"":request.getParameter("value09"));
	iec_bean.setValue10	(request.getParameter("value10")==null?"":request.getParameter("value10"));
	iec_bean.setValue11	(request.getParameter("value11")==null?"":request.getParameter("value11"));
	iec_bean.setValue12	(request.getParameter("value12")==null?"":request.getParameter("value12"));
	iec_bean.setValue13	(request.getParameter("value13")==null?"":request.getParameter("value13"));
	iec_bean.setValue14	(request.getParameter("value14")==null?"":request.getParameter("value14"));
	iec_bean.setValue15	(request.getParameter("value15")==null?"":request.getParameter("value15"));
	iec_bean.setValue16	(request.getParameter("value16")==null?"":request.getParameter("value16"));
	iec_bean.setValue17	(request.getParameter("value17")==null?"":request.getParameter("value17"));
	iec_bean.setValue18	(request.getParameter("value18")==null?"":request.getParameter("value18"));
	iec_bean.setValue19	(request.getParameter("value19")==null?"":request.getParameter("value19"));
	iec_bean.setValue20	(request.getParameter("value20")==null?"":request.getParameter("value20"));
	iec_bean.setValue21	(request.getParameter("value21")==null?"":request.getParameter("value21"));
	iec_bean.setValue22	(request.getParameter("value22")==null?"":request.getParameter("value22"));
	iec_bean.setValue23	(request.getParameter("value23")==null?"":request.getParameter("value23"));
	iec_bean.setValue24	(request.getParameter("value24")==null?"":request.getParameter("value24"));
	iec_bean.setValue25	(request.getParameter("value25")==null?"":request.getParameter("value25"));
	iec_bean.setValue26	(request.getParameter("value26")==null?"":request.getParameter("value26"));
	iec_bean.setValue27	(request.getParameter("value27")==null?"":request.getParameter("value27"));
	iec_bean.setValue28	(request.getParameter("value28")==null?"":request.getParameter("value28"));
	iec_bean.setValue29	(request.getParameter("value29")==null?"":request.getParameter("value29"));
	iec_bean.setValue30	(request.getParameter("value30")==null?"":request.getParameter("value30"));	
	iec_bean.setValue31	(request.getParameter("value31")==null?"":request.getParameter("value31"));
	iec_bean.setValue32	(request.getParameter("value32")==null?"":request.getParameter("value32"));
	iec_bean.setValue33	(request.getParameter("value33")==null?"":request.getParameter("value33"));
	iec_bean.setValue34	(request.getParameter("value34")==null?"":request.getParameter("value34"));
	iec_bean.setValue35	(request.getParameter("value35")==null?"":request.getParameter("value35"));
	iec_bean.setValue36	(request.getParameter("value36")==null?"":request.getParameter("value36"));
	iec_bean.setValue37	(request.getParameter("value37")==null?"":request.getParameter("value37"));
	iec_bean.setValue38	(request.getParameter("value38")==null?"":request.getParameter("value38"));
	iec_bean.setValue39	(request.getParameter("value39")==null?"":request.getParameter("value39"));
	iec_bean.setValue40	(request.getParameter("value40")==null?"":request.getParameter("value40"));
	iec_bean.setValue41	(request.getParameter("value41")==null?"":request.getParameter("value41"));
	iec_bean.setValue42	(request.getParameter("value42")==null?"":request.getParameter("value42"));
	iec_bean.setValue43	(request.getParameter("value43")==null?"":request.getParameter("value43"));
	iec_bean.setValue44	(request.getParameter("value44")==null?"":request.getParameter("value44"));
	iec_bean.setValue45	(request.getParameter("value45")==null?"":request.getParameter("value45"));
	iec_bean.setValue49	(request.getParameter("value49")==null?"":request.getParameter("value49")); */
	
	if(!ic_db.updateInsExcelCom(iec_bean)){
		flag += 1;
		//result = "등록에러입니다.";
	}else{
		//result = "정상 등록되었습니다.";
	}
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>
<%	if(flag > 0){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.window.close();
		parent.opener.location.reload();
<%	}			%>
</script>