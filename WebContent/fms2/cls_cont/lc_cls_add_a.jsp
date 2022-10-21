<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*,  acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
		
	boolean flag2 = true;	
	int flag = 0;	
	
	String from_page 	= "";
	
			//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st();
		
	from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	
	// 중도매입옵션 정산금액 결재
	if(!ac_db.updateClsEtcAdd(rent_mng_id, rent_l_cd))	flag += 1;
	
	
	//중도매입옵션 정산금액  관련 메시지 전달	
	// ------------------------------------------------------------------------------------------
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
						
	String sub 		= "중도매입옵션 정산금액 확인 완료";
	String cont 	= "[계약번호:"+rent_l_cd+"]  중도매입옵션 결재요청하시면 됩니다..";	
	
	String url = 	"/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	
	String target_id = cls.getReg_id();  //의뢰자
	
			
	//사용자 정보 조회
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
  				"    <BACKIMG>4</BACKIMG>"+
  				"    <MSGTYPE>104</MSGTYPE>"+
  				"    <SUB>"+sub+"</SUB>"+
  				"    <CONT>"+cont+"</CONT>"+
 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
	
	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	xml_data += "    <TARGET>2006007</TARGET>";
	//xml_data += "    <TARGET>2010014</TARGET>";
	
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
		
	System.out.println("쿨메신저(중도매입옵션 정산금액 확인 결재완료 )"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	

	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");


%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	// 결재 실패%>

	alert('등록 오류발생!');

<%	}else{ 			// 결재 성공.. %>
	
    alert('처리되었습니다');
   	fm.action='/fms2/cls_cont/lc_cls_off_d_frame.jsp';			
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
