<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id") 	==null?"":request.getParameter("br_id");


	String st_dt 	= request.getParameter("st_dt")	 	==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt") 	==null?"":request.getParameter("end_dt");
	String s_cnt 	= request.getParameter("s_cnt")  	==null?"":request.getParameter("s_cnt");

	int size 	= request.getParameter("size")	 	==null?0:AddUtil.parseDigit(request.getParameter("size"));
	String acct_st 	= request.getParameter("acct_st") 	==null?"":request.getParameter("acct_st");		
	String value_size = request.getParameter("value_size") 	==null?"":request.getParameter("value_size");		
	

	String seq[]  = request.getParameterValues("seq");
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");	
	String value20[] = request.getParameterValues("value20");	
	String result[]  = request.getParameterValues("result");	
	
	size = seq.length;

	
	
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	boolean flag = true;
		
		
	//기존 동일일자 마감분은 삭제
	boolean d_flag = at_db.deleteStatAcct(AddUtil.getDate(), st_dt, end_dt, acct_st);
	

	for(int i = 0 ; i < size ; i++){
		
		Hashtable ht = new Hashtable();
		ht.put("SAVE_DT", 	AddUtil.getDate());
		ht.put("S_DT",		st_dt);
		ht.put("E_DT", 		end_dt);
		ht.put("ACCT_ST", 	acct_st);		
		ht.put("VALUE1",	value1[i]==null?"":value1[i]);
		ht.put("VALUE2",	value2[i]==null?"":value2[i]);
		ht.put("VALUE3",	value3[i]==null?"":value3[i]);
		ht.put("VALUE4",	value4[i]==null?"":value4[i]);
		ht.put("VALUE5",	value5[i]==null?"":value5[i]);
		ht.put("VALUE6",	value6[i]==null?"":value6[i]);
		ht.put("VALUE7",	value7[i]==null?"":value7[i]);
		ht.put("VALUE8",	value8[i]==null?"":value8[i]);
		ht.put("VALUE9",	value9[i]==null?"":value9[i]);
		ht.put("VALUE10",	value10[i]==null?"":value10[i]);
		ht.put("VALUE11",	value11[i]==null?"":value11[i]);
		ht.put("VALUE12",	value12[i]==null?"":value12[i]);
		ht.put("VALUE13",	value13[i]==null?"":value13[i]);
		ht.put("VALUE14",	value14[i]==null?"":value14[i]);
		ht.put("VALUE15",	value15[i]==null?"":value15[i]);
		ht.put("VALUE16",	value16[i]==null?"":value16[i]);
		ht.put("VALUE17",	value17[i]==null?"":value17[i]);
		ht.put("VALUE18",	value18[i]==null?"":value18[i]);
		ht.put("VALUE19",	value19[i]==null?"":value19[i]);
		ht.put("VALUE20",	value20[i]==null?"":value20[i]);				
		ht.put("RESULT", 	result[i]);
		ht.put("REG_ID", 	user_id);
		ht.put("VALUE_SIZE", 	value_size);
		
		vt.add(ht);
	}	

	if(size>0){
		flag = at_db.insertStatAcct(vt);	
	}
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15">
<script language='javascript'>
<!--
	<%if(!flag){%>
		alert('등록오류!!');
	<%}else{%>
		alert('등록되었습니다.');
		parent.f_init();
	<%}%>
//-->
</script>
</body>
</html>
