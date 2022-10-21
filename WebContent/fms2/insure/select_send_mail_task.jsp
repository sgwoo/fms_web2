<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.client.*, acar.user_mng.*" %>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String vid[] = request.getParameterValues("ch_l_cd");
	
	String client_id = "";	
	String car_mng_id = "";	
	boolean flag = true;
	
	
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = user_bean.getUser_email();
	
	String replyto = "\"아마존카 "+user_bean.getUser_nm()+"\"<"+user_bean.getUser_email()+">";
	
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
		
	
	for(int i=0; i < vid.length; i++){
	
		String gubunVid[] = vid[i].split("/");
		
		
		client_id 		= gubunVid[0];
		car_mng_id 		= gubunVid[1];
		
		
		//고객정보
		ClientBean client = al_db.getNewClient(client_id);
				
		
		if(client_id.length()==6  && client.getCon_agnt_email().length() > 8 && client.getCon_agnt_email().indexOf(".")>0 && client.getCon_agnt_email().indexOf("@")>0 ){
		
			
			//중복체크
			int overchk = ImEmailDb.getFmsInfoMailNotSendChkList(reg_code, "[아마존카] "+client.getFirm_nm()+" 님 업무 전용 자동차 보험 가입 요청서 입니다.", "SSV:"+client.getCon_agnt_email());
			
			if(overchk == 0){
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			("[아마존카] "+client.getFirm_nm()+" 님 업무 전용 자동차 보험 가입 요청서 입니다.");
				d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
				//d_bean.setSql				("SSV:jinoohome@naver.com");
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카\"<"+user_email.trim()+">");
				d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
				//d_bean.setMailto			("\"아마존카\"<jinoohome@naver.com>");
				d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
				d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");				
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				(reg_code+"_insur");
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin계정
				d_bean.setG_idx				(1);//admin계정
				d_bean.setMsgflag     		(0);
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_task_docs.jsp?client_id="+client_id+"&car_mng_id="+car_mng_id);
				d_bean.setEncoding			(3); //파일첨부
				d_bean.setAtc_set			(1);
				
				String reg_code2  = Long.toString(System.currentTimeMillis());
				d_bean.setGubun2		(reg_code2);
		
				flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");						
														
				String add_fileinfo 	= "업무용승용차 손비처리 기준 안내.pdf";
				String add_content 	= "https://fms3.amazoncar.co.kr/doc/amazoncar_comemp_doc3.pdf";
										
				flag = ImEmailDb.insertDEmailEnc4(d_bean.getGubun(), d_bean.getGubun2(), add_fileinfo, add_content);
			
			}									
		}
		
	}
	

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("메일이 정상적으로 발송 되었습니다.");
	//parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	//parent.window.close();				
<%}%>
//-->
</script>

</body>
</html>



