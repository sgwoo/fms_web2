<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*, tax.*, acar.settle_acc.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int count = 0;
	
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	int req_cnt	 		= 0;
	
	for(int i=0;i < vid_size;i++){
		vid_num = vid[i];
		
		rent_mng_id 	= vid_num.substring(0,6);
		rent_l_cd 		= vid_num.substring(6,19);
		
		//장기계약 상단정보
		LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);
		
		//해지일자부터의 경과월수
		Hashtable ht = s_db.getClsUseMon(rent_mng_id, rent_l_cd);
		
		
		if(AddUtil.parseInt(String.valueOf(ht.get("USE_MON")))> 1){//2개월경과후 
			
			
			String title 	= "[채권추심의뢰요청]"+rent_l_cd+" "+base.getFirm_nm();
			String content 	= "채권추심의뢰요청합니다.\n담당자를 총무팀으로 이관해주십시오.\n\n상호 : "+base.getFirm_nm()+"\n계약번호 : "+rent_l_cd+"\n차량번호 : "+base.getCar_no();
			
			
			cp_bean.setIn_id	(ck_acar_id);
			cp_bean.setTitle	(title);
			cp_bean.setContent	(content);
			cp_bean.setOut_id	("");
			cp_bean.setSub_id	(nm_db.getWorkAuthUser("채권관리자"));
			
			count = cp_db.insertCooperation(cp_bean);
			
			req_cnt++;
			
		}
	}
	
	if(vid_size>0){
		if(req_cnt>0){
			UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
			UsersBean target_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("채권관리자"));
			
			String sub 		= "채권추심의뢰 업무협조 등록";
			String cont 	= "["+sender_bean.getUser_nm()+"]님이 채권추심의뢰 업무협조를 요청하셨습니다.\n\n확인바랍니다.";
			
			String url 		= "/fms2/cooperation/cooperation_n2_frame.jsp";
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
	  					"<ALERTMSG>"+
  						"<BACKIMG>4</BACKIMG>"+
  						"<MSGTYPE>104</MSGTYPE>"+
  						"<SUB>"+sub+"</SUB>"+
		  				"<CONT>"+cont+"</CONT>"+
  						"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
						
						//받는사람 // 받는사람 아이디 검색해서 반복해주는 부분
						xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
						//보낸사람
						xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
  					"    <FLDTYPE>1</FLDTYPE>"+
  					"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			flag6 = cm_db.insertCoolMsg(msg);
			
		}
	}
	%>
<script language='javascript'>
<%		if(count==0){	%>	alert('에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'settle_sc.jsp';
	fm.target = 'c_body';
	fm.submit();	
</script>
</body>
</html>