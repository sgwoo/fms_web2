<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*, tax.*, acar.cont.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
%>


<%
	String title_st = request.getParameter("title_st")==null?"0":request.getParameter("title_st");
	String doc_end_dt = request.getParameter("doc_end_dt")==null?"0":request.getParameter("doc_end_dt");
	
	String target_id = nm_db.getWorkAuthUser("내용증명담당자");
	String chk_firm_nm = "";
	
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	
	
	String vid1[] 	= request.getParameterValues("rent_l_cd");
	String vid2[] 	= request.getParameterValues("firm_nm");
	String vid3[] 	= request.getParameterValues("post_st");
	String vid4[] 	= request.getParameterValues("post_etc");
	String vid_num		= "";
	
	int vid_size = vid1.length;
	
//	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		String title 	= "[내용증명발송요청]"+vid1[i]+" "+vid2[i];
		String content 	= "최고장종류 : "+title_st+"\n주소종류 : "+vid3[i]+"\n유예기간 : "+doc_end_dt+"\n비고 : "+vid4[i];
		
		cp_bean.setIn_id	(ck_acar_id);
		cp_bean.setTitle	(title);
		cp_bean.setContent(content);
		cp_bean.setOut_id	("");
		cp_bean.setSub_id	(target_id);
		
		count = cp_db.insertCooperation(cp_bean);
		
		
		Hashtable cont = a_db.getContCase(vid1[i]);
		
		Hashtable cont2 = a_db.getContViewCase(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
		
		String car_num = String.valueOf(cont2.get("CAR_NO"));
		String car_name = String.valueOf(cont2.get("CAR_NM"));
		
		//문자수신 : 고객 담당자
		Hashtable sms = c_db.getDmailSms(String.valueOf(cont.get("RENT_MNG_ID")), vid1[i], "1");
		
		String s_destphone = String.valueOf(sms.get("TEL"))==null?"":String.valueOf(sms.get("TEL"));
		String s_destname = String.valueOf(sms.get("NM"))==null?"":String.valueOf(sms.get("NM"));
			
		if(s_destphone.equals("null")) 	s_destphone = "";
		if(s_destname.equals("null")) 	s_destname = "";		
		
		if(!chk_firm_nm.equals(vid2[i]) && !s_destphone.equals("") && s_destphone.length() > 9){	
		
			UsersBean bus2_bean 	= umd.getUsersBean(String.valueOf(cont.get("BUS_ID2")));
		
			//알림톡 acar0043 계약해지 및 차량반납통보
			String customer_name 	= vid2[i];			// 고객이름
			//acar0043->acar0080->acar0210
			List<String> fieldList = Arrays.asList(customer_name, car_num, car_name, bus2_bean.getUser_nm(), bus2_bean.getUser_m_tel());
			//at_db.sendMessageReserve("acar0210", fieldList, s_destphone,  sender_bean.getUser_m_tel(), null , vid1[i],  ck_acar_id);
			
			chk_firm_nm = customer_name; //동일고객 중복체크용
		}
		
	}
	
	if(vid_size>0){
		
		String sub 		= "내용증명발송 업무협조 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 내용증명발송 업무협조를 요청하셨습니다. 확인바랍니다.";
		
		String url 		= "/fms2/cooperation/cooperation_n_frame.jsp";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  					"<ALERTMSG>"+
  					"<BACKIMG>4</BACKIMG>"+
  					"<MSGTYPE>104</MSGTYPE>"+
  					"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";  					

		//받는사람
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
	
	parent.window.close();
</script>
</body>
</html>