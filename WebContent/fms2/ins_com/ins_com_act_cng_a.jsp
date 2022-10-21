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

	String vid[] 	= request.getParameterValues("ch_cd");
	String vid2[] 	= request.getParameterValues("chk_cont");
	int vid_size = vid.length;
	
	String act_code  = Long.toString(System.currentTimeMillis());
	
	String vid_num		= "";
	String reg_code 	= "";
	String seq 	= "";
	int    idx = 0;
	int    count = 0;
	int flag = 0;
	
	
	
	for(int i=0;i < vid_size;i++){
	
		vid_num = vid[i];
		
		out.println("vid_num="+vid_num);
		
		int s=0; 
		String app_value[] = new String[7];
		if(vid_num.length() > 0){
			StringTokenizer st = new StringTokenizer(vid_num,"/");
			while(st.hasMoreTokens()){
				app_value[s] = st.nextToken();
				s++;
			}
		}
		
		reg_code = app_value[0];
		seq = app_value[1];
		idx = AddUtil.parseInt(app_value[2]);
		
		
		if(!ic_db.updateInsExcelComActCode(reg_code, AddUtil.parseInt(seq), act_code)){
			flag += 1;
		}
		
	}

	//프로시저 호출
	String  d_flag3 =  ic_db.call_sp_ins_excel_com_cng(act_code, user_id);
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>
		alert("배서 프로시저를 호출했습니다.");
		parent.parent.location.reload();
</script>