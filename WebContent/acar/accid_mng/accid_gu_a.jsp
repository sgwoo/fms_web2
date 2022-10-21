<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, acar.cus_reg.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	String wk_st = request.getParameter("wk_st")==null?"":request.getParameter("wk_st");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int count = 0;
	int res_cnt = 0;
	int scd_cnt = 0;
	
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	if(wk_st.equals("imgdel")){
		count = as_db.deletePicAccid(c_id, accid_id, seq);
	}else if(wk_st.equals("servdel")){
		//예약시스템-정비대차 연결된 정비는 삭제하지 못한다.
		res_cnt = rs_db.getRentContServChk(c_id, serv_id);
		
		//면책금 스케줄 있는거 삭제 못한다.
		scd_cnt = rs_db.getScdExtServChk(c_id, serv_id);
		
		if((res_cnt+scd_cnt) == 0){
			count = cr_db.deleteScdServ(c_id, serv_id);
			count = cr_db.delServ_item_all(c_id, serv_id);
		}
	}
%>

<form name='form1' method='post'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="accid_st" value='<%=accid_st%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="mode" value='<%=mode%>'>
</form>
<script language='javascript'>
<%	if(count == 0){	%>
		alert('삭제 에러입니다.\n\n삭제되지 않았습니다');
<%	}else{	%>
 			
<%		if(wk_st.equals("servdel")){%>					
<%			if(res_cnt > 0 && scd_cnt == 0){%>
			alert("예약시스템-정비대차에 연결되어 있습니다. 예약시스템에서 먼저 삭제해야 합니다.");
<%			}else if(res_cnt == 0 && scd_cnt > 0){%>
			alert("면책금 수금스케줄에 연결되어 있습니다. 삭제할 수 없습니다.");
<%			}else if(res_cnt > 0 && scd_cnt > 0){%>
			alert("예약시스템-정비대차에 연결되어 있고, 면책금 수금스케줄에도 연결되어 있습니다. 삭제할 수 없습니다.");		
<%			}%>		
<%		}%>		

		alert("삭제되었습니다");
		var fm = document.form1;
		fm.target = "d_content";		
		<%if(from_page.equals("/acar/accid_mng/accid_gu.jsp")){%>
		fm.action = "accid_gu.jsp";		
		<%}else{%>
		fm.action = "accid_u_frame.jsp";		
		<%}%>
		fm.submit();				
		
<%	}	%>
</script>
</body>
</html>
