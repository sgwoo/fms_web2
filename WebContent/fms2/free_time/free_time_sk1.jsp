<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.free_time.*, acar.user_mng.*, acar.doc_settle.*" %>
<%@ page import="acar.car_sche.*" %>
<%@ page import="acar.schedule.*, acar.res_search.*" %>
<jsp:useBean id="cs_bean" class="acar.car_sche.CarScheBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ft_bean" class="acar.free_time.Free_timeBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>	

<%@ include file="/acar/cookies.jsp" %>

<%

	Free_timeDatabase ftd = Free_timeDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차의뢰자
	String dept_id	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String br_id	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String reg_dt	= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
		
//총무팀장 결재	
	String cm_check = request.getParameter("cm_check")==null?"":request.getParameter("cm_check");
		
	int flag = 0;
			
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //로그인 id
	login_id = login.getCookieValue(request, "acar_id");
	
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String target_id 	= "";
	String sender_id	= "";
	int count = 0;
	int count2 = 0;
	boolean flag6 = true;
	
	String req_id 	= request.getParameter("req_id")==null?"":request.getParameter("req_id");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");

	String doc_st 	= request.getParameter("doc_st")==null?"21":request.getParameter("doc_st");
	String doc_step 	= request.getParameter("doc_step")==null?"":request.getParameter("doc_step");
	String user_id1 	= request.getParameter("user_id1")==null?"":request.getParameter("user_id1");
	String user_id2 	= request.getParameter("user_id2")==null?"":request.getParameter("user_id2");
	String user_id3 	= request.getParameter("user_id3")==null?"":request.getParameter("user_id3");
	String user_id4 	= request.getParameter("user_id4")==null?"":request.getParameter("user_id4");
	String user_id7 	= request.getParameter("user_id7")==null?"":request.getParameter("user_id7");
	String user_id8 	= request.getParameter("user_id8")==null?"":request.getParameter("user_id8");
	String user_id9 	= request.getParameter("user_id9")==null?"":request.getParameter("user_id9");
	String user_id10 	= request.getParameter("user_id10")==null?"":request.getParameter("user_id10");
	

	//문서품의
	DocSettleBean doc = new DocSettleBean();

	doc = d_db.getDocSettleOver_time("21", doc_no);	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));		
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String title 	= request.getParameter("title")==null?"":request.getParameter("title");
	String content 	= request.getParameter("content")==null?"":request.getParameter("content");
	String sch_chk 	= request.getParameter("sch_chk")==null?"":request.getParameter("sch_chk");
	String work_id 	= request.getParameter("work_id")==null?"":request.getParameter("work_id");
	String sch_st 	= "";
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));	
		
	int use_days = 0;
	use_days = AddUtil.parseInt(rs_db.getDay(st_dt, end_dt));
	String dt = "";	

	if(cmd.equals("cm")){ // 결재 등록
	
		ft_bean.setUser_id(user_id);
		ft_bean.setDoc_no(doc_no);
		ft_bean.setCm_check(cm_check);
		
		count = ftd.UpdateFreeCm_check(ft_bean);
			
		int user_su 	= request.getParameter("v3_size")==null?0:AddUtil.parseInt(request.getParameter("v3_size"));
		
		String value1[] = request.getParameterValues("free_dt");
		String value2[] = request.getParameterValues("ov_yn");
		String value3[] = request.getParameterValues("mt_yn");
	 
		int cnt = 0;
		
		if(user_su > 0){
			for(int i=0;i < user_su;i++){
				if(!value1[i].equals("")){
					FreetimeItemBean free_item = new FreetimeItemBean();
					free_item.setUser_id 	(user_id);
					free_item.setDoc_no		(doc_no);
					free_item.setFree_dt	(value1[i]);
					free_item.setOv_yn		(value2[i]);
					free_item.setMt_yn		(value3[i]);
					
			//		System.out.println(" insa free_dt="+value1[i]+ ":ov_yn=" + value2[i] + ":mt_yn=" + value3[i] );
				  
					if(!ftd.updateFreeItem(free_item)) flag += 1;
					cnt ++;				
					
					
				}
			}
		}	
		
		//결재시 SCH_PRV에 데이터 넘김	
		for(int i=0;i < user_su;i++){
			if(!value1[i].equals("")){		
				ScheduleDatabase csd = ScheduleDatabase.getInstance();
				
				cs_bean.setStart_year	(value1[i].substring(0,4));
				cs_bean.setStart_mon	(value1[i].substring(5,7));
				cs_bean.setStart_day	(value1[i].substring(8,10));
				cs_bean.setUser_id		(user_id);
				cs_bean.setTitle		(title);
				cs_bean.setContent		(content);
				cs_bean.setSeq			(seq);
				cs_bean.setSch_kd		("2");
				cs_bean.setSch_st		(sch_st);
				cs_bean.setSch_chk		(sch_chk);
				cs_bean.setWork_id		(work_id);	
				cs_bean.setOv_yn		(value2[i]);
				cs_bean.setGj_ck		("Y");
				cs_bean.setDoc_no		(doc_no);
				
				count = csd.updateCarSche(cs_bean);
			}	
		}
	
		
	//2. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		flag1 = d_db.updateDocSettleOt2(doc_no, "7", "3", sender_id, "21");
				
		
	

	}
%>
<html>
<head><title>FMS</title>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body>

<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<% if(cmd.equals("cm")){
	if(count==1){
	%>
	alert("결재되었습니다.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();					
<%	}

}else if(cmd.equals("d")){
	if(count==1){
%>
	alert("삭제 되었습니다.");
	fm.action=./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	
<%	}	
}else if(cmd.equals("s_cm")){
	if(count==1){
	%>
	alert("메세지 재전송 되었습니다.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	
						
<%	}

}else if(cmd.equals("s_mt")){
	if(count==1){
%>
	alert("무급처리방안 수정되었습니다.");
	fm.action='./free_time_frame.jsp';
	fm.target='d_content';
	fm.submit();	

<%	}
}
%>	
//-->
</script>
</body>
</html>
