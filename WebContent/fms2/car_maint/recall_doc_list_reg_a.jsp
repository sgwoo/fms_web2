<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
			
		

	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	
	String cmd			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	int count = 0;
	int cnt = 0;
	boolean flag = true;
	
	String value0[]  = request.getParameterValues("seq_no");
	String value1[]  = request.getParameterValues("rep_cont"); //내역
	String value2[]  = request.getParameterValues("checker_st"); //시행자
	String value3[]  = request.getParameterValues("serv_off_nm"); //시행처
	String value4[]  = request.getParameterValues("serv_dt"); //시행일자
	String value5[]  = request.getParameterValues("chk"); //완결여부
	
	int  seq_no = 0;  //연번
	String rep_cont ="";  //내역
	String checker_st = "";  //시행자
	String serv_off_nm = "";  //시행처
	String serv_dt= "";  //시행일자
	String chk = "";  //완결여부

	
	for(int i=0 ; i < scd_size ; i++){
								
		seq_no = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);
		rep_cont = value1[i]	==null?"" :value1[i];
		checker_st = value2[i]	==null?"" :value2[i];
		serv_off_nm = value3[i]	==null?"" :value3[i];
		serv_dt = value2[i]	==null?"" :value4[i];
		chk = value3[i]	==null?"" :value5[i];
		
		if(!FineDocDb.updateFineDocRecall(doc_id, seq_no, rep_cont, checker_st, serv_off_nm, serv_dt, chk))	count += 1;				
			
	}
	
	if(cmd.equals("d")){

		FineDocListBn.setDoc_id(doc_id);
		FineDocListBn.setRent_l_cd(rent_l_cd);
		
		cnt = FineDocDb.bank_doc_list_del(FineDocListBn);

	}
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<% if(!cmd.equals("d")){%>
<%		if(count != 0){%>
		alert("에러발생!");
<% } else {%>	
		alert("정상적으로 처리되었습니다.");
		parent.opener.location.reload();
		parent.window.close();	

<%		}%>

<%}else{%>
<% if(cnt != 0){%>
		alert("한건 삭제 되었습니다.");
		parent.parent.location.reload();
<%}else{%>
		alert("에러 에러 에러");
<%}
}%>

</script>
</body>
</html>

