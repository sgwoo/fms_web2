<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ars_card.*, acar.res_search.*, tax.*, ax_hub.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	
	
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	

	String email 		= request.getParameter("email")		==null?"":request.getParameter("email");
	String m_tel 		= request.getParameter("m_tel")		==null?"":request.getParameter("m_tel");
	String am_good_st 	= request.getParameter("am_good_st")	==null?"":request.getParameter("am_good_st");
	String am_good_s_amt 	= request.getParameter("am_good_s_amt")	==null?"":request.getParameter("am_good_s_amt");
	String am_good_v_amt 	= request.getParameter("am_good_v_amt")	==null?"":request.getParameter("am_good_v_amt");
	String am_good_m_amt 	= request.getParameter("am_good_m_amt")	==null?"":request.getParameter("am_good_m_amt");
	String am_good_amt 	= request.getParameter("am_good_amt")	==null?"":request.getParameter("am_good_amt");
	
	
	int count = 0;
	int flag = 0;
	
	
	//String am_ax_code  	= Long.toString(System.currentTimeMillis());
	String am_ax_code  	= "";
	
	//20130830 6자리 랜덤코드
	for(int i=0;i < 100;i++){
		
		String am_ax_code2  	= AddUtil.parseFloatTruncZero(String.valueOf(Math.random()*1000000));
								
		//중복점검			
		AxHubBean ax_bean 	= ax_db.getAxHubCase(am_ax_code2);
						
		if(ax_bean.getAm_ax_code().equals("")){
			am_ax_code = am_ax_code2;
				
			//out.println(am_ax_code2+"<br>");
			//out.println(i+"<br>");
				
			break;	
		}																		
	}	
	
	
	if(!am_ax_code.equals("")){
	
		//ax_hub 등록	
		count = rs_db.insertAxHub(am_ax_code, am_good_st, ars_code, "", Util.parseDigit(am_good_amt), Util.parseDigit(am_good_s_amt), Util.parseDigit(am_good_v_amt), Util.parseDigit(am_good_m_amt), user_id, email, m_tel);
	
	
	
		if(count == 1){
				
			String sendname 	= "(주)아마존카";
			String sendphone 	= "02-392-4243";
			String msg 		= "";
			String title 		= "";
			
			msg = "아마존카 인증번호는 ["+am_ax_code+"]입니다. 월렌트홈페이지에서 결제하시기 바랍니다. -아마존카-";
			
			int i_msglen = AddUtil.lengthb(msg);
		
			String msg_type = "0";
		
			//80이상이면 장문자
			if(i_msglen>80){
				msg_type = "5";
				title = "아마존카 결제인증번호";
			}
				
		
			IssueDb.insertsendMail_V5_H(sendphone, sendname, m_tel, ars.getBuyr_name(), "", "", msg_type, title, msg, "", "", ck_acar_id, "ax_hub");
		}	
	}
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&ars_code="+ars_code;
		   	
%>
<script language='javascript'>
<%	if(!am_ax_code.equals("") && count == 1){%>
		alert('정상적으로 처리되었습니다');
		parent.self.close();		
		parent.opener.location	='ars_card_frame.jsp<%=valus%>';		
		
<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
