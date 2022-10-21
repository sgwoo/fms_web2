<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String com_reg_dt = request.getParameter("com_reg_dt")==null?"":request.getParameter("com_reg_dt");
	
	boolean flag = true;
	boolean flag2 = true;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	
	String vid_num 	= "";
	String ch_m_id		= "";
	String ch_l_cd		= "";
	String ch_user		= "";
	String firm_nm		= "";
	
	int vid_size = vid.length;
	
	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	
	
	for(int i=0;i < vid_size;i++){
		
		vid_num 	= vid[i];
		
		ch_m_id 		= vid_num.substring(0,6);
		ch_l_cd 		= vid_num.substring(6,19);
		ch_user 		= vid_num.substring(19,25);
		firm_nm 		= vid_num.substring(25);
		
		//(String gubun, String m_id, String l_cd, String act_dt, String act_id)
		
		flag = ec_db.updateCarDigitalKey(mode, ch_m_id, ch_l_cd, com_reg_dt, ck_acar_id);
		
		Hashtable est = a_db.getRentEst(ch_m_id, ch_l_cd);
		
				
				String sub 		= "디지털키 등록";
				String cont 	= "["+firm_nm+" "+String.valueOf(est.get("CAR_NO"))+"] 디지털키를 등록하였습니다.";
				
				if(mode.equals("com_cls")) {
					sub 		= "디지털키 해지";
					cont 	= "["+firm_nm+" "+String.valueOf(est.get("CAR_NO"))+"] 디지털키를 해지하였습니다.";
				}
				
				UsersBean target_bean 	= umd.getUsersBean(ch_user);
								
				
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL></URL>";
				
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				
				//휴가시 업무대체자
				CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean.getUser_id());
				if(!cs_bean.getUser_id().equals("")){
					target_bean 	= umd.getUsersBean(cs_bean.getWork_id());
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				}
				
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  				"    <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
				
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");	
				flag2 = cm_db.insertCoolMsg(msg);	
				
	}
	
	
	
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<script language='javascript'>
<%		if(!flag){	%>	alert('디지털키 처리 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>