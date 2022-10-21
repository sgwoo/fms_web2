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
	
	String vid_num		= "";
	String reg_code 	= "";
	String seq 	= "";
	String chk_cont 	= "";
	int    idx = 0;
	int    count = 0;
	int    chk_count = 0;
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
		
		chk_cont = vid2[idx];
		
		out.println("chk_cont="+chk_cont);
		
		
		InsurExcelBean iec_bean = ic_db.getInsExcelCom(reg_code, seq);
		
		out.println("iec_bean.getGubun()="+iec_bean.getGubun());
		out.println("iec_bean.getUse_st()="+iec_bean.getUse_st());
		
		
		if(iec_bean.getUse_st().equals("요청")){
			out.println("요청 단계에서 반려처리");
			
			iec_bean.setUse_st("반려등록");
			iec_bean.setReq_id(ck_acar_id);
			if(!ic_db.updateInsExcelComUseSt(iec_bean)){
				flag += 1;
			}
			chk_count = 0;
		}
		
		
		if(iec_bean.getUse_st().equals("등록") && chk_cont.equals("정상")){
		
			out.println("요청처리");
			
			iec_bean.setUse_st("요청");
			iec_bean.setReq_id(ck_acar_id);
			if(!ic_db.updateInsExcelComUseSt(iec_bean)){
				flag += 1;
			}
		}
		
		
		if(!vid2[idx].equals("정상")){
			chk_count += 1; 
			
			out.println("미점검 혹은 비정상");
		}
		
		
		//반려하는 경우 추가
		if(iec_bean.getUse_st().equals("확인")){
			
			out.println("반려처리");
			
			iec_bean.setUse_st("반려");
			iec_bean.setReq_id(ck_acar_id);
			if(!ic_db.updateInsExcelComUseSt(iec_bean)){
				flag += 1;
			}
			chk_count = 0;
		}
		
		out.println("<br>");
	}
	
	out.println("flag="+flag);
	out.println("chk_count="+chk_count);
	
	
	
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>
<%	if(flag > 0 || (flag==0 && vid_size==chk_count) ){%>
		alert("처리되지 않았습니다. <%if(chk_count>0){%>미점검 상태인 차량이 있습니다.<%}%>");
<%	}else{		%>		
		alert("처리되었습니다. <%if(chk_count>0){%>미점검 상태인 차량이 있습니다.<%}%>");
		parent.location.reload();
<%	}			%>
</script>