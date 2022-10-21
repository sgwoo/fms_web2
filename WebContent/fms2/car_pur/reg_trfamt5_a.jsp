<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*"%>
<%@ page import="acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String msg_st 		= request.getParameter("msg_st")==null?"":request.getParameter("msg_st");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String trf_amt_send 		= request.getParameter("trf_amt_send")==null?"":request.getParameter("trf_amt_send");
	
	boolean flag1 = true;
	boolean flag3 = true;
	boolean flag5 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	CommiBean emp2 	= a_db.getCommi(m_id, l_cd, "2");
	
	
%>


<%
	//4. 출고정보 car_pur--------------------------------------------------------------------------------------
	
	//car_pur
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	pur.setTrf_st5		(request.getParameter("trf_st5")	==null?"":request.getParameter("trf_st5"));
	pur.setTrf_amt5		(request.getParameter("trf_amt5").equals("")	?0:AddUtil.parseDigit(request.getParameter("trf_amt5")));
	pur.setCard_kind5	(request.getParameter("card_kind5")	==null?"":request.getParameter("card_kind5"));
	pur.setCardno5		(request.getParameter("cardno5")	==null?"":request.getParameter("cardno5"));
	pur.setTrf_cont5	(request.getParameter("trf_cont5")	==null?"":request.getParameter("trf_cont5"));
	pur.setAcc_st5		(request.getParameter("acc_st5")	==null?"":request.getParameter("acc_st5"));
	
	//=====[CAR_PUR] update=====
	flag1 = a_db.updateContPur(pur);
	
	if(trf_amt_send.equals("Y") && pur.getTrf_amt_pay_req().equals("")){
		flag5 = a_db.updateCarPurPayReq(pur, "trf_amt_pay_req");

		String trf_st5_nm = "송금";
		
		if(pur.getTrf_st5().equals("3")){
			trf_st5_nm = "카드";
		}	
	
			// 쿨메신저 메세지 전송------------------------------------------------------------------------------------------
			
			String sub 			= "임시운행보험료 송금요청";
			String cont 		= "[ "+l_cd+" "+firm_nm+" "+c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")+" "+emp2.getCar_off_nm()+" "+AddUtil.parseDecimal(pur.getTrf_amt5())+"원 ]  &lt;br&gt; &lt;br&gt; 임시운행보험료 "+trf_st5_nm+" 요청합니다.";
			String url 			= "";
			String target_id = nm_db.getWorkAuthUser("출금담당");
			String target_id2 = "";
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
			if(!cs_bean.getUser_id().equals(""))	target_id2 = nm_db.getWorkAuthUser("입금담당");
			
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  						"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
 						"    <URL></URL>";
 						
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
			if(!target_id2.equals("")){
				UsersBean target_bean2 	= umd.getUsersBean(target_id2);
				xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
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
			flag3 = cm_db.insertCoolMsg(msg);
			System.out.println("쿨메신저("+l_cd+" "+sub+" )-----------------------"+target_bean.getUser_nm());	

	}
%>

<script language='javascript'>
<%	if(!flag1){%>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>		
		alert("처리되었습니다");
		parent.location='reg_trfamt5.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>';
<%	}			%>
</script>